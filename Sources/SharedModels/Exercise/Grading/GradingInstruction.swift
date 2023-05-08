//
//  GradingInstruction.swift
//  
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation

public struct GradingInstruction: Codable, Identifiable {
    public var id: Int
    public var credits: Double?
    public var gradingScale: String?
    public var instructionDescription: String?
    public var feedback: String?
    public var usageCount: Int?

    public init(id: Int, credits: Double? = nil, gradingScale: String? = nil, instructionDescription: String? = nil, feedback: String? = nil, usageCount: Int? = nil) {
        self.id = id
        self.credits = credits
        self.gradingScale = gradingScale
        self.instructionDescription = instructionDescription
        self.feedback = feedback
        self.usageCount = usageCount
    }
}
