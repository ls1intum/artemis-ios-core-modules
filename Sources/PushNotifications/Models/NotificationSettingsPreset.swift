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
            R.string.localizable.settingsPresetCustom()
        case .defaultUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetDefault()
        case .allActivityUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetAllActivity()
        case .ignoreUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetIgnoreAll()
        case .unknown:
            ""
        }
    }

    var description: String {
        switch self {
        case .custom:
            R.string.localizable.settingsPresetDescriptionCustom()
        case .defaultUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetDescriptionDefault()
        case .allActivityUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetDescriptionAllActivity()
        case .ignoreUserCourseNotificationSettingPreset:
            R.string.localizable.settingsPresetDescriptionIgnoreAll()
        case .unknown:
            ""
        }
    }
}
