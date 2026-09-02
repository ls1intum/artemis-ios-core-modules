//
//  LoginService.swift
//
//
//  Created by Sven Andabaka on 09.01.23.
//

import Account
import APIClient
import Common
import WebKit

public protocol LoginService {
    /**
     * Perform a request to the server to retrieve the login option for given username
     */
    func getLoginOptions(usernameOrEmail: String) async -> Result<LoginOptionsDTO, APIClientError>
    /**
     * Perform a login request to the server.
     */
    func login(username: String, password: String, rememberMe: Bool) async -> NetworkResponse

    /**
     * Perform a SAML2 login request to the server.
     */
    func loginSAML2(rememberMe: Bool, samlCookies: [HTTPCookie]) async -> NetworkResponse

    /**
     * Perform a request to the server to obtain a login challenge for passkeys.
     */
    func getPasskeyLoginChallenge() async -> Result<PasskeyLoginChallenge, UserFacingError>

    /**
     * Perform a login request with a signed passkey challenge.
     */
    func loginWithPasskey(authenticatorData: String, clientDataJSON: String, signature: String, userHandle: String, credentialId: String) async -> NetworkResponse
}

enum LoginServiceFactory {
    static let shared: LoginService = LoginServiceImpl()
}
