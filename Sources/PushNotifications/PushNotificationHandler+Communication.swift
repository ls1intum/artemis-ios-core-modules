//
//  PushNotificationHandler+Communication.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 12.12.24.
//

import APIClient
import CryptoKit
import DesignLibrary
import Foundation
import Intents
import SwiftUI
import UserNotifications
import UserStore
import Login

public extension PushNotificationHandler {
    /// Prepares an intent for showing a communication notification
    /// Use this to update the `UNNotificationContent` in the NotificationExtension
    static func getCommunicationIntent(for content: UNMutableNotificationContent?) async -> INSendMessageIntent? {
        guard let content,
              let infoData = content.userInfo[PushNotificationUserInfoKeys.communicationInfo] as? Data,
              let info = try? PushNotificationCommunicationInfo(with: infoData) else {
            return nil
        }

        let intent = await createIntent(info: info)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        try? await interaction.donate()

        // Will be read out by Siri, subtitle shown on Apple Watch in Notification Center
        content.title = info.author
        content.subtitle = intent.speakableGroupName?.spokenPhrase ?? info.channel
        content.body = info.messageContent

        content.threadIdentifier = info.isReply ? info.messageId : "\(info.channelId)"

        return intent
    }

    private static func createIntent(info: PushNotificationCommunicationInfo) async -> INSendMessageIntent {
        let image = try? await getUserImage(for: info.author, with: info.userId, from: info.profilePicUrl)
        let person = INPerson(personHandle: .init(value: info.userId, type: .unknown),
                              nameComponents: try? .init(info.author),
                              displayName: info.author,
                              image: image,
                              contactIdentifier: info.userId,
                              customIdentifier: info.userId)

        let channelTitle: String
        if info.channel == info.author || info.type == .oneToOneChat {
            channelTitle = info.course
        } else {
            channelTitle = "\(info.channel) (\(info.course))"
        }

        let intent = INSendMessageIntent(recipients: [person],
                                         outgoingMessageType: .outgoingMessageText,
                                         content: info.messageContent,
                                         speakableGroupName: .init(spokenPhrase: channelTitle),
                                         conversationIdentifier: "\(info.channelId)",
                                         serviceName: nil,
                                         sender: person,
                                         attachments: nil)
        intent.setImage(image, forParameterNamed: \.speakableGroupName)
        return intent
    }

    private static func getUserImage(for user: String,
                                     with id: String,
                                     from urlString: String?) async throws -> INImage? {
        let baseUrl = UserSessionFactory.shared.institution?.baseURL?.appending(path: "api/core/files")
        guard let urlString, let url = baseUrl?.appending(path: urlString) else {
            // Default profile picture fallback
            let pictureView = ProfilePictureInitialsView(name: user, userId: id, size: 100)
            let imageData = await ImageRenderer(content: pictureView).uiImage?.pngData()
            if let imageData {
                return INImage(imageData: imageData)
            }
            return nil
        }

        var request = URLRequest(url: url, timeoutInterval: 15)
        let session = URLSession(configuration: URLSession.shared.configuration,
                                 delegate: URLImageCacheDelegate(),
                                 delegateQueue: URLSession.shared.delegateQueue)
        if let token = UserSessionFactory.shared.getToken() {
            let properties: [HTTPCookiePropertyKey: Any] = [
                .name: "jwt",
                .value: token,
                .secure: true,
                .domain: UserSessionFactory.shared.institution?.baseURL?.absoluteString ?? "",
                .path: "/",
                .version: 0
            ]
            if let cookie = HTTPCookie(properties: properties) {
                request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: [cookie])
            }
        }

        let (data, response) = try await session.data(for: request)
        #warning("Response handling can be removed after June 2025")
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

// MARK: Custom Cache
// https://stackoverflow.com/a/46158561
private extension CachedURLResponse {
    func response(withExpirationDuration duration: Int) -> CachedURLResponse {
        var cachedResponse = self
        if let httpResponse = cachedResponse.response as? HTTPURLResponse,
           var headers = httpResponse.allHeaderFields as? [String: String],
           let url = httpResponse.url {
            if httpResponse.statusCode == 401 {
                return cachedResponse
            }

            headers["Cache-Control"] = "max-age=\(duration)"
            headers.removeValue(forKey: "Expires")
            headers.removeValue(forKey: "s-maxage")

            if let newResponse = HTTPURLResponse(url: url,
                                                 statusCode: httpResponse.statusCode,
                                                 httpVersion: "HTTP/1.1",
                                                 headerFields: headers) {
                cachedResponse = CachedURLResponse(response: newResponse,
                                                   data: cachedResponse.data,
                                                   userInfo: headers,
                                                   storagePolicy: cachedResponse.storagePolicy)
            }
        }
        return cachedResponse
    }
}

private class URLImageCacheDelegate: NSObject, URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    willCacheResponse proposedResponse: CachedURLResponse,
                    completionHandler: @escaping (CachedURLResponse?) -> Void) {
        // Store images for 24 hours in cache
        let newResponse = proposedResponse.response(withExpirationDuration: 60 * 60 * 24)
        completionHandler(newResponse)
    }
}
