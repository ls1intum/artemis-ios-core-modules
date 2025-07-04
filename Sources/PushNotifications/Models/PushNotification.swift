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

    /// The version is 1, as of Artemis 6.6.7.
    ///
    /// The version is declared in the constants of Artemis, see [source](https://github.com/ls1intum/Artemis/blob/6.6.7/src/main/java/de/tum/in/www1/artemis/config/Constants.java#L318).
    var isValid: Bool {
        version == 1
    }
}

struct PushNotification: Codable {
    let version: Int
    let courseNotificationDTO: CoursePushNotification?
}
