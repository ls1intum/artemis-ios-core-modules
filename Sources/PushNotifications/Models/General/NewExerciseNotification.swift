//
//  NewExerciseNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct NewExerciseNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
    public var difficulty: String?
    public var releaseDate: String?
    public var dueDate: String?
    public var numberOfPoints: Int?
}
