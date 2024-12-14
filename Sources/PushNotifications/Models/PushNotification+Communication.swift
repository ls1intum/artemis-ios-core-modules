//
//  PushNotification+Communication.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 11.12.24.
//

import Foundation

extension PushNotificationType {
    func getCommunicationInfo(notificationPlaceholders placeholders: [String], target: String) -> PushNotificationCommunicationInfo? {
        switch self {
        case .conversationNewReplyMessage, .conversationUserMentioned,
                .newReplyForCoursePost, .newReplyForExamPost,
                .newReplyForLecturePost, .newReplyForExercisePost:
            // ["courseTitle", "postContent", "postCreationData", "postAuthorName", "answerPostContent", "answerPostCreationDate", "authorName", "conversationName", "imageUrl", "userId", "postingId", "parentPostId"]
            guard placeholders.count > 11 else { return nil }
            let channelId = URLComponents(string: target)?.queryItems?.first { $0.name == "conversationId" }?.value ?? ""
            let profilePic = placeholders[8].isEmpty ? nil : placeholders[8]

            return .init(author: R.string.localizable.repliedTo(placeholders[6], placeholders[3]),
                         channel: placeholders[7],
                         course: placeholders[0],
                         userId: placeholders[9],
                         channelId: channelId,
                         messageId: placeholders[11],
                         profilePicUrl: profilePic,
                         messageContent: placeholders[4].replacingMarkdownImages(),
                         type: nil,
                         isReply: true)

        case .newCoursePost, .newExamPost, .newExercisePost, .newLecturePost,
                .conversationNewMessage:
            // ["courseTitle", "messageContent", "messageCreationDate", "conversationName", "authorName", "conversationType", "imageUrl", "userId", "postId"]
            guard placeholders.count > 8 else { return nil }
            let channelId = URLComponents(string: target)?.queryItems?.first { $0.name == "conversationId" }?.value ?? ""
            let profilePic = placeholders[6].isEmpty ? nil : placeholders[6]

            return .init(author: placeholders[4],
                         channel: placeholders[3],
                         course: placeholders[0],
                         userId: placeholders[7],
                         channelId: channelId,
                         messageId: placeholders[8],
                         profilePicUrl: profilePic,
                         messageContent: placeholders[1].replacingMarkdownImages(),
                         type: .init(rawValue: placeholders[5]),
                         isReply: false)

        case .newAnnouncementPost:
            // ["courseTitle", "postTitle", "postContent", "postCreationDate", "postAuthorName", "imageUrl", "authorId", "postId"]
            guard placeholders.count > 7 else { return nil }
            let channelId = URLComponents(string: target)?.queryItems?.first { $0.name == "conversationId" }?.value ?? ""
            let profilePic = placeholders[5].isEmpty ? nil : placeholders[5]

            return .init(author: placeholders[4],
                         channel: R.string.localizable.artemisAppGroupNotificationTitleNewAnnouncementPost(),
                         course: placeholders[0],
                         userId: placeholders[6],
                         channelId: channelId,
                         messageId: placeholders[7],
                         profilePicUrl: profilePic,
                         messageContent: placeholders[1] + "\n" + placeholders[2].replacingMarkdownImages(),
                         type: nil,
                         isReply: false)

        default:
            return nil
        }
    }
}

struct PushNotificationCommunicationInfo: Codable {
    let author: String
    let channel: String
    let course: String
    let userId: String
    let channelId: String
    let messageId: String
    let profilePicUrl: String?
    let messageContent: String
    let type: ConversationType?
    let isReply: Bool

    enum ConversationType: String, Codable {
        case channel
        case oneToOneChat
        case groupChat
    }
}

extension PushNotificationCommunicationInfo {
    var asData: Data {
        (try? JSONEncoder().encode(self)) ?? Data()
    }

    init(with data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
