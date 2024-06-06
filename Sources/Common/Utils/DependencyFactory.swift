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
    associatedtype Service

    static var shared: Service { get }

    static var liveValue: Service { get }

    static var testValue: Service { get }
}

public extension DependencyFactory {
    static var shared: Service {
        CommandLine.arguments.contains("-Screenshots") ? Self.testValue : Self.liveValue
    }

    static var testValue: Service {
        Self.liveValue
    }
}
