//
//  LoginServiceImpl.swift
//
//
//  Created by Sven Andabaka on 09.01.23.
//

import Account
import APIClient
import Common
import Foundation
import PushNotifications
import SharedServices
import UserStore
import WebKit

class LoginServiceImpl: LoginService {
    private let client = APIClient()

    struct LoginUser: APIRequest {
        typealias Response = RawResponse

        var username: String
        var password: String
        var rememberMe: Bool

        var method: HTTPMethod {
            return .post
        }

        var resourceName: String {
            return "api/core/public/authenticate"
        }
    }

    struct GetLoginOptionsRequest: APIRequest {
        typealias Response = LoginOptionsDTO

        let usernameOrEmail: String

        var method: HTTPMethod { .get }

        var resourceName: String {
            "api/core/public/login-options"
        }

        var params: [URLQueryItem] {
            [URLQueryItem(name: "usernameOrEmail", value: usernameOrEmail)]
        }
    }

    func getLoginOptions(usernameOrEmail: String) async -> Result<LoginOptionsDTO, APIClientError> {
        guard !usernameOrEmail.isEmpty else {
            return .failure(.other(message: "Username or email cannot be empty"))
        }

        let request = GetLoginOptionsRequest(usernameOrEmail: usernameOrEmail)
        let result = await client.sendRequest(request)

        switch result {
        case .success((let options, _)):
            return .success(options)
        case .failure(let error):
            return .failure(error)
        }
    }

    func login(username: String, password: String, rememberMe: Bool) async -> NetworkResponse {
        if !rememberMe {
            UserSessionFactory.shared.saveUsername(username: nil)
            UserSessionFactory.shared.savePassword(password: nil)
        }

        let result = await client.sendRequest(LoginUser(username: username, password: password, rememberMe: rememberMe), currentTry: 3)

        switch result {
        case .success:
            let userResult = await AccountServiceFactory.shared.getAccount()

            switch userResult {
            case .loading:
                return .loading
            case .failure(let error):
                return .failure(error: error)
            case .done:
                if rememberMe {
                    UserSessionFactory.shared.saveUsername(username: username)
                    UserSessionFactory.shared.savePassword(password: password)
                }
                let cookies = URLSession.shared.configuration.httpCookieStorage?.cookies
                let jwt = cookies?.first { $0.name == "jwt" }
                UserSessionFactory.shared.saveToken(jwt?.value)
                UserSessionFactory.shared.setUserLoggedIn(isLoggedIn: true)
                return .success
            }
        case .failure(let error):
            switch error {
            case let .httpURLResponseError(statusCode, artemisError):
                if statusCode == .forbidden && artemisError == "CAPTCHA required" {
                    return .failure(error: LoginError.captchaRequired)
                }
            default:
                return NetworkResponse(error: error)
            }
            return NetworkResponse(error: error)
        }
    }

    func loginSAML2(rememberMe: Bool, samlCookies: [HTTPCookie]) async -> NetworkResponse {
        if !rememberMe {
            UserSessionFactory.shared.saveUsername(username: nil)
            UserSessionFactory.shared.savePassword(password: nil)
        }

        guard let loginUrl = UserSessionFactory.shared.institution?.baseURL?.appending(path: "api/core/public/saml2") else {
            return .failure(error: URLError(.badURL))
        }

        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.httpBody = Data("\(rememberMe)".utf8)

        let session = URLSession(configuration: .ephemeral)
        session.configuration.httpCookieStorage?.setCookies(samlCookies,
                                                            for: loginUrl,
                                                            mainDocumentURL: loginUrl)

        do {
            _ = try await session.data(for: request)

            let cookies = session.configuration.httpCookieStorage?.cookies
            let jwt = cookies?.first { $0.name == "jwt" }

            if let jwt {
                UserSessionFactory.shared.saveToken(jwt.value)
                URLSession.shared.configuration.httpCookieStorage?.setCookie(jwt)
                UserSessionFactory.shared.setUserLoggedIn(isLoggedIn: true)
                return .success
            }

            return .failure(error: URLError(.cancelled))
        } catch {
            return .failure(error: error)
        }
    }

    struct OIDCCodeExchangeDTO: Encodable {
        let code: String
        let codeVerifier: String
    }

    func loginOIDC(code: String, codeVerifier: String) async -> NetworkResponse {
        guard let baseURL = UserSessionFactory.shared.institution?.baseURL else {
            return .failure(error: URLError(.badURL))
        }

        let url = baseURL.appending(path: "api/core/public/exchange-code")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = OIDCCodeExchangeDTO(code: code, codeVerifier: codeVerifier)
        guard let httpBody = try? JSONEncoder().encode(body) else {
            return .failure(error: URLError(.cannotDecodeContentData))
        }
        request.httpBody = httpBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(error: URLError(.badServerResponse))
            }

            guard httpResponse.statusCode == 200 else {
                return .failure(error: UserFacingError(title: "Authentication failed with status code \(httpResponse.statusCode)"))
            }

            guard let jwtToken = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !jwtToken.isEmpty else {
                return .failure(error: URLError(.cannotParseResponse))
            }

            // store jwt Token
            UserSessionFactory.shared.saveToken(jwtToken)

            // create a cookie
            if let host = baseURL.host {
                var properties: [HTTPCookiePropertyKey: Any] = [
                    .domain: host,
                    .path: "/",
                    .name: "jwt",
                    .value: jwtToken,
                    .originURL: baseURL
                ]
                // use secure flag only for https cases
                if baseURL.scheme?.lowercased() == "https" {
                    properties[.secure] = "TRUE"
                }
                if let cookie = HTTPCookie(properties: properties) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }

            // set user as logget in
            UserSessionFactory.shared.setUserLoggedIn(isLoggedIn: true)

            // load the user's data
            let accountResult = await AccountServiceFactory.shared.getAccount()
            switch accountResult {
            case .loading:
                return .loading
            case .failure:
                // account fetch failed but user is logged in
                return .success
            case .done:
                return .success
            }
        } catch {
            return .failure(error: error)
        }
    }

    struct LoginChallengeRequest: APIRequest {
        typealias Response = PasskeyLoginChallenge

        var resourceName: String {
            "webauthn/authenticate/options"
        }

        var method: HTTPMethod { .post }
    }

    func getPasskeyLoginChallenge() async -> Result<PasskeyLoginChallenge, UserFacingError> {
        let data = await client.sendRequest(LoginChallengeRequest())
        switch data {
        case .success((let response, _)):
            return .success(response)
        case .failure(let error):
            return .failure(.init(error: error))
        }
    }

    struct LoginRequest: APIRequest {
        typealias Response = RawResponse

        var resourceName: String {
            "login/webauthn"
        }

        var method: HTTPMethod { .post }

        let authenticatorAttachment = "platform"
        let type = "public-key"
        let id: String
        let rawId: String
        let response: LoginResponse
    }

    struct LoginResponse: Codable {
        let authenticatorData: String
        let clientDataJSON: String
        let signature: String
        let userHandle: String
    }

    func loginWithPasskey(authenticatorData: String, clientDataJSON: String, signature: String, userHandle: String, credentialId: String) async -> NetworkResponse {
        let loginResponse = LoginResponse(authenticatorData: authenticatorData,
                                          clientDataJSON: clientDataJSON,
                                          signature: signature,
                                          userHandle: userHandle)

        let request = LoginRequest(id: credentialId, rawId: credentialId, response: loginResponse)
        let response = await client.sendRequest(request)
        switch response {
        case .success((let success, _)):
            let cookies = URLSession.shared.configuration.httpCookieStorage?.cookies
            let jwt = cookies?.first { $0.name == "jwt" }
            UserSessionFactory.shared.saveToken(jwt?.value)
            UserSessionFactory.shared.saveUsername(username: userHandle)
            UserSessionFactory.shared.setUserLoggedIn(isLoggedIn: true)
            return .success
        case .failure(let error):
            return .failure(error: error)
        }
    }
}

enum LoginError: Error {
    case captchaRequired
}
