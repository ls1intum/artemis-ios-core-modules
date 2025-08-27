//
//  PasskeyServiceImpl.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 03.05.25.
//

import APIClient
import Common
import Foundation
import os

class PasskeyServiceImpl: PasskeyService {
    private let client = APIClient()

    struct GetPasskeysRequest: APIRequest {
        typealias Response = [Passkey]

        var resourceName: String {
            "api/core/passkey/user"
        }

        var method: HTTPMethod { .get }
    }

    func getPasskeys() async -> DataState<[Passkey]> {
        let response = await client.sendRequest(GetPasskeysRequest())
        switch response {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: .init(error: error))
        }
    }

    struct RegistrationChallengeRequest: APIRequest {
        typealias Response = PasskeyRegistrationChallenge

        var resourceName: String {
            "webauthn/register/options"
        }

        var method: HTTPMethod { .post }
    }

    func getPasskeyRegistrationChallenge() async -> Result<PasskeyRegistrationChallenge, UserFacingError> {
        let data = await client.sendRequest(RegistrationChallengeRequest())
        switch data {
        case .success((let response, _)):
            return .success(response)
        case .failure(let error):
            return .failure(.init(error: error))
        }
    }

    struct RegisterRequest: APIRequest {
        typealias Response = RawResponse

        var resourceName: String {
            "webauthn/register"
        }

        var method: HTTPMethod { .post }

        let publicKey: PublicKey
    }

    struct PublicKey: Codable {
        let credential: PasskeyCredential
        let label: String
    }

    func registerPasskey(credential: PasskeyCredential) async -> NetworkResponse {
        let publicKey = PublicKey(credential: credential, label: "Passkey iOS")
        let request = RegisterRequest(publicKey: publicKey)
        let response = await client.sendRequest(request)
        switch response {
        case .success((let response, _)):
            return .success
        case .failure(let error):
            return .failure(error: error)
        }
    }

    struct DeletePasskeyRequest: APIRequest {
        typealias Response = RawResponse

        var resourceName: String {
            "api/core/passkey/\(passkey.credentialId)"
        }

        var passkey: Passkey

        var method: HTTPMethod { .delete }
    }

    func deletePasskey(_ passkey: Passkey) async -> NetworkResponse {
        let response = await client.sendRequest(DeletePasskeyRequest(passkey: passkey))
        switch response {
        case .success((let response, _)):
            return .success
        case .failure(let error):
            return .failure(error: error)
        }
    }
}

enum LoginError: Error {
    case captchaRequired
}

public extension Logger {
    static let authorization = Logger(subsystem: "Login", category: "Passkey")
}
