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

public extension CourseScore {
    init() {
        self.maxPoints = 0
        self.reachablePoints = 0
        self.studentScores = StudentScore()
    }
}

public struct StudentScore: Codable {
    public var absoluteScore: Double
    public var relativeScore: Double
    public var currentRelativeScore: Double
    public var presentationScore: Double
}

public extension StudentScore {
    init() {
        self.absoluteScore = 0
        self.relativeScore = 0
        self.currentRelativeScore = 0
        self.presentationScore = 0
    }
}
