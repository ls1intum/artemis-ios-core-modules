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

    @Published public var saml2: Saml2?
    @Published public var externalUserManagementUrl: DataState<URL> = .loading
    @Published public var externalUserManagementName: DataState<String> = .loading
    @Published public var externalPasswordResetLink: DataState<URL> = .loading
    @Published public var usernamePattern: String?
    @Published public var showUsernameWarning = false

    @Published public var institution: InstitutionIdentifier = .tum
    public enum AuthenticationPhase {
        case username
        case credentials
    }

    @Published public var authenticationPhase: AuthenticationPhase = .username
    @Published public var loginOptions: LoginOptionsDTO?

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

    public func fetchLoginOptions() async {
        isLoading = true
        defer {isLoading = false}
        let result = await service.getLoginOptions(usernameOrEmail: username)
        switch result {
        case .success(let options):
            self.loginOptions = options
            self.authenticationPhase = LoginViewModel.AuthenticationPhase.credentials
        case .failure(let apiClientError):
            if case let .httpURLResponseError(statusCode, _) = apiClientError, statusCode == .notFound {
                // on 404 error (login-option endpoint is not available on the instance) perform a traditional callback to ActiveProfiles
                if let saml2 = self.saml2, saml2.passwordLoginDisabled {
                    self.loginOptions = LoginOptionsDTO(loginMethod: .saml2, idpName: saml2.buttonLabel)
                } else {
                    self.loginOptions = LoginOptionsDTO(loginMethod: .password, idpName: nil)
                }
                self.authenticationPhase = .credentials
            } else {
                // else show an alert
                self.error = UserFacingError(error: apiClientError)
            }
        }
    }

    public func resetToIdentifierPhase() {
        self.authenticationPhase = LoginViewModel.AuthenticationPhase.username
        self.loginOptions = nil
        self.password = ""
    }
    // On change of institution also set the authentication phase to username
    public func handleInstitutionChanged(profileInfo: ProfileInfo?) {
        resetToIdentifierPhase()
        handleProfileInfoReceived(profileInfo: profileInfo)
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

    public func loginWithOIDC() async {
        // 1) generate code verifier
        let codeVerifier = PKCEService.generateCodeVerifier()
        // 2) Get the code_challenge via hashing the code verifier
        let codeChallenge = PKCEService.generateCodeChallenge(from: codeVerifier)
        // 3) Redirect user to /oauth2/authorization/oidc?redirect=vscode&code_challenge={code_challenge}
        // 4) Extract exchange code from server deeplink
        // 5) Fetch the jwt token from /api/core/public/exchange-code?code={someRandomCode}

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
        saml2 = profileInfo?.saml2
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
