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
        case courseId
        case parameters
        /// The shape Artemis 10.0 and later write, with the values every notification carries beside it rather than
        /// among the type specific ones. A key the enum does not declare cannot be built from a string, so the
        /// decoder would silently never look for these.
        case payload
        case courseTitle
        case courseIconUrl
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
    case irisResponse(IrisResponseNotification)
    case unknown

    /// Reads a notification from either shape the server may have sent it in.
    ///
    /// `payload` is what Artemis 10.0 and later write, `parameters` the flat map earlier versions write and the push
    /// body still carries. An install talks to whichever version its institution has deployed, so both have to keep
    /// working, and no caller can know in advance which one it is about to read. This used to take the keys as
    /// parameters, because the notification list and the push body named the type field differently; they no longer
    /// do, so deciding here is what keeps the two transports from drifting apart again.
    public init(from decoder: Decoder) throws { // swiftlint:disable:this cyclomatic_complexity
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(CourseNotificationType.self, forKey: .type)
        let decodeNotification = NotificationDecoder(keys: [.payload, .parameters], container: container)
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
        case .irisResponseNotification: .irisResponse(try decodeNotification())
        case .unknown: .unknown
        }
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
        case .irisResponse(let notification): notification
        default:
            nil
        }
    }
}

// Helper for making decoding above much more compact
// by making use of compiler's automatic type derivation
private struct NotificationDecoder<Key: CodingKey> {
    /// The keys the values may arrive under, the shape we prefer first.
    let keys: [Key]
    let container: KeyedDecodingContainer<Key>

    func callAsFunction<T: Codable & CourseBaseNotification>() throws -> T {
        // A present but null key counts as absent. The server writes the payload key for every notification it sends,
        // even one whose payload carries nothing, so this only matters if that ever stops being true — and reading a
        // null as if it were the values throws, which for the notification list fails the decode of the whole page
        // rather than of the one notification that cannot be read.
        guard let key = try keys.first(where: { try container.contains($0) && !container.decodeNil(forKey: $0) }) else {
            throw DecodingError.keyNotFound(
                keys[0],
                .init(codingPath: container.codingPath,
                      debugDescription: "A notification carried its values under none of \(keys.map(\.stringValue))")
            )
        }
        var value = try container.decode(T.self, forKey: key)

        // These belong to every notification rather than to its type, so the flat shape carries them among the values
        // while the typed one puts them beside the payload. Read from the level above either way, and only where the
        // values did not already carry them, so the flat shape keeps decoding exactly as it did.
        value.courseId = try sibling(Int.self, named: "courseId") ?? value.courseId
        value.courseTitle = try value.courseTitle ?? sibling(String.self, named: "courseTitle")
        value.courseIconUrl = try value.courseIconUrl ?? sibling(String.self, named: "courseIconUrl")
        return value
    }

    private func sibling<V: Decodable>(_ type: V.Type, named name: String) throws -> V? {
        guard let key = Key(stringValue: name) else { return nil }
        return try container.decodeIfPresent(type, forKey: key)
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
    case irisResponseNotification
    case unknown
}

public protocol CourseBaseNotification: Codable {
    var courseId: Int? { get set }
    /// Settable because the typed shape carries this beside the payload rather than inside it, so the decoder fills it
    /// in from the level above.
    var courseTitle: String? { get set }
    var courseIconUrl: String? { get set }
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
