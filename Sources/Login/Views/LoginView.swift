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

                        Text(R.string.localizable.login_please_sign_in_account(viewModel.institution.shortName))
                            .font(.customBody)
                            .multilineTextAlignment(.center)

                        // Passkey only supported for Artemis app itself
                        if Bundle.main.bundleIdentifier == "de.tum.cit.ase.artemis" {
                            Button(R.string.localizable.signInPasskey()) {
                                Task {
                                    await viewModel.loginWithPasskey(controller: authorizationController)
                                }
                            }
                            .buttonStyle(ArtemisButton())
                        }

                        VStack(spacing: .l) {
                            usernameInput
                            passwordInput
                            Toggle(R.string.localizable.login_remember_me_label(), isOn: $viewModel.rememberMe)
                                .toggleStyle(.switch)
                                .tint(Color.Artemis.toggleColor)
                        }
                        .frame(maxWidth: 520)

                        Button(R.string.localizable.login_perform_login_button_text()) {
                            viewModel.isLoading = true
                            Task {
                                await viewModel.login()
                            }
                        }
                        .disabled(viewModel.username.isEmpty || viewModel.password.count < 8)
                        .buttonStyle(ArtemisButton())

                        Spacer()

                        footer
                    }
                    .frame(minHeight: geometry.size.height - 2 * .l)
                }
                .scrollPosition(id: $scrollPosition)
                .contentMargins(.l, for: .scrollContent)
            }
        }
        .onSubmit {
            if focusedField == .username {
                focusedField = .password
            } else if focusedField == .password {
                focusedField = nil
                viewModel.isLoading = true
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
        .task {
            await viewModel.getProfileInfo()
        }
    }
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
                        handleProfileInfoCompletion: viewModel.handleProfileInfoReceived
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
}
