import Foundation
import SharedModels
import Common

public protocol CourseService {
    
    /**
     * Load the dashboard from the specified server using the specified authentication data.
     */
    func getCourses() async -> DataState<[CourseForDashboard]>

    func getCourse(courseId: Int) async -> DataState<CourseForDashboard>
}

public enum CourseServiceFactory {
    
    public static let shared: CourseService = CourseServiceImpl()
}
