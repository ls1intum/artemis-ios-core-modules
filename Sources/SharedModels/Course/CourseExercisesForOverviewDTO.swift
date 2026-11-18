//
//  File.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 16.09.26.
//

import Foundation

public struct CourseExercisesForOverviewDTO: Codable {
    public let exercises: [Exercise]?
    public let totalScores: CourseScore?
    public let textScores: CourseScore?
    public let programmingScores: CourseScore?
    public let modelingScores: CourseScore?
    public let fileUploadScores: CourseScore?
    public let quizScores: CourseScore?
    public let participationResults: [ParticipationResultDTO]?
}

public extension CourseExercisesForOverviewDTO {
    static let mock: Self = .init(exercises: [.programming(exercise: .mock)],
                                  totalScores: nil,
                                  textScores: nil,
                                  programmingScores: nil,
                                  modelingScores: nil,
                                  fileUploadScores: nil,
                                  quizScores: nil,
                                  participationResults: nil)
}
