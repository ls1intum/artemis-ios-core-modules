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

    init() {
        var config = WebPage.Configuration()
        config.websiteDataStore = .nonPersistent()
        let verifier = PKCEService.generateCodeVerifier()
        self.codeVerifier = verifier
        let codeChallenge = PKCEService.generateCodeChallenge(from: verifier)

        let navDecider = OIDCNavDecider()
        let page = WebPage(configuration: config, navigationDecider: navDecider)

        super.init(page: page, config: config)

        navDecider.setCallback { [weak self] code in
            await self?.exchangeCode(code: code)
        }

        if let baseURL = UserSessionFactory.shared.institution?.baseURL {
            var components = URLComponents(
                url: baseURL.appending(path: "oauth2/authorization/oidc"),
                resolvingAgainstBaseURL: true
            )
            components?.queryItems = [
                URLQueryItem(name: "redirect", value: "vscode"), // или "ios", если настроен
                URLQueryItem(name: "code_challenge", value: codeChallenge)
            ]
            if let authURL = components?.url {
                page.load(authURL)
            }
        }
    }

    func exchangeCode(code: String) async {
        // Здесь дергаем LoginService для обмена code + codeVerifier на JWT токен
        print("Code received: \(code), verifier: \(codeVerifier)")
    }
}

@available(iOS 26, *)
private class OIDCNavDecider: WebPage.NavigationDeciding {
    private var onCodeReceived: ((String) async -> Void)?

    func setCallback(callback: @escaping (String) async -> Void) {
        self.onCodeReceived = callback
    }

    func decidePolicy(for response: WebPage.NavigationResponse) async -> WKNavigationResponsePolicy {
        guard let url = response.response.url else {
            return .allow
        }

        // intercept redirects containing the "code" query
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
            
            // Останавливаем навигацию браузера и отдаем код приложению
            await onCodeReceived?(code)
            return .cancel
        }

        return .allow
    }
}
