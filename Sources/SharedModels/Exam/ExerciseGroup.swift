//
//  ExerciseGroup.swift
//  
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation

public struct ExerciseGroup: Codable {
    public var id: Int
    public var title: String
    public var exercises: [Exercise]?
}
