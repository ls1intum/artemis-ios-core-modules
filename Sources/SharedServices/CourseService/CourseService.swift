import Foundation
import SharedModels
import Common

public protocol CourseService {

    /// Fetch courses for dashboard
    func getCourses() async -> DataState<CoursesForDashboard>

    /// Fetch the course for dashboard
    func getCourse(courseId: Int) async -> DataState<CourseForDashboard>

    /// Fetch the course for assessment dashboard (with some assessment-related data)
    func getCourseForAssessment(courseId: Int) async -> DataState<Course>

    /// Fetch the course's members by searching the login or name
    func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]>
}

public enum CourseServiceFactory {

    public static let shared: CourseService = CourseServiceImpl()
}
