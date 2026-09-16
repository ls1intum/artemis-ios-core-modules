//
//  CourseAvailableTabsDTO.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 17.09.26.
//

import Foundation

public struct CourseAvailableTabsDTO: Codable {
    public let lectures: Bool
    public let exams: Bool
    public let competencies: Bool
    public let tutorialGroups: Bool
    public let iris: Bool
    public let faq: Bool
    public let learningPaths: Bool
    public let communication: Bool
    public let training: Bool
}
