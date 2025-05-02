//
//  PasskeyCredential.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 03.05.25.
//

public struct PasskeyCredential: Codable {
    var authenticatorAttachment = "platform"
    let id: String
    let rawId: String
    var type = "public-key"
    let response: CredentialResponse
}

struct CredentialResponse: Codable {
    let attestationObject: String
    let clientDataJSON: String
    var transports = ["internal", "hybrid"]
}
