//
//  NewAnswerNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct NewAnswerNotification: CourseBaseNotification {
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

extension NewAnswerNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.newReply()
    }

    public var subtitle: String? {
        replyAuthorName
    }

    public var body: String? {
        replyMarkdownContent
    }
}

extension NewAnswerNotification: NavigatableNotification {
    public var relativePath: String? {
        communicationPath(courseId: courseId, conversationId: channelId, threadId: replyId)
    }
}
