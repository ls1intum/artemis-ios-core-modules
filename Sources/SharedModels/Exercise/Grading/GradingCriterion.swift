//
//  GradingCriterion.swift
//  
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation

public struct GradingCriterion: Codable, Identifiable {
    public var id: Int
    public var title: String?
    public var structuredGradingInstructions: [GradingInstruction] = []

    public init(id: Int, title: String? = nil, structuredGradingInstructions: [GradingInstruction] = []) {
        self.id = id
        self.title = title
        self.structuredGradingInstructions = structuredGradingInstructions
    }
}
