import Foundation
import SharedModels
import APIClient
import Common

public class CourseServiceImpl: CourseService {

    let client = APIClient()

    // MARK: - Get Courses For Dashboard
    struct GetCoursesRequest: APIRequest {
        typealias Response = [CourseForDashboard]

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/courses/for-dashboard"
        }
    }

    public func getCourses() async -> DataState<[CourseForDashboard]> {
        let result = await client.sendRequest(GetCoursesRequest())

        switch result {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Course
    struct GetCourseRequest: APIRequest {
        typealias Response = CourseForDashboard

        var courseId: Int

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/courses/\(courseId)/for-dashboard"
        }
    }

    public func getCourse(courseId: Int) async -> DataState<CourseForDashboard> {
        let result = await client.sendRequest(GetCourseRequest(courseId: courseId))

        switch result {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }
}
