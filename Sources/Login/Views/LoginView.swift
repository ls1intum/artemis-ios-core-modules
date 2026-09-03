import AuthenticationServices
import Common
import DesignLibrary
import Foundation
import SwiftUI

public struct LoginView: View {
    enum FocusField {
        case username, password
    }

    @Environment(\.authorizationController) var authorizationController
    @StateObject private var viewModel = LoginViewModel()

    @State private var ssoType: SSOType?
    @State private var isInstitutionSelectionPresented = false
    @FocusState private var focusedField: FocusField?

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.Artemis.loginBackgroundColor
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: .xl) {
                        header
                        // first, always ask for username
                        if viewModel.authenticationPhase == .username {
                            Text(R.string.localizable.login_enter_username_to_continue(viewModel.institution.shortName))
                                .font(.customBody)
                                .multilineTextAlignment(.center)
                            VStack(spacing: .l) {
                                usernameInput
                            }.frame(maxWidth: 520)
                            Button(R.string.localizable.login_continue_button_text()) {
                                Task {
                                    await viewModel.fetchLoginOptions()
                                }
                            }
                            .disabled(viewModel.username.isEmpty)
                            .buttonStyle(ArtemisButton())
                        } else if viewModel.authenticationPhase == .credentials, let options = viewModel.loginOptions {
                            VStack(spacing: .l) {
                                usernameInput.disabled(true).foregroundColor(.secondary)

                                // Provide user with according authentication for given username
                                switch options.loginMethod {
                                case .password:
                                    passwordInput

                                    Toggle(R.string.localizable.login_remember_me_label(), isOn: $viewModel.rememberMe)
                                        .toggleStyle(.switch)
                                        .tint(Color.Artemis.toggleColor)

                                    Button(R.string.localizable.login_perform_login_button_text()) {
                                        Task { await viewModel.login() }
                                    }
                                    .disabled(viewModel.password.count < 8)
                                    .buttonStyle(ArtemisButton())

                                    // note: this case is only possible if university artemis instance does not have /login-options ednpoint yet
                                    // otherwise options.loginMethod would be .saml2
                                    // so this case is used only for availability of old instances
                                    if let saml2 = viewModel.saml2, #available(iOS 26.0, *) {
                                        orSplitter

                                        Button(saml2.buttonLabel) {
                                            ssoType = .saml2
                                        }
                                        .buttonStyle(ArtemisButton())
                                    }

                                case .oidc:
                                    Toggle(R.string.localizable.login_remember_me_label(), isOn: $viewModel.rememberMe)
                                        .toggleStyle(.switch)
                                        .tint(Color.Artemis.toggleColor)

                                    let idpTitle = options.idpName ?? R.string.localizable.login_default_sso_name()
                                    Button(R.string.localizable.login_sign_in_with_idp(idpTitle)) {
                                        ssoType = .oidc
                                    }
                                    .buttonStyle(ArtemisButton())

                                case .saml2:
                                    Toggle(R.string.localizable.login_remember_me_label(), isOn: $viewModel.rememberMe)
                                        .toggleStyle(.switch)
                                        .tint(Color.Artemis.toggleColor)

                                    let samlTitle = options.idpName ?? R.string.localizable.login_sign_in_with_saml2()
                                    Button(samlTitle) {
                                        ssoType = .saml2
                                    }
                                    .buttonStyle(ArtemisButton())
                                }

                                // Back button returns user to the username phase
                                Button(R.string.localizable.login_back_button_text()) {
                                    viewModel.resetToIdentifierPhase()
                                }
                            }
                            .frame(maxWidth: 520)
                        }

                        // Passkey only supported for Artemis app itself
                        if Bundle.main.bundleIdentifier == "de.tum.cit.ase.artemis" {
                            orSplitter
                            Button(R.string.localizable.signInPasskey()) {
                                Task {
                                    await viewModel.loginWithPasskey(controller: authorizationController)
                                }
                            }
                            .buttonStyle(ArtemisButton())
                        }
                        Spacer()

                        footer
                    }
                    .frame(minHeight: geometry.size.height - 2 * .l)
                    .frame(maxWidth: .infinity)
                }
                .contentMargins(.l, for: .scrollContent)
            }
        }
        .onSubmit {
            if focusedField == .username {
                focusedField = nil
                Task {
                    await viewModel.fetchLoginOptions()
                }
            } else if focusedField == .password {
                focusedField = nil
                Task {
                    await viewModel.login()
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            if #unavailable(iOS 26) {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(R.string.localizable.done()) {
                        focusedField = nil
                    }
                }
            }
        }
        .loadingIndicator(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showError, error: viewModel.error, actions: {})
        .alert(isPresented: $viewModel.loginExpired) {
            Alert(
                title: Text(R.string.localizable.account_session_expired_error()),
                dismissButton: .default(
                    Text(R.string.localizable.ok()),
                    action: {
                        viewModel.resetLoginExpired()
                    }
                )
            )
        }
        // open sheet if ssoType is not nil
        .sheet(item: $ssoType) { type in
            if #available(iOS 26.0, *) {
                SSOLoginView(ssoType: type, rememberMe: viewModel.rememberMe)
            }
        }
        .task {
            await viewModel.getProfileInfo()
        }
    }
}

enum SSOType: String, Identifiable {
    case saml2
    case oidc

    var id: String { rawValue }
}

private extension LoginView {
    var header: some View {
        VStack(spacing: .l) {
            Text(R.string.localizable.account_screen_title())
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(R.string.localizable.account_screen_subtitle())
                .font(.customBody)
                .multilineTextAlignment(.center)
                .padding(.bottom, .xl)

            if viewModel.captchaRequired {
                DataStateView(data: $viewModel.externalUserManagementUrl, retryHandler: viewModel.getProfileInfo) { externalUserManagementURL in
                    DataStateView(data: $viewModel.externalUserManagementName, retryHandler: viewModel.getProfileInfo) { externalUserManagementName in
                        VStack {
                            Text(R.string.localizable.account_captcha_title())
                            Text(.init(R.string.localizable.account_captcha_message(externalUserManagementName,
                                                                                    externalUserManagementURL.absoluteString,
                                                                                    externalUserManagementURL.absoluteString)))
                        }
                        .padding()
                        .border(.red)
                    }
                }
            }
        }
        .padding(.top)
    }

    var footer: some View {
        VStack(spacing: .l) {
            if let url = viewModel.externalPasswordResetLink.value {
                Button(R.string.localizable.login_forgot_password_label()) {
                    UIApplication.shared.open(url)
                }
            }

            Button(R.string.localizable.account_change_artemis_instance_label()) {
                isInstitutionSelectionPresented = true
            }
            .sheet(isPresented: $isInstitutionSelectionPresented) {
                NavigationStack {
                    InstitutionSelectionView(
                        institution: $viewModel.institution,
                        handleProfileInfoCompletion: viewModel.handleInstitutionChanged
                    )
                    .navigationTitle(R.string.localizable.account_select_artemis_instance_select_title())
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    var usernameInput: some View {
        VStack(alignment: .leading, spacing: .xxs) {
            Text(R.string.localizable.login_username_label())
            TextField(R.string.localizable.login_your_username_label(), text: $viewModel.username)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
            if viewModel.showUsernameWarning {
                Text(String(R.string.localizable.login_username_validation_tum_info_label()))
                    .foregroundColor(Color.Artemis.infoLabel)
                    .font(.callout)
            }
        }
    }

    var passwordInput: some View {
        VStack(alignment: .leading, spacing: .xxs) {
            Text(R.string.localizable.login_password_label)
            SecureField(R.string.localizable.login_your_password_label(), text: $viewModel.password)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .password)
                .submitLabel(.continue)
        }
    }

    var orSplitter: some View {
        HStack(spacing: .m) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            Text(R.string.localizable.login_or_divider())
                .font(.subheadline)
                .foregroundColor(.secondary)

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
        .frame(maxWidth: 520)
    }
}
