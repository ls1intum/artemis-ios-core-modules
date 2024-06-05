//
//  CourseServiceStub.swift
//  
//
//  Created by Anian Schleyer on 03.06.24.
//

import Foundation
import Common
import SharedModels

public class CourseServiceStub: CourseService {
    public func getCourses() async -> DataState<CoursesForDashboardDTO> {
        return .done(response: .mock)
    }

    public func getCourse(courseId: Int) async -> DataState<CourseForDashboardDTO> {
        return .done(response: .mock)
    }

    public func getCourseForAssessment(courseId: Int) async -> DataState<Course> {
        return .done(response: .mock)
    }

    public func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]> {
        .done(response: [])
    }
}
