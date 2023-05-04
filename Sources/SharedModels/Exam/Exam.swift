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
    public var startDate: String?
    /// End of working time, start of assessment time
    public var endDate: String?
    /// End of assessment date
    public var publishResultsDate: String?
    public var exerciseGroups: [ExerciseGroup]?
}
