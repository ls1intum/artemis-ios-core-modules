//
//  PasskeyChallenge.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 02.05.25.
//

import Foundation

public struct PasskeyLoginChallenge: Codable {
    let challenge: String
    public let rpId: String

    public var challengeData: Data {
        Data(base64UrlEncoded: challenge) ?? Data()
    }
}

public struct PasskeyRegistrationChallenge: Codable {
    public let user: PasskeyUser
    public let rp: RelayParty
    let challenge: String

    public var challengeData: Data {
        Data(base64UrlEncoded: challenge) ?? Data()
    }
}

public struct RelayParty: Codable {
    public let id: String
}

public struct PasskeyUser: Codable {
    public let name: String
    public let id: String
    public let displayName: String
}

// MARK: Data+Base64Url
public extension Data {
    func base64URLEncodedString() -> String {
        self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    init?(base64UrlEncoded: String) {
        var base64 = base64UrlEncoded
        base64 = base64.replacingOccurrences(of: "-", with: "+")
        base64 = base64.replacingOccurrences(of: "_", with: "/")
        while !base64.count.isMultiple(of: 4) {
            base64 = base64.appending("=")
        }
        self.init(base64Encoded: base64)
    }
}
