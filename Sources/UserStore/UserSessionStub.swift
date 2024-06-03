//
//  UserSessionImpl.swift
//  
//
//  Created by Anian Schleyer on 03.06.24.
//

import Foundation
import Common

public class UserSessionStub: UserSession {
    override init() {
        super.init()
        notificationDeviceConfigurations.append(.init(institutionIdentifier: .tum, username: "artemis", skippedNotifications: false))
        setUserLoggedIn(isLoggedIn: true)
        saveUsername(username: "artemis")
        saveInstitution(identifier: .tum)
    }

    override public func getCurrentNotificationDeviceConfiguration() -> NotificationDeviceConfiguration? {
        notificationDeviceConfigurations.first
    }

    override public func setTokenExpired(expired: Bool) {
        return
    }

    override public func setUserLoggedIn(isLoggedIn: Bool) {
        super.setUserLoggedIn(isLoggedIn: true)
    }
}
