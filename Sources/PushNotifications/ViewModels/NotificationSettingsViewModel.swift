//
//  NotificationSettingsViewModel.swift
//  
//
//  Created by Anian Schleyer on 03.05.25.
//

import Foundation
import Common
import SwiftUI

@Observable
class NotificationSettingsViewModel {
    private let service = PushNotificationServiceFactory.shared
    private let courseId: Int

    var isLoading = false
    var error: UserFacingError?

    init(courseId: Int) {
        self.courseId = courseId
    }

    var info: DataState<NotificationSettingsInfo> = .loading
    var settings: DataState<NotificationSettings> = .loading

    var presets: [NotificationSettingsPreset] {
        info.value?.presets ?? []
    }

    var currentPreset: NotificationSettingsPresetIdentifier {
        if let number = settings.value?.selectedPreset,
           let preset = presets.first(where: { $0.typeId == number }) {
            return preset.identifier
        }
        return .custom
    }

    var currentSettings: [(CourseNotificationType, [NotificationChannel: Bool])] {
        let types = info.value?.notificationTypes ?? [:]
        let sorted = self.settings.value?.notificationTypeChannels.sorted(by: { lhs, rhs in
            Int(lhs.key) ?? 0 < Int(rhs.key) ?? 0
        })

        return sorted?.map { key, value in
            let type = types[key] ?? .unknown
            return (type, value)
        } ?? []
    }

    func loadInfo() async {
        self.info = await service.getNotificationSettingsInfo()
    }

    func loadSettings() async {
        self.settings = await service.getNotificationSettings(for: courseId)
    }

    func update(type: CourseNotificationType, enabled: Bool) async {
        isLoading = true
        defer {
            isLoading = false
        }

        let number = info.value?.notificationTypes.first {
            $0.value == type
        }?.key ?? "0"

        settings.value?.notificationTypeChannels[number]?[.push]?.toggle()
        settings.value?.selectedPreset = 0

        let channelSetting = settings.value?.notificationTypeChannels[number] ?? [:]

        let result = await service.updateSetting(in: courseId, for: number, setting: channelSetting)
        switch result {
        case .failure(let error):
            self.error = .init(title: error.localizedDescription)
        default:
            break
        }
    }
}
