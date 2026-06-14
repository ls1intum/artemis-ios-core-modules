//
//  IrisResponseNotification.swift
//  ArtemisCore
//
//  Created by Senan Aslan on 11.06.26.
//

public struct IrisResponseNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var sessionId: Int?
    public var messagePreview: String?
    public var chatTitle: String?
}

extension IrisResponseNotification: DisplayableNotification {
    public var title: String {
        if let chatTitle {
            "Iris - \(chatTitle)"
        } else {
            "Iris"
        }
    }

    public var body: String? {
        messagePreview
    }
}

extension IrisResponseNotification: NavigatableNotification {
    public var relativePath: String? {
        guard let courseId, let sessionId else { return nil }
        return "courses/\(courseId)/iris?sessionId=\(sessionId)"
    }
}
