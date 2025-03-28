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
