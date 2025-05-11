//
//  NotificationSettingsPreset.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 11.05.25.
//

import Foundation
import SharedModels

struct NotificationSettingsPreset: Codable {
    let identifier: NotificationSettingsPresetIdentifier
    let typeId: Int
    let presetMap: [CourseNotificationType: [NotificationChannel: Bool]]
}

enum NotificationSettingsPresetIdentifier: String, ConstantsEnum {
    case defaultUserCourseNotificationSettingPreset
    case allActivityUserCourseNotificationSettingPreset
    case ignoreUserCourseNotificationSettingPreset
    case custom
    case unknown

    var title: String {
        switch self {
        case .custom:
            "Custom"
        case .defaultUserCourseNotificationSettingPreset:
            "Default"
        case .allActivityUserCourseNotificationSettingPreset:
            "All activity"
        case .ignoreUserCourseNotificationSettingPreset:
            "Ignore all"
        case .unknown:
            ""
        }
    }

    var description: String {
        switch self {
        case .custom:
            "Set the settings to your specific needs."
        case .defaultUserCourseNotificationSettingPreset:
            "Receive only essential notifications about the course."
        case .allActivityUserCourseNotificationSettingPreset:
            "Receive all notifications to stay on track at all times."
        case .ignoreUserCourseNotificationSettingPreset:
            "Receive no notifications for the course."
        case .unknown:
            ""
        }
    }
}
