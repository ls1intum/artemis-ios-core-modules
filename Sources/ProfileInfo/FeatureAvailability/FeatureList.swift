//
//  FeatureList.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.03.25.
//

import Common
import Foundation

@Observable
public class FeatureList {
    public static let shared = FeatureList()

    var availableFeatures = [String]()
    public var compatibleVersions: PlatformVersionCompatibility?

    private var lastChecked: Date = .distantPast

    private init() {}

    /// In case the last check was more than 60 seconds ago or failed,
    /// perform a request to the server to check available features and supported client versions.
    public func checkAvailability(forceCheck: Bool = false) async {
        if lastChecked.timeIntervalSinceNow < -60 || forceCheck {
            log.info("Checking feature list and min versions")
            let service = ProfileInfoServiceFactory.shared
            let info = await service.getProfileInfo()
            switch info {
            case .failure:
                lastChecked = .distantPast
            case .done(let response):
                availableFeatures = response.features
                compatibleVersions = response.compatibleVersions
                lastChecked = .now
            default:
                break
            }
        }
    }
}
