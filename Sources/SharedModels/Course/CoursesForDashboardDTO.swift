//
//  CoursesForDashboard.swift
//
//
//  Created by Nityananda Zbil on 29.12.23.
//

import Foundation

public struct CoursesForDashboardDTO: Codable {
    public var courses: [CourseForDashboardDTO]?
    public var activeExams: [Exam]?
}

public extension CoursesForDashboardDTO {
    public static let mock = CoursesForDashboardDTO(courses: [.mock], activeExams: nil)
}
