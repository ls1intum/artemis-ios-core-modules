//
//  NavigatableNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 05.07.25.
//

public protocol NavigatableNotification {
    var relativePath: String? { get }
}

extension NavigatableNotification {
    func communicationPath(courseId: Int?, conversationId: Int?, threadId: Int? = nil, conversationName: String? = nil) -> String? {
        guard let courseId, let conversationId else { return nil }
        var path = "courses/\(courseId)/communication?conversationId=\(conversationId)"
        if let threadId {
            path += "&focusPostId=\(threadId)"
        }
        if let conversationName {
            path += "&conversationName=\(conversationName.replacing(" ", with: ""))"
        }
        return path
    }

    func exercisePath(courseId: Int?, exerciseId: Int?) -> String? {
        guard let courseId else { return nil }
        var path = "courses/\(courseId)/exercises"
        guard let exerciseId else { return path }
        path += "/\(exerciseId)"
        return path
    }
}
