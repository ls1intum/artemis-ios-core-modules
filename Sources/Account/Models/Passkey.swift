//
//  Passkey.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 03.05.25.
//

import Foundation

struct Passkey: Codable {
    let credentialId: String
    let label: String
    let created: Date
    let lastUsed: Date
}
