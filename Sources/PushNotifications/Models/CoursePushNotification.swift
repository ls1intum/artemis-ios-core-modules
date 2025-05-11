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
        case type = "notificationType"
        case parameters
    }

    case addedToChannel(AddedToChannelNotification)
    case channelDeleted(ChannelDeletedNotification)
    case newAnnouncement(NewAnnouncementNotification)
    case newAnswer(NewAnswerNotification)
    case newMention(NewMentionNotification)
    case newPost(NewPostNotification)
    case removedFromChannel(RemovedFromChannelNotification)
    case attachmentChanged(AttachmentChangedNotification)
    case deregisteredFromTutorial(DeregisteredFromTutorialGroupNotification)
    case duplicateTestCase(DuplicateTestCaseNotification)
    case exerciseAssessed(ExerciseAssessedNotification)
    case exerciseOpenForPractice(ExerciseOpenForPracticeNotification)
    case exerciseUpdated(ExerciseUpdatedNotification)
    case newCpcPlagiarismCase(NewCpcPlagiarismCaseNotification)
    case newExercise(NewExerciseNotification)
    case newManualFeedbackRequest(NewManualFeedbackRequestNotification)
    case newPlagiarismCase(NewPlagiarismCaseNotification)
    case plagiarismCaseVerdict(PlagiarismCaseVerdictNotification)
    case programmingBuildRunUpdate(ProgrammingBuildRunUpdateNotification)
    case programmingTestCasesChanged(ProgrammingTestCasesChangedNotification)
    case quizStarted(QuizExerciseStartedNotification)
    case registeredToTutorial(RegisteredToTutorialGroupNotification)
    case tutorialAssigned(TutorialGroupAssignedNotification)
    case tutorialDeleted(TutorialGroupDeletedNotification)
    case tutorialUnassigned(TutorialGroupUnassignedNotification)
    case unknown

    // swiftlint:disable:next cyclomatic_complexity
    /// Initializer for using different CodingKeys.
    /// This is necessary because Notifications that aren't push notifications have a different name for `type`.
    public init<Key>(from decoder: Decoder, typeKey: Key, parametersKey: Key) throws where Key: CodingKey {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(CourseNotificationType.self, forKey: typeKey)
        let decodeNotification = NotificationDecoder(key: parametersKey, container: container)
        self = switch type {
        // Communication
        case .addedToChannelNotification: .addedToChannel(try decodeNotification())
        case .channelDeletedNotification: .channelDeleted(try decodeNotification())
        case .newAnnouncementNotification: .newAnnouncement(try decodeNotification())
        case .newAnswerNotification: .newAnswer(try decodeNotification())
        case .newMentionNotification: .newMention(try decodeNotification())
        case .newPostNotification: .newPost(try decodeNotification())
        case .removedFromChannelNotification: .removedFromChannel(try decodeNotification())
        // General
        case .attachmentChangedNotification: .attachmentChanged(try decodeNotification())
        case .deregisteredFromTutorialGroupNotification: .deregisteredFromTutorial(try decodeNotification())
        case .duplicateTestCaseNotification: .duplicateTestCase(try decodeNotification())
        case .exerciseAssessedNotification: .exerciseAssessed(try decodeNotification())
        case .exerciseOpenForPracticeNotification: .exerciseOpenForPractice(try decodeNotification())
        case .exerciseUpdatedNotification: .exerciseUpdated(try decodeNotification())
        case .newCpcPlagiarismCaseNotification: .newCpcPlagiarismCase(try decodeNotification())
        case .newExerciseNotification: .newExercise(try decodeNotification())
        case .newManualFeedbackRequestNotification: .newManualFeedbackRequest(try decodeNotification())
        case .newPlagiarismCaseNotification: .newPlagiarismCase(try decodeNotification())
        case .plagiarismCaseVerdictNotification: .plagiarismCaseVerdict(try decodeNotification())
        case .programmingBuildRunUpdateNotification: .programmingBuildRunUpdate(try decodeNotification())
        case .programmingTestCasesChangedNotification: .programmingTestCasesChanged(try decodeNotification())
        case .quizExerciseStartedNotification: .quizStarted(try decodeNotification())
        case .registeredToTutorialGroupNotification: .registeredToTutorial(try decodeNotification())
        case .tutorialGroupAssignedNotification: .tutorialAssigned(try decodeNotification())
        case .tutorialGroupDeletedNotification: .tutorialDeleted(try decodeNotification())
        case .tutorialGroupUnassignedNotification: .tutorialUnassigned(try decodeNotification())
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
        case .addedToChannel(let notification): notification
        case .channelDeleted(let notification): notification
        case .newAnnouncement(let notification): notification
        case .newAnswer(let notification): notification
        case .newMention(let notification): notification
        case .newPost(let notification): notification
        case .removedFromChannel(let notification): notification

        case .attachmentChanged(let notification): notification
        case .deregisteredFromTutorial(let notification): notification
        case .exerciseAssessed(let notification): notification
        case .exerciseOpenForPractice(let notification): notification
        case .exerciseUpdated(let notification): notification
        case .newExercise(let notification): notification
        case .newManualFeedbackRequest(let notification): notification
        case .quizStarted(let notification): notification
        case .registeredToTutorial(let notification): notification
        case .tutorialAssigned(let notification): notification
        case .tutorialDeleted(let notification): notification
        case .tutorialUnassigned(let notification): notification
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

public enum CourseNotificationType: String, Codable, CodingKeyRepresentable, ConstantsEnum {
    // Communication
    case addedToChannelNotification
    case channelDeletedNotification
    case newAnnouncementNotification
    case newAnswerNotification
    case newMentionNotification
    case newPostNotification
    case removedFromChannelNotification
    // General
    case attachmentChangedNotification
    case deregisteredFromTutorialGroupNotification
    case duplicateTestCaseNotification
    case exerciseAssessedNotification
    case exerciseOpenForPracticeNotification
    case exerciseUpdatedNotification
    case newCpcPlagiarismCaseNotification
    case newExerciseNotification
    case newManualFeedbackRequestNotification
    case newPlagiarismCaseNotification
    case plagiarismCaseVerdictNotification
    case programmingBuildRunUpdateNotification
    case programmingTestCasesChangedNotification
    case quizExerciseStartedNotification
    case registeredToTutorialGroupNotification
    case tutorialGroupAssignedNotification
    case tutorialGroupDeletedNotification
    case tutorialGroupUnassignedNotification
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
    var subtitle: String? { nil }
}
