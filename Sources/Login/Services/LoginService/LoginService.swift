//
//  File.swift
//
//
//  Created by Sven Andabaka on 09.01.23.
//

import Common

public protocol LoginService {
    /**
     * Perform a login request to the server.
     */
    func login(username: String, password: String, rememberMe: Bool) async -> NetworkResponse

    /**
     * Perform a request to the server to obtain a login challenge for passkeys.
     */
    func getPasskeyLoginChallenge() async -> Result<PasskeyLoginChallenge, UserFacingError>

    /**
     * Perform a login request with a signed passkey challenge.
     */
    func loginWithPasskey(authenticatorData: String, clientDataJSON: String, signature: String, userHandle: String, credentialId: String) async -> Result<Bool, UserFacingError>
}

enum LoginServiceFactory {
    static let shared: LoginService = LoginServiceImpl()
}
