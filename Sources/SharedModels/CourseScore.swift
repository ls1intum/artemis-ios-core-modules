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

    public init(maxPoints: Double,
                reachablePoints: Double,
                studentScores: StudentScore) {
        self.maxPoints = maxPoints
        self.reachablePoints = reachablePoints
        self.studentScores = studentScores
    }
}

public struct StudentScore: Codable {
    public var absoluteScore: Double
    public var relativeScore: Double
    public var currentRelativeScore: Double
    public var presentationScore: Double

    public init(absoluteScore: Double,
                relativeScore: Double,
                currentRelativeScore: Double,
                presentationScore: Double) {
        self.absoluteScore = absoluteScore
        self.relativeScore = relativeScore
        self.currentRelativeScore = currentRelativeScore
        self.presentationScore = presentationScore
    }
}
