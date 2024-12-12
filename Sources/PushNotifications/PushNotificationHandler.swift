//
//  PushNotificationHandler.swift
//  Artemis
//
//  Created by Sven Andabaka on 19.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import Common
import UserNotifications

public class PushNotificationHandler {

    public static func extractNotification(from payload: String, iv: String) async -> UNMutableNotificationContent? {
        log.verbose("Notification received with payload: \(payload)")

        guard let notification = PushNotificationCipher.decrypt(payload: payload, iv: iv) else {
            log.verbose("Notification could not be decrypted.")
            return nil
        }

        return await prepareNotification(notification)
    }

    public static func handle(payload: String, iv: String) {
        log.verbose("Notification received with payload: \(payload)")

        guard let notification = PushNotificationCipher.decrypt(payload: payload, iv: iv) else {
            log.verbose("Notification could not be decrypted.")
            return
        }

        dispatchNotification(notification)

        // post local notification
        NotificationCenter.default.post(name: Notification.Name("receivedNewNotification"), object: nil)
    }

    private static func dispatchNotification(_ notification: PushNotification) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                log.error("Notifications are not allowed")
                return
            }
        }

        Task {
            guard let notification = await prepareNotification(notification)  else {
                log.debug("NotificationType does not support displaying notifications.")
                return
            }

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil)

            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }

    private static func prepareNotification(_ notification: PushNotification) async -> UNMutableNotificationContent? {
        guard let title = notification.title else { return nil }

        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = notification.subtitle {
            content.subtitle = subtitle
        }
        if let body = notification.body {
            content.body = body
        }
//        content.categoryIdentifier = type.rawValue
        content.userInfo = [PushNotificationUserInfoKeys.target: notification.target,
                            PushNotificationUserInfoKeys.type: notification.type.rawValue,
                            PushNotificationUserInfoKeys.communicationInfo: notification.communicationInfo?.asData]
        return content
    }
}

class PushNotificationUserInfoKeys {
    static var target = "target"
    static var type = "type"
    static var communicationInfo = "communicationInfo"
}
