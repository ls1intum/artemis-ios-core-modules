//
//  IrisResponseNeedsReviewNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.09.26.
//

import Foundation

public struct IrisResponseNeedsReviewNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var postMarkdownContent: String?
    public var postCreationDate: Date?
    public var postAuthorName: String?
    public var postId: Int?
    public var replyMarkdownContent: String?
    public var replyCreationDate: Date?
    public var replyId: Int?
    public var replyConfidence: Double?
    public var channelName: String?
    public var channelId: String?
}
