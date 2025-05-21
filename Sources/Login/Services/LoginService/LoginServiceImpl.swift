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
