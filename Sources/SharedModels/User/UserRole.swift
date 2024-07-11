//
//  UserRole.swift
//  
//
//  Created by Sven Andabaka on 06.04.23.
//

import Foundation
import SwiftUI

public enum UserRole: String, RawRepresentable, Codable {
    case instructor = "INSTRUCTOR"
    case tutor = "TUTOR"
    case user = "USER"

    public var displayName: String {
        rawValue.capitalized
    }

    public var badgeColor: Color {
        switch self {
        case .instructor:
            return .init(red: 204, green: 0, blue: 0)
        case .tutor:
            return .init(red: 253, green: 126, blue: 20)
        case .user:
            return .init(red: 23, green: 162, blue: 184)
        }
    }
}
