//
//  NotificationSettings.swift
//
//
//  Created by Anian Schleyer on 03.05.23.
//

import Foundation
import SharedModels

public struct NotificationSettingsInfo: Codable {
    let notificationTypes: [String: CourseNotificationType]
    let channels: [NotificationChannel]
    let presets: [NotificationSettingsPreset]
}

public struct NotificationSettings: Codable {
    var selectedPreset: Int
    var notificationTypeChannels: [String: [NotificationChannel: Bool]]
}

public enum NotificationChannel: String, CodingKeyRepresentable, ConstantsEnum {
    case web = "WEBAPP"
    case push = "PUSH"
    case email = "EMAIL"
    case unknown
}

extension CourseNotificationType {
    var settingsTitle: String {
        switch self {
        case .addedToChannelNotification:
            R.string.localizable.addChannelSettingsName()
        case .channelDeletedNotification:
            R.string.localizable.deleteChannelSettingsName()
        case .newAnnouncementNotification:
            R.string.localizable.newAnnouncementSettingsName()
        case .newAnswerNotification:
            R.string.localizable.newReplySettingsName()
        case .newMentionNotification:
            R.string.localizable.newMentionSettingsName()
        case .newPostNotification:
            R.string.localizable.newMessageSettingsName()
        case .removedFromChannelNotification:
            R.string.localizable.removeChannelSettingsName()
        case .attachmentChangedNotification:
            R.string.localizable.attachmentChangedSettingsName()
        case .deregisteredFromTutorialGroupNotification:
            R.string.localizable.tutorialDeregisteredSettingsName()
        case .duplicateTestCaseNotification:
            R.string.localizable.duplicateTestSettingsName()
        case .exerciseAssessedNotification:
            R.string.localizable.exerciseAssessedSettingsName()
        case .exerciseOpenForPracticeNotification:
            R.string.localizable.exerciseOpenForPracticeSettingsName()
        case .exerciseUpdatedNotification:
            R.string.localizable.exerciseUpdatedSettingsName()
        case .newCpcPlagiarismCaseNotification:
            R.string.localizable.newSimilaritySettingsName()
        case .newExerciseNotification:
            R.string.localizable.exerciseReleasedSettingsName()
        case .newManualFeedbackRequestNotification:
            R.string.localizable.feedbackRequestSettingsName()
        case .newPlagiarismCaseNotification:
            R.string.localizable.newPlagiarismSettingsName()
        case .plagiarismCaseVerdictNotification:
            R.string.localizable.plagiarismVerdictSettingsName()
        case .programmingBuildRunUpdateNotification:
            R.string.localizable.buildUpdateSettingsName()
        case .programmingTestCasesChangedNotification:
            R.string.localizable.testCaseChangedSettingsName()
        case .quizExerciseStartedNotification:
            R.string.localizable.quizStartedSettingsName()
        case .registeredToTutorialGroupNotification:
            R.string.localizable.tutorialRegisteredSettingsName()
        case .tutorialGroupAssignedNotification:
            R.string.localizable.tutorialAssignedSettingsName()
        case .tutorialGroupDeletedNotification:
            R.string.localizable.tutorialDeletedSettingsName()
        case .tutorialGroupUnassignedNotification:
            R.string.localizable.tutorialUnassignedSettingsName()
        case .unknown:
            ""
        }
    }

    var settingsSubtitle: String? {
        switch self {
        case .addedToChannelNotification:
            R.string.localizable.addChannelSettingsSubtitle()
        case .channelDeletedNotification:
            R.string.localizable.deleteChannelSettingsSubtitle()
        case .newAnswerNotification:
            R.string.localizable.newReplySettingsSubtitle()
        case .newMentionNotification:
            R.string.localizable.newMentionSettingsSubtitle()
        case .newPostNotification:
            R.string.localizable.newMessageSettingsSubtitle()
        case .removedFromChannelNotification:
            R.string.localizable.removeChannelSettingsSubtitle()
        case .attachmentChangedNotification:
            R.string.localizable.attachmentChangedSettingsSubtitle()
        case .deregisteredFromTutorialGroupNotification:
            R.string.localizable.tutorialDeregisteredSettingsSubtitle()
        case .duplicateTestCaseNotification:
            R.string.localizable.duplicateTestSettingsSubtitle()
        case .newExerciseNotification:
            R.string.localizable.exerciseReleasedSettingsSubtitle()
        case .newManualFeedbackRequestNotification:
            R.string.localizable.feedbackRequestSettingsSubtitle()
        case .registeredToTutorialGroupNotification:
            R.string.localizable.tutorialRegisteredSettingsSubtitle()
        case .tutorialGroupAssignedNotification:
            R.string.localizable.tutorialAssignedSettingsSubtitle()
        case .tutorialGroupUnassignedNotification:
            R.string.localizable.tutorialUnassignedSettingsSubtitle()
        default:
            nil
        }
    }
}
