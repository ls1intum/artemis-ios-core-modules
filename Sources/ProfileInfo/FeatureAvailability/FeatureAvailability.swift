//
//  FeatureAvailability.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.03.25.
//

import Foundation

/// Property Wrapper for accessing Feature Toggle values, thus conditionally hiding Views.
@propertyWrapper
public struct FeatureAvailability {
    private let feature: Feature
    public init(_ feature: Feature) {
        self.feature = feature
    }

    public var wrappedValue: Bool {
        FeatureList.shared.availableFeatures.contains(feature.rawValue)
    }
}

public enum Feature: String {
    case courseNotifications = "CourseSpecificNotifications"
    case globalSearch = "GlobalSearch"
}

/// Property Wrapper for checking whether a module feature is enabled on the instance, thus conditionally hiding Views.
///
/// Module features are configured via Spring properties on the server (e.g. an instance set up without Iris/AI),
/// which is complementary to ``FeatureAvailability`` that reflects feature toggles.
@propertyWrapper
public struct ModuleFeatureAvailability {
    private let feature: ModuleFeature
    public init(_ feature: ModuleFeature) {
        self.feature = feature
    }

    public var wrappedValue: Bool {
        FeatureList.shared.availableModuleFeatures.contains(feature.rawValue)
    }
}

public enum ModuleFeature: String {
    case iris
}
