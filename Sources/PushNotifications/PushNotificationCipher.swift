//
//  File.swift
//
//
//  Created by Sven Andabaka on 19.02.23.
//

import Foundation
import CryptoSwift
import UserStore
import Common

class PushNotificationCipher {

    static func decrypt(payload: String, iv: String) -> PushNotification? {
        // Decode PrivateKey from base64 to String
        guard let privateKey = UserSession.shared.getCurrentNotificationDeviceConfiguration()?.notificationsEncryptionKey,
              let privateKeyAsData = Data(base64Encoded: privateKey) else {
            return nil
        }

        // Decode IV from base64 to String
        guard let ivAsData = Data(base64Encoded: iv) else {
            return nil
        }

        let uint8Key = [UInt8](privateKeyAsData)
        let uint8Iv = [UInt8](ivAsData)

        guard let payloadAsData = Data(base64Encoded: payload) else {
            return nil
        }
        let uint8payload = [UInt8](payloadAsData)

        do {
            let decrypted = try AES(key: uint8Key, blockMode: CBC(iv: uint8Iv), padding: .pkcs7).decrypt(uint8payload)

            // Decode payload
            let decoder = JSONDecoder()

            let version = try decoder.decode(PushNotificationVersion.self, from: Data(decrypted))
            guard version.isValid else {
                throw PushNotificationVersionError.invalidVersion
            }

            return try decoder.decode(PushNotification.self, from: Data(decrypted))
        } catch {
            log.error("error decrypting: \(error)")
            return nil
        }
    }
}
