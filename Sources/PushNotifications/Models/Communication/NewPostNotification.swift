//
//  NewPostNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.03.25.
//

public class NewPostNotification: CourseBaseNotification {
    public let courseId: Int?
    public let courseTitle: String?
    public let courseIconUrl: String?

    public let postId: Int?
    public let postMarkdownContent: String?
    public let channelId: Int?
    public let channelName: String?
    public let channelType: String?
    public let authorName: String?
    public let authorImageUrl: String?
    public let authorId: Int?
}

extension NewPostNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppConversationNotificationTitleNewMessage()
    }

    public var subtitle: String? {
        authorName
    }

    public var body: String? {
        postMarkdownContent
    }
}
