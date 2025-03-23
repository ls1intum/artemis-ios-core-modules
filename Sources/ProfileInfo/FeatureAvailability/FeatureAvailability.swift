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
}
