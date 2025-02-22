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
        if notification.communicationInfo != nil {
            content.categoryIdentifier = PushNotificationActionIdentifiers.communication
        }

        return content
    }

    /// Registers supported notification actions to iOS.
    /// Call this upon application launch.
    public static func registerNotificationCategories() {
        let replyAction = UNTextInputNotificationAction(
            identifier: PushNotificationActionIdentifiers.reply,
            title: "Reply",
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Reply")

        let communicationCategory = UNNotificationCategory(
            identifier: PushNotificationActionIdentifiers.communication,
            actions: [replyAction],
            intentIdentifiers: [],
            options: [])

        UNUserNotificationCenter.current().setNotificationCategories([communicationCategory])
    }

    /// Schedules a local notification that will be sent to the user when the current
    /// login session, and thus the push notification token, is invalidated
    public static func scheduleNotificationForSessionExpired() {
        guard let cookies = URLSession.shared.configuration.httpCookieStorage?.cookies else {
            return
        }
        let jwtCookie = cookies.first { $0.name == "jwt" }
        if let jwtCookie, let expiryDate = jwtCookie.expiresDate {
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: expiryDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents,
                                                        repeats: false)

            let content = UNMutableNotificationContent()
            content.title = R.string.localizable.sessionExpiredTitle()
            content.body = R.string.localizable.sessionExpiredBody()

            let notification = UNNotificationRequest(identifier: LocalNotificationIdentifiers.sessionExpired,
                                                     content: content,
                                                     trigger: trigger)
            UNUserNotificationCenter.current().add(notification)
        }
    }
}

public class PushNotificationActionIdentifiers {
    public static let reply = "reply"
    static let communication = "communication"
}

public class PushNotificationUserInfoKeys {
    static var target = "target"
    static var type = "type"
    public static var communicationInfo = "communicationInfo"
}

public class LocalNotificationIdentifiers {
    public static let sessionExpired = "sessionExpiredNotification"
}
