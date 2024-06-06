//
//  DependencyFactory.swift
//
//
//  Created by Nityananda Zbil on 06.06.24.
//

import Foundation

/// Decides the correct service for live- and test environments.
///
/// Example of a minimal implementation:
///
/// ```swift
/// struct NumberFactory: DependencyFactory {
///     static var liveValue: Int {
///         1
///     }
/// }
/// ```
///
/// Usage: `NumberFactory.shared`
public protocol DependencyFactory {
    associatedtype Value

    static var shared: Value { get }

    static var liveValue: Value { get }

    static var testValue: Value { get }
}

public extension DependencyFactory {
    static var shared: Value {
        CommandLine.arguments.contains("-dependency-factory-test-value") ? Self.testValue : Self.liveValue
    }

    static var testValue: Value {
        Self.liveValue
    }
}
