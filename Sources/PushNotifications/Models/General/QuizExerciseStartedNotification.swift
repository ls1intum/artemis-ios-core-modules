//
//  QuizExerciseStartedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct QuizExerciseStartedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
}

extension QuizExerciseStartedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppGroupNotificationTitleQuizExerciseStarted()
    }

    public var body: String? {
        R.string.localizable.artemisAppGroupNotificationTextQuizExerciseStarted(exerciseTitle ?? "")
    }
}
