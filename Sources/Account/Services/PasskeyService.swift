//
//  PasskeyService.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 03.05.25.
//

import Common

protocol PasskeyService {
    /**
     * Perform a request to fetch a user's passkeys.
     */
    func getPasskeys() async -> DataState<[Passkey]>

    /**
     * Perform a request to the server to obtain a registration challenge for passkeys.
     */
    func getPasskeyRegistrationChallenge() async -> Result<PasskeyRegistrationChallenge, UserFacingError>

    /**
     * Perform a request to the server to register a passkey.
     */
    func registerPasskey(credential: PasskeyCredential) async -> NetworkResponse

    /**
     * Perform a request to the server to delete a passkey.
     */
    func deletePasskey(_ passkey: Passkey) async -> NetworkResponse
}

enum PasskeyServiceFactory {
    static let shared: PasskeyService = PasskeyServiceImpl()
}
