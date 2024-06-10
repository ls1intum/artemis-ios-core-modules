//
//  ExerciseForAssessment.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//
// swiftlint: disable discouraged_optional_boolean

import Foundation

/// Represents assessment-related statistics for an exercise
public struct ExerciseStatsForAssessmentDashboard: Codable {
    public let numberOfStudent: Int?
    public let numberOfSubmissions: DueDateStat?
    public let totalNumberOfAssessments: DueDateStat?
    public let numberOfAssessmentsOfCorrectionRounds: [DueDateStat]?
    public let complaintsEnabled: Bool?
    public let feedbackRequestEnabled: Bool?
}

public extension ExerciseStatsForAssessmentDashboard {
    static let mock = ExerciseStatsForAssessmentDashboard(
        numberOfStudent: 10,
        numberOfSubmissions: DueDateStat(inTime: 8, late: 1),
        totalNumberOfAssessments: DueDateStat(inTime: 5, late: 4),
        numberOfAssessmentsOfCorrectionRounds: [DueDateStat(inTime: 1, late: 0)],
        complaintsEnabled: false,
        feedbackRequestEnabled: false
    )
}
