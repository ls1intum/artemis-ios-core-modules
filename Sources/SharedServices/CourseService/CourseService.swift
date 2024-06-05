import Foundation
import SharedModels
import Common

public protocol CourseService {

    /// Fetch courses for dashboard
    func getCourses() async -> DataState<CoursesForDashboardDTO>

    /// Fetch the course for dashboard
    func getCourse(courseId: Int) async -> DataState<CourseForDashboardDTO>

    /// Fetch the course for assessment dashboard (with some assessment-related data)
    func getCourseForAssessment(courseId: Int) async -> DataState<Course>

    /// Fetch the course's members by searching the login or name
    func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]>
}

public enum CourseServiceFactory {
    @StubOrImpl(stub: CourseServiceStub(), impl: CourseServiceImpl())
    public static var shared: CourseService
}
