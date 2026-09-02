//
//  OIDCLoginViewModel.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 02.09.26.
//

import Common
import Foundation
import UserStore
import WebKit

@Observable
@MainActor
@available(iOS 26, *)
class OIDCLoginViewModel: SSOLoginViewModel {
    let codeVerifier: String
    var onLoginSuccess: (() -> Void)?

    private let navDecider: OIDCNavDecider

    init(rememberMe: Bool) {
        var config = WebPage.Configuration()
        config.websiteDataStore = .nonPersistent()
        let verifier = PKCEService.generateCodeVerifier()
        self.codeVerifier = verifier
        let codeChallenge = PKCEService.generateCodeChallenge(from: verifier)

        let decider = OIDCNavDecider()
        self.navDecider = decider

        let page = WebPage(configuration: config, navigationDecider: decider)

        super.init(page: page, config: config)

        decider.setCallbacks(
                    onCodeReceived: { [weak self] code in
                        await self?.exchangeCodeCallback(code: code)
                    },
                    onErrorReceived: { [weak self] errorCode in
                        self?.handleAuthError(errorCode: errorCode)
                    }
                )

        if let baseURL = UserSessionFactory.shared.institution?.baseURL {
            var components = URLComponents(
                url: baseURL.appending(path: "oauth2/authorization/oidc"),
                resolvingAgainstBaseURL: true
            )
            components?.queryItems = [
                URLQueryItem(name: "redirect", value: "ios"),
                URLQueryItem(name: "code_challenge", value: codeChallenge),
                URLQueryItem(name: "rememberMe", value: rememberMe.description)
            ]
            if let authURL = components?.url {
                page.load(authURL)
            }
        }
    }

    func exchangeCodeCallback(code: String) async {
        // when callback is intercepted from server, exchange the short-lived code to jwt token
        let response = await LoginServiceFactory.shared.loginOIDC(code: code, codeVerifier: codeVerifier)
        switch response {
        case .success:
            onLoginSuccess?()
        case .failure(let error):
            self.error = UserFacingError(title: error.localizedDescription)
        default:
            break
        }
    }

    private func handleAuthError(errorCode: String) {
            let title: String
            switch errorCode {
            case "deactivated":
                title = "Your Artemis account is deactivated. Please contact support."
            case "invalid_request":
                title = "Invalid authentication request. Please try again."
            case "server_error":
                title = "Server failed to generate an authorization code. Please try again later."
            default:
                title = "Authentication failed (\(errorCode))."
            }
            self.error = UserFacingError(title: title)
        }
}

/// Allows all navigation, but intercepts redirects to "/oauth-callback"
@available(iOS 26, *)
@MainActor
private class OIDCNavDecider: WebPage.NavigationDeciding {
    private var onCodeReceived: ((String) async -> Void)?
    private var onErrorReceived: ((String) -> Void)?

    func setCallbacks(
            onCodeReceived: @escaping (String) async -> Void,
            onErrorReceived: @escaping (String) -> Void
        ) {
            self.onCodeReceived = onCodeReceived
            self.onErrorReceived = onErrorReceived
        }

    func decidePolicy(for response: WebPage.NavigationResponse) async -> WKNavigationResponsePolicy {
        guard let url = response.response.url else {
            return .allow
        }

        // Intercept /oauth-callback from server
        if url.path.contains("oauth-callback"),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            // receive short-lived exchange code
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                await onCodeReceived?(code)
                return .cancel
            } else if let error = components.queryItems?.first(where: { $0.name == "error" })?.value {
                onErrorReceived?(error)
                return .cancel
            }
        }

        return .allow
    }
}
