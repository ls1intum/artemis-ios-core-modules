//
//  ExerciseStatistics.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//

import Foundation

public struct ExerciseStatistics: Codable {
    public let averageScoreOfExercise: Double?
    public let maxPointsOfExercise: Double?
    public let scoreDistribution: [Int]?
    public let numberOfExerciseScores: Int?
    public let numberOfParticipations: Int?
    public let numberOfStudentsOrTeamsInCourse: Int?
    public let numberOfPosts: Int?
    public let numberOfResolvedPosts: Int?
}
