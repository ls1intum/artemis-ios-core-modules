//
//  CourseServiceStub.swift
//  
//
//  Created by Anian Schleyer on 03.06.24.
//

import Foundation
import Common
import SharedModels

struct CourseServiceStub: CourseService {
    func getCourses() async -> DataState<CoursesForDashboardDTO> {
        return .done(response: .mock)
    }

    func getCourse(courseId: Int) async -> DataState<CourseForOverviewDTO> {
        return .done(response: .mock)
    }

    func getExerciseOverview(courseId: Int) async -> DataState<CourseExercisesForOverviewDTO> {
        return .loading
    }

    func getLectureOverview(courseId: Int) async -> DataState<[Lecture]> {
        return .loading
    }

    func getAvailableTabs(courseId: Int) async -> DataState<CourseAvailableTabsDTO> {
        return .loading
    }

    func getCourseForAssessment(courseId: Int) async -> DataState<Course> {
        return .done(response: .mock)
    }

    func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]> {
        .done(response: [])
    }
}
