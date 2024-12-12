//
//  File.swift
//  
//
//  Created by Sven Andabaka on 12.03.23.
//

import Foundation

public class PushNotificationResponseHandler {

    public static func getConversationId(from userInfo: [AnyHashable: Any]) -> Int? {
        guard let targetString = userInfo[PushNotificationUserInfoKeys.target] as? String,
              let typeString = userInfo[PushNotificationUserInfoKeys.type] as? String else {
            return nil
        }

        guard let type = PushNotificationType(rawValue: typeString) else { return nil }

        switch type {
        case .newReplyForCoursePost, .newCoursePost, .newAnnouncementPost,
                .newExercisePost, .newReplyForExercisePost, .newLecturePost,
                .newReplyForLecturePost, .newExamPost, .newReplyForExamPost,
                .conversationCreateGroupChat, .conversationAddUserChannel,
                .conversationAddUserGroupChat, .conversationRemoveUserChannel,
                .conversationRemoveUserGroupChat, .conversationNewMessage:
            guard let target = try? JSONDecoder().decode(ConversationTarget.self, from: Data(targetString.utf8)) else { return nil }
            return target.conversation
        default:
            return nil
        }
    }

    public static func getTarget(userInfo: [AnyHashable: Any]) -> String? {
        guard let targetString = userInfo[PushNotificationUserInfoKeys.target] as? String,
              let typeString = userInfo[PushNotificationUserInfoKeys.type] as? String else {
            return nil
        }

        guard let type = PushNotificationType(rawValue: typeString) else { return nil }

        return PushNotificationResponseHandler.getTarget(type: type, targetString: targetString)
    }

    public static func getTarget(type: PushNotificationType, targetString: String) -> String? {
        let decoder = JSONDecoder()
        let targetData = Data(targetString.utf8)

        switch type {
        case .quizExerciseStarted:
            guard let target = try? decoder.decode(QuizExerciseStartedTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/quiz-exercises/\(target.id)/live"
        case .newReplyForCoursePost, .newCoursePost, .newAnnouncementPost,
                .newExercisePost, .newReplyForExercisePost,
                .newLecturePost, .newReplyForLecturePost,
                .newExamPost, .newReplyForExamPost:
            guard let target = try? decoder.decode(NewPostTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/communication?conversationId=\(target.conversation)"
        case .conversationCreateGroupChat,
                .conversationAddUserChannel,
                .conversationAddUserGroupChat,
                .conversationRemoveUserChannel,
                .conversationRemoveUserGroupChat,
                .conversationNewMessage,
                .conversationNewReplyMessage:
            guard let target = try? decoder.decode(ConversationTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/communication?conversationId=\(target.conversation)"
        default:
            guard let target = try? decoder.decode(GeneralTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/\(target.entity)/\(target.id)"
        }
    }
}

private struct QuizExerciseStartedTarget: Codable {
    let course: Int
    let id: Int
}

private struct NewPostTarget: Codable {
    let course: Int
    let conversation: Int
    let id: Int
}

private struct ConversationTarget: Codable {
    let conversation: Int
    let course: Int
}

private struct GeneralTarget: Codable {
    let course: Int
    let id: Int
    let entity: String
}
