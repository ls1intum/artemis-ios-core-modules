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
    public let complaintsEnabled: Bool?
    public let feedbackRequestEnabled: Bool?
}

public struct DueDateStat: Codable {
    public let inTime: Int
    public let late: Int
}
