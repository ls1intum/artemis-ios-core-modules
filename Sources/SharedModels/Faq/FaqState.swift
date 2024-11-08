//
//  FaqState.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 24.10.24.
//

import Foundation

public enum FaqState: String, ConstantsEnum {
    case accepted = "ACCEPTED"
    case rejected = "REJECTED"
    case proposed = "PROPOSED"
    case unknown
}
