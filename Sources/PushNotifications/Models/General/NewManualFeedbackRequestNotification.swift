//
//  NewManualFeedbackRequestNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct NewManualFeedbackRequestNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
}

extension NewManualFeedbackRequestNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.newManualFeedbackRequest()
    }

    public var body: String? {
        R.string.localizable.manualFeedbackRequestBody(exerciseTitle ?? "")
    }
}
