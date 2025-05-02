//
//  PasskeySettingsViewModel.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 02.05.25.
//

import AuthenticationServices
import Common
import os
import SwiftUI

@Observable
class PasskeySettingsViewModel: NSObject, ASAuthorizationControllerDelegate {
    private let service = PasskeyServiceFactory.shared

    var passkeys: DataState<[Passkey]> = .loading

    var error: UserFacingError?
    var isLoading = false

    func loadPasskeys() async {
        passkeys = await service.getPasskeys()
    }

    /// Initiates a request to iOS to generate a new passkey
    func registerPasskey(controller: AuthorizationController) async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            let result = try await controller.performRequest(passkeyRegistrationRequest())
            switch result {
            case .passkeyRegistration(let registration):
                Logger.authorization.log("Passkey registration succeeded: \(registration)")
                await handlePasskeyRegistration(registration)
            default:
                break
            }
        } catch let error as ASAuthorizationError where error.code == .canceled {
            // The user cancelled the registration.
            Logger.authorization.log("The user cancelled passkey registration.")
        } catch {
            // Some other error occurred while handling the registration.
            Logger.authorization.error("""
            Passkey registration handling failed. \
            Caught an error during passkey registration: \(error.localizedDescription).
            """)
            self.error = .init(title: "Failed to register passkey: \(error.localizedDescription)")
        }
    }

    /// Fetches required data (challenge, user info) from the server to create passkey from
    private func passkeyRegistrationRequest() async throws -> ASAuthorizationRequest {
        let challenge = await service.getPasskeyRegistrationChallenge()
        switch challenge {
        case .success(let data):
            return ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: data.rp.id)
                .createCredentialRegistrationRequest(challenge: data.challengeData,
                                                     name: data.user.name,
                                                     userID: Data(data.user.id.utf8))
        case .failure(let error):
            throw error
        }
    }

    /// Registers the generated passkey on the server by sending signed challenge
    private func handlePasskeyRegistration(_ registration: ASAuthorizationPlatformPublicKeyCredentialRegistration) async {
        let credentialId = registration.credentialID.base64URLEncodedString()
        let attestationObject = registration.rawAttestationObject?.base64URLEncodedString() ?? ""
        let clientDataJSON = registration.rawClientDataJSON.base64URLEncodedString()

        let credResponse = CredentialResponse(attestationObject: attestationObject,
                                              clientDataJSON: clientDataJSON)
        let credential = PasskeyCredential(id: credentialId,
                                           rawId: credentialId,
                                           response: credResponse)

        let response = await service.registerPasskey(credential: credential)
        switch response {
        case .failure(let error):
            self.error = .init(title: "Failed to register passkey: \(error.localizedDescription)")
        default:
            await loadPasskeys()
        }
    }
}
