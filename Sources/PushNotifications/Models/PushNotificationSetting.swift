//
//  File.swift
//  
//
//  Created by Sven Andabaka on 28.03.23.
//

import Foundation

public struct PushNotificationSetting: Codable {
    public let id: Int64?
    public let settingId: PushNotificationSettingId
    public let webapp: Bool
    public let email: Bool
    public var push: Bool
}

public enum PushNotificationSettingId: String, Codable {
    // Course-Wide Dicussion Notifications
    case newCoursePost = "notification.course-wide-discussion.new-course-post"
    case newReplyForCoursePost = "notification.course-wide-discussion.new-reply-for-course-post"
    case newAnnouncementPost = "notification.course-wide-discussion.new-announcement-post"

    // Exam notifications
    case newExamPost = "notification.exam-notification.new-exam-post"
    case newReplyForExamPost = "notification.exam-notification.new-reply-for-exam-post"

    // Exercise Notifications
    case exerciseReleased = "notification.exercise-notification.exercise-released"
    case exercisePractice = "notification.exercise-notification.exercise-open-for-practice"
    case exerciseSubmissionAssessed = "notification.exercise-notification.exercise-submission-assessed"
    case fileSubmissionSuccessful = "notification.exercise-notification.file-submission-successful"
    case newExercisePost = "notification.exercise-notification.new-exercise-post"
    case newReplyForExercisePost = "notification.exercise-notification.new-reply-for-exercise-post"

    // Lecture Notifications
    case attachmentChange = "notification.lecture-notification.attachment-changes"
    case newLecturePost = "notification.lecture-notification.new-lecture-post"
    case newReplyForLecturePost = "notification.lecture-notification.new-reply-for-lecture-post"

    // Tutorial Group Notifications
    case tutorialGroupRegistrationStudent = "notification.tutorial-group-notification.tutorial-group-registration"
    case tutorialGroupDeleteUpdateStudent = "notification.tutorial-group-notification.tutorial-group-delete-update"

    // Tutor Group Notifications
    case tutorialGroupRegistrationTutor = "notification.tutor-notification.tutorial-group-registration"
    case tutorialGroupAssignUnassignTutor = "notification.tutor-notification.tutorial-group-assign-unassign"

    // User Notifications
    case userMention = "notification.user-notification.user-mention"

    case unknown

    public init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(RawValue.self)
        self = try PushNotificationSettingId(rawValue: rawValue) ?? .unknown
    }
}

extension PushNotificationSettingId: Identifiable {
    public var id: Self {
        self
    }
}
