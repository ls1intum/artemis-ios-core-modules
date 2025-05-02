//
//  LoginViewModel+Passkey.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 01.05.25.
//

import APIClient
import AuthenticationServices
import SwiftUI
import os
import UserStore

extension Logger {
    static let authorization = Logger(subsystem: "Login", category: "Passkey")
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    /// Initiates a Passkey login
    public func loginWithPasskey(controller: AuthorizationController) async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            let result = try await controller.performRequest(passkeyAssertionRequest())
            switch result {
            case .passkeyAssertion(let assertion):
                await performLogin(with: assertion)
            default:
                break
            }
        } catch let error as ASAuthorizationError where error.code == .canceled {
            // The user cancelled the authorization.
            Logger.authorization.log("The user cancelled passkey authorization.")
        } catch {
            Logger.authorization.error("Passkey authorization failed: \(error.localizedDescription)")
            self.error = .init(title: "Passkey authorization failed: \(error.localizedDescription)")
        }
    }

    /// Obtains a challenge from the server to sign
    private func passkeyAssertionRequest() async throws -> ASAuthorizationRequest {
        let response = await service.getPasskeyLoginChallenge()
        switch response {
        case .success(let challenge):
            return ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: challenge.rpId)
                .createCredentialAssertionRequest(challenge: challenge.challengeData)
        case .failure(let error):
            throw error
        }
    }

    /// Perfoms the login with the server by sending the signed challenge back
    private func performLogin(with assertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async {
        Logger.authorization.log("Passkey authorization succeeded: \(assertion)")

        let credentialId = assertion.credentialID.base64URLEncodedString()
        let authenticatorData = assertion.rawAuthenticatorData?.base64URLEncodedString() ?? ""
        let clientDataJSON = assertion.rawClientDataJSON.base64URLEncodedString()
        let signature = assertion.signature.base64URLEncodedString()
        let userHandle = String(decoding: assertion.userID, as: UTF8.self)

        let response = await service.loginWithPasskey(authenticatorData: authenticatorData,
                                                      clientDataJSON: clientDataJSON,
                                                      signature: signature,
                                                      userHandle: userHandle,
                                                      credentialId: credentialId)

        switch response {
        case .failure(let error):
            self.error = .init(title: error.localizedDescription)
        default:
            break
        }
    }
}
