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

    case newAnnouncement(NewAnnouncementNotification)
    case newAnswer(NewAnswerNotification)
    case newMention(NewMentionNotification)
    case newPost(NewPostNotification)
    case attachmentChanged(AttachmentChangedNotification)
    case exerciseAssessed(ExerciseAssessedNotification)
    case exerciseOpenForPractice(ExerciseOpenForPracticeNotification)
    case exerciseUpdated(ExerciseUpdatedNotification)
    case newExercise(NewExerciseNotification)
    case newManualFeedbackRequest(NewManualFeedbackRequestNotification)
    case quizStarted(QuizExerciseStartedNotification)
    case unknown

    /// Initializer for using different CodingKeys.
    /// This is necessary because Notifications that aren't push notifications have a different name for `type`.
    public init<Key>(from decoder: Decoder, typeKey: Key, parametersKey: Key) throws where Key: CodingKey {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(CourseNotificationType.self, forKey: typeKey)
        let decodeNotification = NotificationDecoder(key: parametersKey, container: container)
        self = switch type {
        // Communication
        case .newAnnouncementNotification: .newAnnouncement(try decodeNotification())
        case .newAnswerNotification: .newAnswer(try decodeNotification())
        case .newMentionNotification: .newMention(try decodeNotification())
        case .newPostNotification: .newPost(try decodeNotification())
        // General
        case .attachmentChangedNotification: .attachmentChanged(try decodeNotification())
        case .exerciseAssessedNotification: .exerciseAssessed(try decodeNotification())
        case .exerciseOpenForPracticeNotification: .exerciseOpenForPractice(try decodeNotification())
        case .exerciseUpdatedNotification: .exerciseUpdated(try decodeNotification())
        case .newExerciseNotification: .newExercise(try decodeNotification())
        case .newManualFeedbackRequestNotification: .newManualFeedbackRequest(try decodeNotification())
        case .quizExerciseStartedNotification: .quizStarted(try decodeNotification())
        case .unknown: .unknown
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
    // Communication
    case newAnnouncementNotification
    case newAnswerNotification
    case newMentionNotification
    case newPostNotification
    // General
    case attachmentChangedNotification
    case exerciseAssessedNotification
    case exerciseOpenForPracticeNotification
    case exerciseUpdatedNotification
    case newExerciseNotification
    case newManualFeedbackRequestNotification
    case quizExerciseStartedNotification
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
