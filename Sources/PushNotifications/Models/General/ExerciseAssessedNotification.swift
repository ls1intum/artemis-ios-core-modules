//
//  ExerciseAssessedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct ExerciseAssessedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
    public var exerciseType: String?
    public var numberOfPoints: Int?
    public var score: Int?
}

extension ExerciseAssessedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleExerciseSubmissionAssessed()
    }

    public var body: String? {
        R.string.localizable.submissionAssessedBody(exerciseType ?? "", exerciseTitle ?? "")
    }
}

extension ExerciseAssessedNotification: NavigatableNotification {
    public var relativePath: String? {
        exercisePath(courseId: courseId, exerciseId: exerciseId)
    }
}
