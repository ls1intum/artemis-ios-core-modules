//
//  File.swift
//  
//
//  Created by Sven Andabaka on 12.03.23.
//

import Foundation

public class PushNotificationResponseHandler {

    public static func getConversationId(from userInfo: [AnyHashable: Any]) -> Int? {
        guard let infoData = userInfo[PushNotificationUserInfoKeys.communicationInfo] as? Data,
              let info = try? PushNotificationCommunicationInfo(with: infoData) else {
            return nil
        }
        return info.channelId
    }

    public static func getTarget(userInfo: [AnyHashable: Any]) -> String? {
        return userInfo[PushNotificationUserInfoKeys.target] as? String
    }

    public static func getCommunicationInfo(userInfo: [AnyHashable: Any]) -> PushNotificationCommunicationInfo? {
        guard let infoData = userInfo[PushNotificationUserInfoKeys.communicationInfo] as? Data else {
            return nil
        }
        return try? PushNotificationCommunicationInfo(with: infoData)
    }
}
