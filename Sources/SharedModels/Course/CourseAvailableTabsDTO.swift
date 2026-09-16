//
//  CourseAvailableTabsDTO.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 17.09.26.
//

import Foundation

public struct CourseAvailableTabsDTO: Codable, Hashable {
    public let lectures: Bool
    public let exams: Bool
    public let competencies: Bool
    public let tutorialGroups: Bool
    public let iris: Bool
    public let faq: Bool
    public let learningPaths: Bool
    public let communication: Bool
    public let training: Bool

    public init(lectures: Bool = true,
                exams: Bool = true,
                competencies: Bool = true,
                tutorialGroups: Bool = true,
                iris: Bool = true,
                faq: Bool = true,
                learningPaths: Bool = true,
                communication: Bool = true,
                training: Bool = true) {
        self.lectures = lectures
        self.exams = exams
        self.competencies = competencies
        self.tutorialGroups = tutorialGroups
        self.iris = iris
        self.faq = faq
        self.learningPaths = learningPaths
        self.communication = communication
        self.training = training
    }
}
