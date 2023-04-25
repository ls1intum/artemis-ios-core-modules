//
//  File.swift
//  
//
//  Created by Sven Andabaka on 25.04.23.
//

import Foundation

public struct CourseForDashboard: Codable {
    public var course: Course
    public var totalScores: CourseScore?
    public var textScores: CourseScore?
    public var programmingScores: CourseScore?
    public var modelingScores: CourseScore?
    public var fileUploadScores: CourseScore?
    public var quizScores: CourseScore?
    public var participationResults: [Result]?
}

extension CourseForDashboard: Identifiable {
    public var id: Int {
        course.id
    }
}
