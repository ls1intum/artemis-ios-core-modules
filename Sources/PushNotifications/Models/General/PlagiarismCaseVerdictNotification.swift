//
//  PlagiarismCaseVerdictNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct PlagiarismCaseVerdictNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var exerciseId: Int?
    public var exerciseTitle: String?
    public var exerciseType: String?
    public var verdict: String?
}
