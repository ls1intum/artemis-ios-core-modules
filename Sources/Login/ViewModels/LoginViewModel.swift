import APIClient
import Combine
import Common
import Foundation
import ProfileInfo
import SharedModels
import UserStore

@MainActor
open class LoginViewModel: NSObject, ObservableObject {
    @Published public var username: String = "" {
        didSet {
            usernameValidation()
        }
    }
    @Published public var password: String = ""
    @Published public var rememberMe = true

    @Published public var error: UserFacingError? {
        didSet {
            showError = error != nil
        }
    }
    @Published public var showError = false
    @Published public var isLoading = false

    @Published public var loginExpired = false
    @Published public var captchaRequired = false

    @Published public var externalUserManagementUrl: DataState<URL> = .loading
    @Published public var externalUserManagementName: DataState<String> = .loading
    @Published public var externalPasswordResetLink: DataState<URL> = .loading
    @Published public var usernamePattern: String?
    @Published public var showUsernameWarning = false

    @Published public var institution: InstitutionIdentifier = .tum

    private var cancellables: Set<AnyCancellable> = Set()
    internal let service = LoginServiceFactory.shared

    override public init() {
        super.init()

        UserSessionFactory.shared.objectWillChange.sink {
            DispatchQueue.main.async { [weak self] in
                self?.username = UserSessionFactory.shared.username ?? ""
                self?.password = UserSessionFactory.shared.password ?? ""
                self?.loginExpired = UserSessionFactory.shared.tokenExpired
                self?.institution = UserSessionFactory.shared.institution ?? .tum
            }
        }.store(in: &cancellables)

        username = UserSessionFactory.shared.username ?? ""
        password = UserSessionFactory.shared.password ?? ""
        loginExpired = UserSessionFactory.shared.tokenExpired
        institution = UserSessionFactory.shared.institution ?? .tum
    }

    public func login() async {
        let response = await service.login(username: username, password: password, rememberMe: rememberMe)

        switch response {
        case .failure(let error):
            if let loginError = error as? LoginError {
                switch loginError {
                case .captchaRequired:
                    await getProfileInfo()
                    isLoading = false
                    captchaRequired = true
                    self.error = UserFacingError(title: R.string.localizable.account_captcha_alert_message())
                }
            } else if let apiClientError = error as? APIClientError {
                isLoading = false
                if case let .httpURLResponseError(statusCode, _) = apiClientError, statusCode == .unauthorized {
                    self.error = UserFacingError(title: "Username or password incorrect.\nPlease try again.")
                } else {
                    self.error = UserFacingError(error: apiClientError)
                }
            } else {
                isLoading = false
                self.error = UserFacingError(title: error.localizedDescription)
            }
        default:
            isLoading = false
            let isTumUrl = UserSessionFactory.shared.institution?.baseURL?.absoluteString.contains(".tum.") ?? false
            if UserSessionFactory.shared.isLoggedIn && isTumUrl {
                UserSessionFactory.shared.didLogInWithPassword = true
            }
            return
        }
    }

    public func resetLoginExpired() {
        UserSessionFactory.shared.setTokenExpired(expired: false)
    }

    public func getProfileInfo() async {
        isLoading = true
        let response = await ProfileInfoServiceFactory.shared.getProfileInfo()
        isLoading = false

        switch response {
        case .loading:
            return
        case .failure(let error):
            self.error = error
        case .done(let response):
            handleProfileInfoReceived(profileInfo: response)
        }
    }

    public func handleProfileInfoReceived(profileInfo: ProfileInfo?) {
        if let externalUserManagementURL = profileInfo?.externalUserManagementURL {
            self.externalUserManagementUrl = .done(response: externalUserManagementURL)
        } else {
            self.externalUserManagementUrl = .loading
        }
        if let externalUserManagementName = profileInfo?.externalUserManagementName {
            self.externalUserManagementName = .done(response: externalUserManagementName)
        } else {
            self.externalUserManagementUrl = .loading
        }
        if let allowedLdapUsernamePattern = profileInfo?.allowedLdapUsernamePattern,
           profileInfo?.accountName == "TUM" {
            self.usernamePattern = allowedLdapUsernamePattern
        } else {
            self.usernamePattern = nil
        }
        if let externalPasswordResetLinkMap = profileInfo?.externalPasswordResetLinkMap,
           let url = URL(string: externalPasswordResetLinkMap[Language.currentLanguage.rawValue] ?? "") {
            self.externalPasswordResetLink = .done(response: url)
        } else {
            self.externalPasswordResetLink = .loading
        }
        showUsernameWarning = false
        usernameValidation()
    }

    private func usernameValidation() {
        if username.count > 6,
           let usernamePattern,
           username.range(of: usernamePattern, options: .regularExpression) == nil {
            showUsernameWarning = true
        }
    }
}
