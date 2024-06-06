import Foundation
import SharedModels
import APIClient
import Common

class CourseServiceImpl: CourseService {

    let client = APIClient()

    // MARK: - Get Courses For Dashboard
    struct GetCoursesRequest: APIRequest {
        typealias Response = CoursesForDashboardDTO

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/courses/for-dashboard"
        }
    }

    func getCourses() async -> DataState<CoursesForDashboardDTO> {
        let result = await client.sendRequest(GetCoursesRequest())

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Course
    struct GetCourseRequest: APIRequest {
        typealias Response = CourseForDashboardDTO

        var courseId: Int

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/courses/\(courseId)/for-dashboard"
        }
    }

    func getCourse(courseId: Int) async -> DataState<CourseForDashboardDTO> {
        let result = await client.sendRequest(GetCourseRequest(courseId: courseId))

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Course For Assessment
    struct GetCourseForAssessmentRequest: APIRequest {
        typealias Response = Course

        var method: HTTPMethod {
            return .get
        }

        var courseId: Int

        var resourceName: String {
            return "api/courses/\(courseId)/for-assessment-dashboard"
        }
    }

    func getCourseForAssessment(courseId: Int) async -> DataState<Course> {
        let result = await client.sendRequest(GetCourseForAssessmentRequest(courseId: courseId))

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Course Members By Searching
    struct GetCourseMembersSearchRequest: APIRequest {
        typealias Response = [UserNameAndLoginDTO]

        var courseId: Int
        var loginOrName: String

        var method: HTTPMethod {
            .get
        }

        var resourceName: String {
            "api/courses/\(courseId)/members/search?loginOrName=\(loginOrName)"
        }
    }

    func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]> {
        let result = await client.sendRequest(GetCourseMembersSearchRequest(courseId: courseId, loginOrName: searchLoginOrName))

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }
}
