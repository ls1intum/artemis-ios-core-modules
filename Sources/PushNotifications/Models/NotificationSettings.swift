//
//  NotificationSettings.swift
//
//
//  Created by Anian Schleyer on 03.05.23.
//

import Foundation
import SharedModels

public struct NotificationSettingsInfo: Codable {
    let notificationTypes: [String: CourseNotificationType]
    let channels: [NotificationChannel]
    let presets: [NotificationSettingsPreset]
}

public struct NotificationSettings: Codable {
    let selectedPreset: Int
    let notificationTypeChannels: [String: [NotificationChannel: Bool]]
}

enum NotificationChannel: String, CodingKeyRepresentable, ConstantsEnum {
    case web = "WEBAPP"
    case push = "PUSH"
    case email = "EMAIL"
    case unknown
}

protocol NotificationSetting {
    var settingsTitle: String { get }
}
