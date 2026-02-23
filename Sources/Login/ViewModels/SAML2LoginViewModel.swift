//
//  SAML2LoginViewModel.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.02.26.
//

import Foundation
import UserStore
import WebKit

@Observable
@MainActor
@available(iOS 26, *)
class SAML2LoginViewModel {
    let page: WebPage
    let config: WebPage.Configuration

    init() {
        var config = WebPage.Configuration()
        config.websiteDataStore = .nonPersistent()
        let navDecider = NavDecider(config: config)

        self.page = WebPage(configuration: config, navigationDecider: navDecider)
        self.config = config

        navDecider.setLoginCallback(login: login)

        let baseURL = UserSessionFactory.shared.institution?.baseURL
        page.load(baseURL?.appending(path: "saml2/authenticate"))
    }

    func login(cookies: [HTTPCookie]) async {
        _ = await LoginServiceFactory.shared.loginSAML2(rememberMe: true, samlCookies: cookies)
    }
}

/// Allows all navigation, but intercepts redirect to base URL and calls `login()` instead
@available(iOS 26, *)
private class NavDecider: WebPage.NavigationDeciding {
    let config: WebPage.Configuration
    var login: (([HTTPCookie]) async -> Void)?

    init(config: WebPage.Configuration) {
        self.config = config
    }

    func setLoginCallback(login: @escaping ([HTTPCookie]) async -> Void) {
        self.login = login
    }

    func decidePolicy(for response: WebPage.NavigationResponse) async -> WKNavigationResponsePolicy {
        let url = response.response.url
        let baseUrl = UserSessionFactory.shared.institution?.baseURL?.absoluteString ?? "??"

        if url?.absoluteString.contains(baseUrl) == true && url?.lastPathComponent == "/" {
            let cookieStore = config.websiteDataStore.httpCookieStore
            let cookies = await cookieStore.allCookies()
            await login?(cookies)
            return .cancel
        }

        return .allow
    }
}
