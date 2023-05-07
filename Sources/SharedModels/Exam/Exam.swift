//
//  Exam.swift
//
//  Created by Tom Rudnick on 06.02.23.
//

import Foundation

public struct Exam: Codable {
    public let id: Int
    public let title: String
    /// Start of working time
    public var startDate: Date?
    /// End of working time, start of assessment time
    public var endDate: Date?
    /// End of assessment date
    public var publishResultsDate: Date?
    public var exerciseGroups: [ExerciseGroup]?
}
