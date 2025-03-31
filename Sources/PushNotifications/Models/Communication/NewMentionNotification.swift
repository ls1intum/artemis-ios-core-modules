//
//  NewMentionNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct NewMentionNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var postMarkdownContent: String?
    public var postCreationDate: String?
    public var postAuthorName: String?
    public var postId: Int?
    public var replyMarkdownContent: String?
    public var replyCreationDate: String?
    public var replyAuthorName: String?
    public var replyAuthorId: Int?
    public var replyImageUrl: String?
    public var replyId: Int?
    public var channelName: String?
    public var channelId: Int?
}

extension NewMentionNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.userMentionSettingsName()
    }

    public var body: String? {
        postMarkdownContent
    }
}
