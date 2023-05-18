import Foundation
import SharedModels
import Common

public protocol CourseService {

    /// Fetch courses for dashboard
    func getCourses() async -> DataState<[CourseForDashboard]>

    /// Fetch the course for dashboard
    func getCourse(courseId: Int) async -> DataState<CourseForDashboard>
}

public enum CourseServiceFactory {

    public static let shared: CourseService = CourseServiceImpl()
}
