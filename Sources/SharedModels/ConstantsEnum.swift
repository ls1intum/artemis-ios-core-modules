//
//  ConstantsEnum.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 08.11.24.
//

import Foundation

/// Protocol to conform enums for Codable data to.
/// If new values are added, `.unknown` will be used instead of causing a decoding failure.
/// Usage:
/// ```swift
/// public enum ProgrammingLanguage: String, ConstantsEnum {
///     case java = "JAVA"
///     case swift = "SWIFT"
///     case unknown
/// }
/// ```
public protocol ConstantsEnum: RawRepresentable, Codable, CaseIterable {
    static var unknown: Self { get }
}

public extension ConstantsEnum {
    init(from decoder: any Decoder) throws {
        let string = try decoder.singleValueContainer().decode(String.self)
        self = Self.allCases.first { $0.rawValue as? String == string } ?? .unknown
    }
}
