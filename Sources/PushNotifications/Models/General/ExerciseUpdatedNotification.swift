//
//  ExerciseUpdatedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct ExerciseUpdatedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
}

extension ExerciseUpdatedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppGroupNotificationTitleExerciseUpdated()
    }

    public var body: String? {
        R.string.localizable.exerciseUpdatedBody(exerciseTitle ?? "")
    }
}

extension ExerciseUpdatedNotification: NavigatableNotification {
    public var relativePath: String? {
        exercisePath(courseId: courseId, exerciseId: exerciseId)
    }
}
