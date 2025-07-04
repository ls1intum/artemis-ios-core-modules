//
//  PushNotification+Communication.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 11.12.24.
//

import Foundation

extension CoursePushNotification {
    var communicationInfo: PushNotificationCommunicationInfo? {
        switch self {
        case .newAnnouncement(let notification):
            return PushNotificationCommunicationInfo(author: notification.authorName ?? "",
                                                     channel: R.string.localizable.artemisAppGroupNotificationTitleNewAnnouncementPost(),
                                                     course: notification.courseTitle ?? "",
                                                     userId: notification.authorId ?? 0,
                                                     courseId: notification.courseId ?? 0,
                                                     channelId: notification.channelId ?? 0,
                                                     messageId: notification.postId ?? 0,
                                                     profilePicUrl: notification.authorImageUrl,
                                                     messageContent: notification.postMarkdownContent?.replacingMarkdownImages() ?? "",
                                                     isReply: false)
        case .newAnswer(let notification):
            return PushNotificationCommunicationInfo(author: R.string.localizable.repliedTo(notification.replyAuthorName ?? "", notification.postAuthorName ?? ""),
                                                     channel: notification.channelName ?? "",
                                                     course: notification.courseTitle ?? "",
                                                     userId: notification.replyAuthorId ?? 0,
                                                     courseId: notification.courseId ?? 0,
                                                     channelId: notification.channelId ?? 0,
                                                     messageId: notification.replyId ?? 0,
                                                     profilePicUrl: notification.replyImageUrl,
                                                     messageContent: notification.replyMarkdownContent?.replacingMarkdownImages() ?? "",
                                                     isReply: true)
        case .newMention(let notification):
            let isReply = notification.replyId != nil
            return PushNotificationCommunicationInfo(author: notification.postAuthorName ?? "",
                                                     channel: notification.channelName ?? "",
                                                     course: notification.courseTitle ?? "",
                                                     userId: notification.replyAuthorId ?? 0,
                                                     courseId: notification.courseId ?? 0,
                                                     channelId: notification.channelId ?? 0,
                                                     messageId: (isReply ? notification.replyId : notification.postId) ?? 0,
                                                     profilePicUrl: notification.replyImageUrl,
                                                     messageContent: (notification.replyMarkdownContent ?? notification.postMarkdownContent)?.replacingMarkdownImages() ?? "",
                                                     isReply: isReply)
        case .newPost(let notification):
            return PushNotificationCommunicationInfo(author: notification.authorName ?? "",
                                                     channel: notification.channelName ?? "",
                                                     course: notification.courseTitle ?? "",
                                                     userId: notification.authorId ?? 0,
                                                     courseId: notification.courseId ?? 0,
                                                     channelId: notification.channelId ?? 0,
                                                     messageId: notification.postId ?? 0,
                                                     profilePicUrl: notification.authorImageUrl,
                                                     messageContent: notification.postMarkdownContent?.replacingMarkdownImages() ?? "",
                                                     isReply: false)
        default:
            return nil
        }
    }
}

public struct PushNotificationCommunicationInfo: Codable {
    let author: String
    let channel: String
    let course: String
    let userId: Int
    public let courseId: Int
    public let channelId: Int
    public let messageId: Int
    let profilePicUrl: String?
    let messageContent: String
    let isReply: Bool
}

public extension PushNotificationCommunicationInfo {
    var asData: Data {
        (try? JSONEncoder().encode(self)) ?? Data()
    }

    init(with data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
