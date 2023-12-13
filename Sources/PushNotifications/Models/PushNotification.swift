//
//  PushNotification.swift
//  Artemis
//
//  Created by Sven Andabaka on 19.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

enum PushNotificationVersionError: Error {
    case invalidVersion
}

struct PushNotificationVersion: Codable {
    let version: Int

    /// The version is 1, as of Artemis 6.6.7.
    ///
    /// The version is declared in the constants of Artemis, see [source](https://github.com/ls1intum/Artemis/blob/6.6.7/src/main/java/de/tum/in/www1/artemis/config/Constants.java#L318).
    var isValid: Bool {
        version == 1
    }
}

struct PushNotification: Codable {
    var notificationPlaceholders: [String] = []
    let target: String
    let type: PushNotificationType
    let version: Int

    var title: String? {
        type.title
    }

    var body: String? {
        type.getBody(notificationPlaceholders: notificationPlaceholders)
    }
}

public enum PushNotificationType: String, RawRepresentable, Codable {
    case exerciseSubmissionAssessed = "EXERCISE_SUBMISSION_ASSESSED"
    case attachmentChange = "ATTACHMENT_CHANGE"
    case exerciseReleased = "EXERCISE_RELEASED"
    case exercisePractice = "EXERCISE_PRACTICE"
    case quizExerciseStarted = "QUIZ_EXERCISE_STARTED"
    case exerciseUpdated = "EXERCISE_UPDATED"

    case newReplyForCoursePost = "NEW_REPLY_FOR_COURSE_POST"
    case newReplyForExercisePost = "NEW_REPLY_FOR_EXERCISE_POST"
    case newReplyForExamPost = "NEW_REPLY_FOR_EXAM_POST"
    case newReplyForLecturePost = "NEW_REPLY_FOR_LECTURE_POST"

    case newAnnouncementPost = "NEW_ANNOUNCEMENT_POST"
    case newCoursePost = "NEW_COURSE_POST"
    case newExamPost = "NEW_EXAM_POST"
    case newExercisePost = "NEW_EXERCISE_POST"
    case newLecturePost = "NEW_LECTURE_POST"

    case userMention = "USER_MENTION"

    case courseArchiveStarted = "COURSE_ARCHIVE_STARTED"
    case courseArchiveFinished = "COURSE_ARCHIVE_FINISHED"
    case courseArchiveFinishedWithError = "internal"
    case courseArchiveFinishedWithoutError = "internal2"
    case courseArchiveFailed = "COURSE_ARCHIVE_FAILED"
    case examArchiveStarted = "EXAM_ARCHIVE_STARTED"
    case examArchiveFinished = "EXAM_ARCHIVE_FINISHED"
    case examArchiveFinishedWithError = "internal3"
    case examArchiveFinishedWithoutError = "internal4"
    case examArchiveFailed = "EXAM_ARCHIVE_FAILED"

    case illegalSubmission = "ILLEGAL_SUBMISSION"
    case programmingTestCasesChanged = "PROGRAMMING_TEST_CASES_CHANGED"
    case fileSubmissionSuccessful = "FILE_SUBMISSION_SUCCESSFUL"
    case duplicateTestCase = "DUPLICATE_TEST_CASE"
    case newPlagiarismCaseStudent = "NEW_PLAGIARISM_CASE_STUDENT"
    case plagiarismCaseVerdictStudent = "PLAGIARISM_CASE_VERDICT_STUDENT"
    case newManualFeedbackRequest = "NEW_MANUAL_FEEDBACK_REQUEST"

    case tutorialGroupRegistrationStudent = "TUTORIAL_GROUP_REGISTRATION_STUDENT"
    case tutorialGroupDegregistrationStudent = "TUTORIAL_GROUP_DEREGISTRATION_STUDENT"
    case tutorialGroupRegistrationTutor = "TUTORIAL_GROUP_REGISTRATION_TUTOR"
    case tutorialGroupMultipleRegistrationTutor = "TUTORIAL_GROUP_MULTIPLE_REGISTRATION_TUTOR"
    case tutorialGroupDeregistrationTutor = "TUTORIAL_GROUP_DEREGISTRATION_TUTOR"
    case tutorialGroupDeleted = "TUTORIAL_GROUP_DELETED"
    case tutorialGroupUpdated = "TUTORIAL_GROUP_UPDATED"
    case tutorialGroupAssigned = "TUTORIAL_GROUP_ASSIGNED"
    case tutorialGroupUnassigned = "TUTORIAL_GROUP_UNASSIGNED"

    case conversationNewMessage = "CONVERSATION_NEW_MESSAGE"
    case conversationNewReplyMessage = "CONVERSATION NEW REPLY MESSAGE"
    case conversationCreateOneToOneChat = "CONVERSATION_CREATE_ONE_TO_ONE_CHAT"
    case conversationCreateGroupChat = "CONVERSATION_CREATE_GROUP_CHAT"
    case conversationAddUserGroupChat = "CONVERSATION_ADD_USER_GROUP_CHAT"
    case conversationAddUserChannel = "CONVERSATION_ADD_USER_CHANNEL"
    case conversationRemoveUserGroupChat = "CONVERSATION_REMOVE_USER_GROUP_CHAT"
    case conversationRemoveUserChannel = "CONVERSATION_REMOVE_USER_CHANNEL"
    case conversationDeleteChannel = "CONVERSATION_DELETE_CHANNEL"

    public var title: String? {
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
        case .newReplyForCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForCoursePost()
        case .newReplyForExamPost:
            return "artemisApp.groupNotification.title.newReplyForExamPost"
        case .newReplyForExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForExercisePost()
        case .newReplyForLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewReplyForLecturePost()
        case .newAnnouncementPost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewAnnouncementPost()
        case .newCoursePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewCoursePost()
        case .newExamPost:
            return "artemisApp.groupNotification.title.newExamPost"
        case .newExercisePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewExercisePost()
        case .newLecturePost:
            return R.string.localizable.artemisAppGroupNotificationTitleNewLecturePost()
        case .userMention:
            return "artemisApp.singleUserNotification.title.mentionedInMessage"
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
        case .exerciseUpdated:
            return R.string.localizable.artemisAppGroupNotificationTitleExerciseUpdated()
        case .courseArchiveStarted:
            return R.string.localizable.artemisAppGroupNotificationTitleCourseArchiveStarted()
        case .courseArchiveFinished,
                .courseArchiveFinishedWithError,
                .courseArchiveFinishedWithoutError:
            return R.string.localizable.artemisAppGroupNotificationTitleCourseArchiveFinished()
        case .courseArchiveFailed:
            return R.string.localizable.artemisAppGroupNotificationTitleCourseArchiveFailed()
        case .examArchiveStarted:
            return R.string.localizable.artemisAppGroupNotificationTitleExamArchiveStarted()
        case .examArchiveFinished,
                .examArchiveFinishedWithError,
                .examArchiveFinishedWithoutError:
            return R.string.localizable.artemisAppGroupNotificationTitleExamArchiveFinished()
        case .examArchiveFailed:
            return R.string.localizable.artemisAppGroupNotificationTitleExamArchiveFailed()
        case .illegalSubmission:
            return R.string.localizable.artemisAppGroupNotificationTitleIllegalSubmission()
        case .programmingTestCasesChanged:
            return R.string.localizable.artemisAppGroupNotificationTitleProgrammingTestCasesChanged()
        case .newManualFeedbackRequest:
            return R.string.localizable.artemisAppGroupNotificationTitleNewManualFeedbackRequest()
        case .tutorialGroupRegistrationStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupRegistrationStudent()
        case .tutorialGroupDegregistrationStudent:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupDeregistrationStudent()
        case .tutorialGroupRegistrationTutor:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupRegistrationTutor()
        case .tutorialGroupMultipleRegistrationTutor:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupMultipleRegistrationTutor()
        case .tutorialGroupDeregistrationTutor:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupDeregistrationTutor()
        case .tutorialGroupDeleted:
            return R.string.localizable.artemisAppTutorialGroupNotificationTitleTutorialGroupDeleted()
        case .tutorialGroupUpdated:
            return R.string.localizable.artemisAppTutorialGroupNotificationTitleTutorialGroupUpdated()
        case .tutorialGroupAssigned:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupAssigned()
        case .tutorialGroupUnassigned:
            return R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupUnassigned()
        case .conversationCreateOneToOneChat:
            return nil
        case .conversationCreateGroupChat:
            return R.string.localizable.artemisAppSingleUserNotificationTitleCreateGroupChat()
        case .conversationAddUserGroupChat:
            return R.string.localizable.artemisAppSingleUserNotificationTitleAddUserGroupChat()
        case .conversationAddUserChannel:
            return R.string.localizable.artemisAppSingleUserNotificationTitleAddUserChannel()
        case .conversationRemoveUserGroupChat:
            return R.string.localizable.artemisAppSingleUserNotificationTitleRemoveUserGroupChat()
        case .conversationRemoveUserChannel:
            return R.string.localizable.artemisAppSingleUserNotificationTitleRemoveUserChannel()
        case .conversationDeleteChannel:
            return R.string.localizable.artemisAppSingleUserNotificationTitleDeleteChannel()
        }
    }

    // TODO: add checks for length
    // swiftlint:disable cyclomatic_complexity function_body_length empty_count
    public func getBody(notificationPlaceholders: [String]) -> String? {
        switch self {
        case .exerciseSubmissionAssessed:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextExerciseSubmissionAssessed(notificationPlaceholders[0],
                                                                                                       notificationPlaceholders[1],
                                                                                                       notificationPlaceholders[2])
        case .attachmentChange:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextAttachmentChange(notificationPlaceholders[0],
                                                                                        notificationPlaceholders[1],
                                                                                        notificationPlaceholders[2])
        case .exerciseReleased:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExerciseReleased(notificationPlaceholders[1])
        case .exercisePractice:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExercisePractice(notificationPlaceholders[1])
        case .quizExerciseStarted:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextQuizExerciseStarted(notificationPlaceholders[1])
        case .newReplyForLecturePost:
            guard notificationPlaceholders.count > 8 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForLecturePost(notificationPlaceholders[0],
                                                                                              notificationPlaceholders[4],
                                                                                              notificationPlaceholders[5],
                                                                                              notificationPlaceholders[8])
        case .newReplyForCoursePost:
            guard notificationPlaceholders.count > 5 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForCoursePost(notificationPlaceholders[0],
                                                                                             notificationPlaceholders[4],
                                                                                             notificationPlaceholders[5])
        case .newReplyForExamPost:
            return nil
        case .newReplyForExercisePost:
            guard notificationPlaceholders.count > 8 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewReplyForExercisePost(notificationPlaceholders[0],
                                                                                               notificationPlaceholders[4],
                                                                                               notificationPlaceholders[5],
                                                                                               notificationPlaceholders[8])
        case .newAnnouncementPost:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewAnnouncementPost(notificationPlaceholders[0],
                                                                                           notificationPlaceholders[2])
        case .newCoursePost:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewCoursePost(notificationPlaceholders[0],
                                                                                     notificationPlaceholders[2])
        case .newExamPost:
            return nil
        case .newExercisePost:
            guard notificationPlaceholders.count > 5 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewExercisePost(notificationPlaceholders[0],
                                                                                       notificationPlaceholders[2],
                                                                                       notificationPlaceholders[5])
        case .newLecturePost:
            guard notificationPlaceholders.count > 5 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewLecturePost(notificationPlaceholders[0],
                                                                                      notificationPlaceholders[2],
                                                                                      notificationPlaceholders[5])
        case .userMention:
            return nil
        case .fileSubmissionSuccessful:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextFileSubmissionSuccessful(notificationPlaceholders[1])
        case .duplicateTestCase:
            return nil
        case .newPlagiarismCaseStudent:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextNewPlagiarismCaseStudent(notificationPlaceholders[1],
                                                                                                     notificationPlaceholders[2])
        case .plagiarismCaseVerdictStudent:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextPlagiarismCaseVerdictStudent(notificationPlaceholders[1],
                                                                                                         notificationPlaceholders[2])
        case .conversationNewMessage:
            guard notificationPlaceholders.count > 5 else { return nil }
            switch notificationPlaceholders[5] {
            case "channel":
                return R.string.localizable.artemisAppConversationNotificationTextNewMessageChannel(notificationPlaceholders[0],
                                                                                                    notificationPlaceholders[3],
                                                                                                    notificationPlaceholders[4])
            case "groupChat":
                return R.string.localizable.artemisAppConversationNotificationTextNewMessageGroupChat(notificationPlaceholders[0],
                                                                                                      notificationPlaceholders[3])
            case "oneToOneChat":
                return R.string.localizable.artemisAppConversationNotificationTextNewMessageDirect(notificationPlaceholders[0],
                                                                                                   notificationPlaceholders[3])
            default:
                return nil
            }
        case .conversationNewReplyMessage:
            guard notificationPlaceholders.count > 6 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextMessageReply(notificationPlaceholders[0],
                                                                                         notificationPlaceholders[6])
        case .exerciseUpdated:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExerciseUpdated(notificationPlaceholders[0],
                                                                                       notificationPlaceholders[1])
        case .courseArchiveStarted:
            guard notificationPlaceholders.count > 0 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextCourseArchiveStarted(notificationPlaceholders[0])
        case .courseArchiveFinished:
            // TODO: difference between with and without error not possible yet
            guard notificationPlaceholders.count > 0 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextCourseArchiveFinishedWithoutErrors(notificationPlaceholders[0])
        case .courseArchiveFinishedWithError:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextCourseArchiveFinishedWithErrors(notificationPlaceholders[0],
                                                                                                       notificationPlaceholders[1])
        case .courseArchiveFinishedWithoutError:
            guard notificationPlaceholders.count > 0 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextCourseArchiveFinishedWithoutErrors(notificationPlaceholders[0])
        case .courseArchiveFailed:
            guard notificationPlaceholders.count > 0 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextCourseArchiveFailed(notificationPlaceholders[0])
        case .examArchiveStarted:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExamArchiveStarted(notificationPlaceholders[1])
        case .examArchiveFinished:
            // TODO: difference between with and without error not possible yet
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExamArchiveFinishedWithoutErrors(notificationPlaceholders[1])
        case .examArchiveFinishedWithError:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExamArchiveFinishedWithErrors(notificationPlaceholders[1],
                                                                                                     notificationPlaceholders[2])
        case .examArchiveFinishedWithoutError:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExamArchiveFinishedWithoutErrors(notificationPlaceholders[1])
        case .examArchiveFailed:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextExamArchiveFailed(notificationPlaceholders[1],
                                                                                         notificationPlaceholders[2])
        case .illegalSubmission:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextIllegalSubmission(notificationPlaceholders[1])
        case .programmingTestCasesChanged:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextProgrammingTestCasesChanged(notificationPlaceholders[0],
                                                                                                   notificationPlaceholders[1])
        case .newManualFeedbackRequest:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppGroupNotificationTextNewManualFeedbackRequest(notificationPlaceholders[0],
                                                                                                notificationPlaceholders[1])
        case .tutorialGroupRegistrationStudent:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupRegistrationStudent(notificationPlaceholders[1],
                                                                                                             notificationPlaceholders[2])
        case .tutorialGroupDegregistrationStudent:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupDeregistrationStudent(notificationPlaceholders[1],
                                                                                                               notificationPlaceholders[2])
        case .tutorialGroupRegistrationTutor:
            guard notificationPlaceholders.count > 3 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupRegistrationTutor(notificationPlaceholders[1],
                                                                                                           notificationPlaceholders[2],
                                                                                                           notificationPlaceholders[3])
        case .tutorialGroupMultipleRegistrationTutor:
            guard notificationPlaceholders.count > 3 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupMultipleRegistrationTutor(notificationPlaceholders[1],
                                                                                                                   notificationPlaceholders[2],
                                                                                                                   notificationPlaceholders[3])
        case .tutorialGroupDeregistrationTutor:
            guard notificationPlaceholders.count > 3 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupDeregistrationTutor(notificationPlaceholders[1],
                                                                                                             notificationPlaceholders[2],
                                                                                                             notificationPlaceholders[3])
        case .tutorialGroupDeleted:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppTutorialGroupNotificationTextTutorialGroupDeleted(notificationPlaceholders[1])
        case .tutorialGroupUpdated:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppTutorialGroupNotificationTextTutorialGroupUpdated(notificationPlaceholders[1])
        case .tutorialGroupAssigned:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupAssigned(notificationPlaceholders[1],
                                                                                                  notificationPlaceholders[2])
        case .tutorialGroupUnassigned:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupUnassigned(notificationPlaceholders[1],
                                                                                                    notificationPlaceholders[2])
        case .conversationCreateOneToOneChat:
            return nil
        case .conversationCreateGroupChat:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextCreateGroupChat(notificationPlaceholders[0],
                                                                                            notificationPlaceholders[1])
        case .conversationAddUserGroupChat:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextAddUserGroupChat(notificationPlaceholders[0],
                                                                                             notificationPlaceholders[1])
        case .conversationAddUserChannel:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextAddUserChannel(notificationPlaceholders[0],
                                                                                           notificationPlaceholders[1],
                                                                                           notificationPlaceholders[2])
        case .conversationRemoveUserGroupChat:
            guard notificationPlaceholders.count > 1 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextRemoveUserGroupChat(notificationPlaceholders[0],
                                                                                                notificationPlaceholders[1])
        case .conversationRemoveUserChannel:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextRemoveUserChannel(notificationPlaceholders[0],
                                                                                              notificationPlaceholders[1],
                                                                                              notificationPlaceholders[2])
        case .conversationDeleteChannel:
            guard notificationPlaceholders.count > 2 else { return nil }
            return R.string.localizable.artemisAppSingleUserNotificationTextDeleteChannel(notificationPlaceholders[0],
                                                                                          notificationPlaceholders[1],
                                                                                          notificationPlaceholders[2])
        }
    }
}
