//
//  PushNotificationHandler+Communication.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 12.12.24.
//

import APIClient
import Foundation
import Intents
import UserNotifications
import UserStore

public extension PushNotificationHandler {
    /// Prepares an intent for showing a communication notification
    /// Use this to update the `UNNotificationContent` in the NotificationExtension
    static func getCommunicationIntent(for content: UNMutableNotificationContent?) async -> INSendMessageIntent? {
        guard let content,
              let infoData = content.userInfo[PushNotificationUserInfoKeys.communicationInfo] as? Data,
              let info = try? PushNotificationCommunicationInfo(with: infoData) else {
            return nil
        }

        if let target = content.userInfo[PushNotificationUserInfoKeys.target] as? String {
            content.threadIdentifier = target
        }

        let intent = await createIntent(info: info)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        try? await interaction.donate()

        return intent
    }

    private static func createIntent(info: PushNotificationCommunicationInfo) async -> INSendMessageIntent {
        let person = INPerson(personHandle: .init(value: info.userId, type: .unknown),
                              nameComponents: try? .init(info.author),
                              displayName: info.author,
                              image: try? await getUserImage(from: info.profilePicUrl),
                              contactIdentifier: info.userId,
                              customIdentifier: info.userId)

        let channelTitle = "\(info.channel) (\(info.course))"

        return INSendMessageIntent(recipients: [],
                                   outgoingMessageType: .outgoingMessageText,
                                   content: info.messageContent,
                                   speakableGroupName: .init(spokenPhrase: channelTitle),
                                   conversationIdentifier: info.channelId,
                                   serviceName: nil,
                                   sender: person,
                                   attachments: nil)
    }

    private static func getUserImage(from urlString: String?) async throws -> INImage? {
        let baseUrl = UserSessionFactory.shared.institution?.baseURL
        guard let urlString, let url = URL(string: urlString, relativeTo: baseUrl) else {
            return nil
        }

        let request = URLRequest(url: url, timeoutInterval: 15)

        var (data, response) = try await URLSession.shared.data(for: request)
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            // Not logged in, retry if possible
            if let username = UserSessionFactory.shared.username,
               let password = UserSessionFactory.shared.password,
               await LoginService().login(username: username, password: password) {
                (data, response) = try await URLSession.shared.data(for: request)
            }
        }

        return INImage(imageData: data)
    }
}

private class LoginService {
    private let client = APIClient()

    struct LoginUser: APIRequest {
        typealias Response = RawResponse

        var username: String
        var password: String

        var method: HTTPMethod {
            return .post
        }

        var resourceName: String {
            return "api/public/authenticate"
        }
    }

    /// Tries to perform a login request and returns whether it was successful
    func login(username: String, password: String) async -> Bool {
        let result = await client.sendRequest(LoginUser(username: username, password: password), currentTry: 3)

        switch result {
        case .success:
            return true
        case .failure(let error):
            return false
        }
    }
}
