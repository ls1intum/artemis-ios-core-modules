//
//  NewAnnouncementNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct NewAnnouncementNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var postId: Int?
    public var postTitle: String?
    public var postMarkdownContent: String?
    public var authorName: String?
    public var authorImageUrl: String?
    public var authorId: Int?
    public var channelId: Int?
}
