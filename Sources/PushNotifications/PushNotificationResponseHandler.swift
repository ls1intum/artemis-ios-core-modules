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

    public static func getTarget(from userInfo: [AnyHashable: Any]) -> String? {
        return userInfo[PushNotificationUserInfoKeys.target] as? String
    }
}
