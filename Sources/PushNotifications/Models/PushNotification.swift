//
//  PushNotification.swift
//  Artemis
//
//  Created by Sven Andabaka on 19.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

struct PushNotification: Codable {
    var notificationPlaceholders: [String] = []
    var target: String
    var type: PushNotificationType

    var title: String {
        type.title
    }

    var body: String {
        type.getBody(notificationPlaceholders: notificationPlaceholders)
    }
}

public enum PushNotificationType: String, RawRepresentable, Codable {
    case exerciseSubmissionAssessed = "EXERCISE_SUBMISSION_ASSESSED"
    case attachmentChange = "ATTACHMENT_CHANGE"
    case exerciseReleased = "EXERCISE_RELEASED"
    case exercisePractice = "EXERCISE_PRACTICE"
    case quizExerciseStarted = "QUIZ_EXERCISE_STARTED"
    case newReplyForLecturePost = "NEW_REPLY_FOR_LECTURE_POST"
    case newReplyForCoursePost = "NEW_REPLY_FOR_COURSE_POST"
    case newReplyForExercisePost = "NEW_REPLY_FOR_EXERCISE_POST"
    case newExercisePost = "NEW_EXERCISE_POST"
    case newLecturePost = "NEW_LECTURE_POST"
    case newCoursePost = "NEW_COURSE_POST"
    case newAnnouncementPost = "NEW_ANNOUNCEMENT_POST"
    case fileSubmissionSuccessful = "FILE_SUBMISSION_SUCCESSFUL"
    case duplicateTestCase = "DUPLICATE_TEST_CASE"
    case newPlagiarismCaseStudent = "NEW_PLAGIARISM_CASE_STUDENT"
    case plagiarismCaseVerdictStudent = "PLAGIARISM_CASE_VERDICT_STUDENT"
    case conversationNewMessage = "CONVERSATION_NEW_MESSAGE"
    case conversationNewReplyMessage = "CONVERSATION NEW REPLY MESSAGE"

    // TODO: maybe following needed as well
//    TUTORIAL_GROUP_REGISTRATION_STUDENT, TUTORIAL_GROUP_REGISTRATION_TUTOR, TUTORIAL_GROUP_MULTIPLE_REGISTRATION_TUTOR, TUTORIAL_GROUP_DEREGISTRATION_STUDENT,
//    TUTORIAL_GROUP_DEREGISTRATION_TUTOR, TUTORIAL_GROUP_DELETED, TUTORIAL_GROUP_UPDATED, TUTORIAL_GROUP_ASSIGNED, TUTORIAL_GROUP_UNASSIGNED,

    public var title: String {
        switch self {
        case .exerciseSubmissionAssessed:
            return R.string.localizable.artemisAppSingleUserNotificationTitleExerciseSubmissionAssessed()
        case .attachmentChange:
            return R.string.localizable.artemisAppGroupNotificationTitleAttachmentChange()
        case .exerciseReleased:
            return R.string.localizable.artemisAppGroupNotificationTitleExerciseReleased()
        case .exercisePractice:
            return R.string.localizable.artemisAppGroupNotificationTitleExercisePractice()
        case .quizExerciseStarted:
            return R.string.localizable.artemisAppGroupNotificationTitleQuizExerciseStarted()
        case .newReplyForLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForLecturePost()
        case .newReplyForCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForCoursePost()
        case .newReplyForExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForExercisePost()
        case .newExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewExercisePost()
        case .newLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewLecturePost()
        case .newCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewCoursePost()
        case .newAnnouncementPost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewAnnouncementPost()
        case .fileSubmissionSuccessful:
            return R.string.localizable.artemisAppSingleUserNotificationTitleFileSubmissionSuccessful()
        case .duplicateTestCase:
            return R.string.localizable.artemisAppGroupNotificationTitleDuplicateTestCase()
        case .newPlagiarismCaseStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTitleNewPlagiarismCaseStudent()
        case .plagiarismCaseVerdictStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTitlePlagiarismCaseVerdictStudent()
        case .conversationNewMessage:
            return R.string.localizable.artemisAppConversationNotificationTitleNewMessage()
        case .conversationNewReplyMessage:
            return R.string.localizable.artemisAppSingleUserNotificationTitleMessageReply()
        }
    }

    public func getBody(notificationPlaceholders: [String]) -> String {
        switch self {
        case .exerciseSubmissionAssessed:
            return R.string.localizable.artemisAppSingleUserNotificationTextExerciseSubmissionAssessed(notificationPlaceholders[0],
                                                                                                       notificationPlaceholders[1],
                                                                                                       notificationPlaceholders[2])
        case .attachmentChange:
            return R.string.localizable.artemisAppGroupNotificationTextAttachmentChange(notificationPlaceholders[0],
                                                                                        notificationPlaceholders[1],
                                                                                        notificationPlaceholders[2])
        case .exerciseReleased:
            return R.string.localizable.artemisAppGroupNotificationTextExerciseReleased(notificationPlaceholders[1])
        case .exercisePractice:
            return R.string.localizable.artemisAppGroupNotificationTextExercisePractice(notificationPlaceholders[1])
        case .quizExerciseStarted:
            return R.string.localizable.artemisAppGroupNotificationTextQuizExerciseStarted(notificationPlaceholders[1])
        case .newReplyForLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForLecturePost(notificationPlaceholders[0],
                                                                                              notificationPlaceholders[4],
                                                                                              notificationPlaceholders[5],
                                                                                              notificationPlaceholders[8])
        case .newReplyForCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForCoursePost(notificationPlaceholders[0],
                                                                                             notificationPlaceholders[4],
                                                                                             notificationPlaceholders[5])
        case .newReplyForExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForExercisePost(notificationPlaceholders[0],
                                                                                               notificationPlaceholders[4],
                                                                                               notificationPlaceholders[5],
                                                                                               notificationPlaceholders[8])
        case .newExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewExercisePost(notificationPlaceholders[0],
                                                                                       notificationPlaceholders[2],
                                                                                       notificationPlaceholders[5])
        case .newLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewLecturePost(notificationPlaceholders[0],
                                                                                      notificationPlaceholders[2],
                                                                                      notificationPlaceholders[5])
        case .newCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTextNewCoursePost(notificationPlaceholders[0],
                                                                                     notificationPlaceholders[2])
        case .newAnnouncementPost:
            return R.string.localizable.artemisAppGroupNotificationTextNewAnnouncementPost(notificationPlaceholders[0],
                                                                                           notificationPlaceholders[2])
        case .fileSubmissionSuccessful:
            return R.string.localizable.artemisAppSingleUserNotificationTextFileSubmissionSuccessful(notificationPlaceholders[1])
        case .duplicateTestCase:
            return R.string.localizable.artemisAppGroupNotificationTextDuplicateTestCase()
        case .newPlagiarismCaseStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTextNewPlagiarismCaseStudent(notificationPlaceholders[1],
                                                                                                     notificationPlaceholders[2])
        case .plagiarismCaseVerdictStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTextPlagiarismCaseVerdictStudent(notificationPlaceholders[1],
                                                                                                         notificationPlaceholders[2])
        case .conversationNewMessage:
            // TODO: once https://github.com/ls1intum/Artemis/pull/6679/ is merged
            return "TODO"
        case .conversationNewReplyMessage:
            return R.string.localizable.artemisAppSingleUserNotificationTextMessageReply(notificationPlaceholders[0],
                                                                                         notificationPlaceholders[6])
        }
    }

}
