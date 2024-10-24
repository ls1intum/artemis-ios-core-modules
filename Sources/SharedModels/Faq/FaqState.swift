//
//  FaqState.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 24.10.24.
//

import Foundation

public enum FaqState: String, Codable {
    case accepted = "ACCEPTED"
    case rejected = "REJECTED"
    case proposed = "PROPOSED"
}
