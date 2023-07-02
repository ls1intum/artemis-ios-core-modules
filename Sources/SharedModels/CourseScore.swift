//
//  CourseScore.swift
//  
//
//  Created by Sven Andabaka on 25.04.23.
//

import Foundation

public struct CourseScore: Codable {
    public var maxPoints: Double
    public var reachablePoints: Double
    public var studentScores: StudentScore
}

public struct StudentScore: Codable {
    public var absoluteScore: Double
    public var relativeScore: Double
    public var currentRelativeScore: Double
    public var presentationScore: Double
}
