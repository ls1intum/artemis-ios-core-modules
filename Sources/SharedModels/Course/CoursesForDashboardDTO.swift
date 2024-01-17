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

    public init() {}
}
