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

public extension ExerciseStatistics {
    static let mock = ExerciseStatistics(
        averageScoreOfExercise: 7.4,
        maxPointsOfExercise: 10,
        scoreDistribution: [1, 2, 3],
        numberOfExerciseScores: 9,
        numberOfParticipations: 9,
        numberOfStudentsOrTeamsInCourse: 10,
        numberOfPosts: 2,
        numberOfResolvedPosts: 1
    )
}
