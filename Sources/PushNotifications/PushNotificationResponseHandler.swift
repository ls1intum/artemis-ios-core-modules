//
//  File.swift
//  
//
//  Created by Sven Andabaka on 12.03.23.
//

import Foundation

public class PushNotificationResponseHandler {

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
        case .newReplyForCoursePost, .newCoursePost, .newAnnouncementPost:
            guard let target = try? decoder.decode(NewCoursePostTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/communication?conversationId=\(target.conversation)"
        case .newExercisePost, .newReplyForExercisePost:
            guard let target = try? decoder.decode(NewExercisePostTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/exercises/\(target.exercise ?? target.exerciseId ?? 0)?postId=\(target.id)"
        case .newLecturePost, .newReplyForLecturePost:
            guard let target = try? decoder.decode(NewLecturePostTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/lectures/\(target.lecture ?? target.lectureId ?? 0)?postId=\(target.id)"
        case .conversationCreateGroupChat,
                .conversationAddUserChannel,
                .conversationAddUserGroupChat,
                .conversationRemoveUserChannel,
                .conversationRemoveUserGroupChat:
            guard let target = try? decoder.decode(NewLecturePostTarget.self, from: targetData) else { return nil }
            return "courses/\(target.course)/communication?conversationId=\(target.id)"
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

private struct NewCoursePostTarget: Codable {
    let course: Int
    let conversation: Int
    let id: Int
}

private struct NewExercisePostTarget: Codable {
    let id: Int
    let course: Int
    let exercise: Int?
    let exerciseId: Int?
}

private struct NewLecturePostTarget: Codable {
    let id: Int
    let course: Int
    let lecture: Int?
    let lectureId: Int?
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
