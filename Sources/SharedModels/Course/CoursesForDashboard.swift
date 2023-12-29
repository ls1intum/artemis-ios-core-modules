//
//  CoursesForDashboard.swift
//
//
//  Created by Nityananda Zbil on 29.12.23.
//

import Foundation

public struct CoursesForDashboard: Codable {
    public var courses: [CourseForDashboard]
    public var activeExams: [Exam]
}
