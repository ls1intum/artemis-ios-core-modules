//
//  CoursePushNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 11.03.25.
//

import Foundation
import SharedModels

public enum CoursePushNotification: Codable {

    fileprivate enum Keys: String, CodingKey {
        case type
        case parameters
    }

    case newPost(notification: NewPostNotification)
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(CourseNotificationType.self, forKey: Keys.type)
        switch type {
        case .newPostNotification:
            self = .newPost(notification: try container.decode(NewPostNotification.self, forKey: Keys.parameters))
        case .unknown:
            self = .unknown
        }
    }

    /// Not needed, but we conform to Codable to prevent annoyances in `PushNotification`
    public func encode(to encoder: Encoder) throws {}
}

enum CourseNotificationType: String, Codable, ConstantsEnum {
    case newPostNotification
    case unknown
}

public protocol CourseBaseNotification: Codable {
    var courseId: Int? { get }
    var courseTitle: String? { get }
    var courseIconUrl: String? { get }
}

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
