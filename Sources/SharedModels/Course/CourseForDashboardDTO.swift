//
//  File.swift
//
//
//  Created by Sven Andabaka on 25.04.23.
//

import Foundation

public struct CourseForDashboardDTO: Codable {
    public var course: Course
    public var totalScores: CourseScore?
    public var textScores: CourseScore?
    public var programmingScores: CourseScore?
    public var modelingScores: CourseScore?
    public var fileUploadScores: CourseScore?
    public var quizScores: CourseScore?
    public var participationResults: [ParticipationResultDTO]?

    public static let mock = CourseForDashboardDTO(
        course: .mock,
        totalScores: CourseScore(
            maxPoints: 15,
            reachablePoints: 15,
            studentScores: StudentScore(
                absoluteScore: 10,
                relativeScore: 0.5,
                currentRelativeScore: 0.5,
                presentationScore: 1.0
            )
        )
    )
}

public extension CourseForDashboardDTO {
    init(course: Course) {
        self.course = course
    }
}

extension CourseForDashboardDTO: Identifiable {
    public var id: Int {
        course.id
    }
}

public struct ParticipationResultDTO: Codable {
    public var score: Double?
    public var rated: Bool?
    public var participationId: Int?
}
