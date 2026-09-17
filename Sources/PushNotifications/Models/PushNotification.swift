//
//  PushNotification.swift
//  Artemis
//
//  Created by Sven Andabaka on 19.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import ArtemisMarkdown
import Foundation

enum PushNotificationVersionError: Error {
    case invalidVersion
}

struct PushNotificationVersion: Codable {
    let version: Int

    /// The push body versions this app can read, declared as `Constants.PUSH_NOTIFICATION_VERSION` on the server.
    ///
    /// Version 1 carries the values of a notification as the flat `parameters` map. Version 2 carries the typed
    /// `payload` instead, which ``CoursePushNotification`` already reads, and the server raises it once
    /// `artemis.compatible-versions.ios.min` rules out the app versions that only accept 1.
    ///
    /// A set rather than a single value on purpose. This used to be `version == 1`, which made the server's version
    /// field useless as a compatibility signal: raising it dropped every push notification on every installed app,
    /// silently, so the server could never raise it without a lockstep release. Accepting the versions we can
    /// actually decode is what lets the server move on its own.
    static let supported: Set<Int> = [1, 2]

    var isValid: Bool {
        Self.supported.contains(version)
    }
}

struct PushNotification: Codable {
    let version: Int
    let courseNotificationDTO: CoursePushNotification?
}
