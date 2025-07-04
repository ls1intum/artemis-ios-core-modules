//
//  ExerciseOpenForPracticeNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct ExerciseOpenForPracticeNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
}

extension ExerciseOpenForPracticeNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppGroupNotificationTitleExercisePractice()
    }

    public var body: String? {
        R.string.localizable.artemisAppGroupNotificationTextExercisePractice(exerciseTitle ?? "")
    }
}

extension ExerciseOpenForPracticeNotification: NavigatableNotification {
    public var relativePath: String? {
        exercisePath(courseId: courseId, exerciseId: exerciseId)
    }
}

