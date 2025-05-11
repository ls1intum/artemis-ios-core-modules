//
//  NotificationSettings.swift
//
//
//  Created by Anian Schleyer on 03.05.23.
//

import Foundation
import SharedModels

struct NotificationSettingsInfo: Codable {
    let notificationTypes: [String: CourseNotificationType]
    let channels: [NotificationChannel]
    let presets: [NotificationSettingsPreset]
}

enum NotificationChannel: String, CodingKeyRepresentable, ConstantsEnum {
    case web = "WEBAPP"
    case push = "PUSH"
    case email = "EMAIL"
    case unknown
}

struct NotificationSettingsPreset: Codable {
    let identifier: String
    let typeId: Int
    let presetMap: [CourseNotificationType: [NotificationChannel: Bool]]
}

struct NotificationSettings: Codable {
    let selectedPreset: Int
    let notificationTypeChannels: [String: [NotificationChannel: Bool]]
}
