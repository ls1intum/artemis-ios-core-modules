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

    case newAnnouncement(notification: NewAnnouncementNotification)
    case newAnswer(notification: NewAnswerNotification)
    case newPost(notification: NewPostNotification)
    case attachmentChanged(notification: AttachmentChangedNotification)
    case exerciseAssessed(notification: ExerciseAssessedNotification)
    case exerciseOpenForPractice(notification: ExerciseOpenForPracticeNotification)
    case exerciseUpdated(notification: ExerciseUpdatedNotification)
    case newExercise(notification: NewExerciseNotification)
    case unknown

    /// Initializer for using different CodingKeys.
    /// This is necessary because Notifications that aren't push notifications have a different name for `type`.
    public init<Key>(from decoder: Decoder, typeKey: Key, parametersKey: Key) throws where Key: CodingKey {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(CourseNotificationType.self, forKey: typeKey)
        let decodeNotification = NotificationDecoder(key: parametersKey, container: container)
        self = switch type {
        case .newAnnouncementNotification:
            .newAnnouncement(notification: try decodeNotification())
        case .newAnswerNotification:
            .newAnswer(notification: try decodeNotification())
        case .newPostNotification:
            .newPost(notification: try decodeNotification())
        case .attachmentChangedNotification:
            .attachmentChanged(notification: try decodeNotification())
        case .exerciseAssessedNotification:
            .exerciseAssessed(notification: try decodeNotification())
        case .exerciseOpenForPracticeNotification:
            .exerciseOpenForPractice(notification: try decodeNotification())
        case .exerciseUpdatedNotification:
            .exerciseUpdated(notification: try decodeNotification())
        case .newExerciseNotification:
            .newExercise(notification: try decodeNotification())
        case .unknown:
            .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        try self.init(from: decoder, typeKey: Keys.type, parametersKey: Keys.parameters)
    }

    /// Not needed, but we conform to Codable to prevent annoyances in `PushNotification`
    public func encode(to encoder: Encoder) throws {}

    public var displayable: DisplayableNotification? {
        switch self {
        case .newPost(let notification):
            notification
        default:
            nil
        }
    }
}

// Helper for making decoding above much more compact
// by making use of compiler's automatic type derivation
private struct NotificationDecoder<Key: CodingKey> {
    let key: Key
    let container: KeyedDecodingContainer<Key>

    func callAsFunction<T: Codable>() throws -> T {
        try container.decode(T.self, forKey: key)
    }
}

public enum CourseNotificationType: String, Codable, ConstantsEnum {
    case newAnnouncementNotification
    case newAnswerNotification
    case newPostNotification
    case attachmentChangedNotification
    case exerciseAssessedNotification
    case exerciseOpenForPracticeNotification
    case exerciseUpdatedNotification
    case newExerciseNotification
    case unknown
}

public protocol CourseBaseNotification: Codable {
    var courseId: Int? { get }
    var courseTitle: String? { get }
    var courseIconUrl: String? { get }
}

public protocol DisplayableNotification {
    var title: String { get }
    var subtitle: String? { get }
    var body: String? { get }
}

public extension DisplayableNotification {
    var bodyLineLimit: Int { 3 }
}
