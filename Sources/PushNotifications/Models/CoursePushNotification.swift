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

    /// Initializer for using different CodingKeys.
    /// This is necessary because Notifications that aren't push notifications have a different name for `type`.
    public init<Key>(from decoder: Decoder, typeKey: Key, parametersKey: Key) throws where Key: CodingKey {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(CourseNotificationType.self, forKey: typeKey)
        switch type {
        case .newPostNotification:
            self = .newPost(notification: try container.decode(NewPostNotification.self, forKey: parametersKey))
        case .unknown:
            self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        try self.init(from: decoder, typeKey: Keys.type, parametersKey: Keys.parameters)
    }

    /// Not needed, but we conform to Codable to prevent annoyances in `PushNotification`
    public func encode(to encoder: Encoder) throws {}
}

public enum CourseNotificationType: String, Codable, ConstantsEnum {
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
