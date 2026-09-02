//
//  PKCEService.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 02.09.26.
//

import CryptoKit
import Foundation

enum PKCEService {
    // Generates a high-entropy cryptographic code_verifier according to RFC 7636 (43 characters, URL-safe).
    static func generateCodeVerifier() -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes).base64URLEncodedString()
    }
    // Computes the S256 code_challenge: Base64URL(SHA256(ASCII(code_verifier))) without padding.
    static func generateCodeChallenge(from verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else { return "" }
        let hash = SHA256.hash(data: data)
        return Data(hash).base64URLEncodedString()
    }
}

private extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))
    }
}
