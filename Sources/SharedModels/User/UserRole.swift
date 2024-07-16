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
        switch self {
        case .instructor:
            R.string.localizable.instructor()
        case .tutor:
            R.string.localizable.tutor()
        case .user:
            R.string.localizable.student()
        }
    }

    public var badgeColor: Color {
        switch self {
        case .instructor:
            return .init(red: 204 / 255, green: 0, blue: 0)
        case .tutor:
            return .init(red: 253 / 255, green: 126 / 255, blue: 20 / 255)
        case .user:
            return .init(red: 23 / 255, green: 162 / 255, blue: 184 / 255)
        }
    }
}
