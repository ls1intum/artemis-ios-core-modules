//
//  ProgrammingExerciseTestCase.swift
//
//
//  Created by Tarlan Ismayilsoy on 26.09.23.
//

import Foundation

public struct ProgrammingExerciseTestCase: Codable, Hashable {
    public var id: Int?
    public var testName: String?
    public var weight: Double?
    public var active: Bool?
    public var bonusPoints: Double?
    public var bonusMultiplier: Double?
}
