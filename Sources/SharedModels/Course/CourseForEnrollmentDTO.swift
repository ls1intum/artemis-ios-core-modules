//
//  File.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.09.26.
//

import Foundation

public struct CourseForEnrollmentDTO: Codable, Identifiable {
    public let id: Int
    public let title: String?
    public let description: String
    public let semester: String?
    public let enrollmentConfirmationMessage: String?
    public let prerequisites: [CoursePrerequisiteDTO]?
}

public struct CoursePrerequisiteDTO: Codable {
    let id: Int
    let title: String?
    let description: String?
    let softDueDate: Date?
    let masteryThreshold: Int // swiftlint:disable:this inclusive_language // Lol
    let optional: Bool
    let type: String?
}
