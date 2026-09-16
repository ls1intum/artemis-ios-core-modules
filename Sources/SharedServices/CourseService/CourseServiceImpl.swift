import Foundation
import SharedModels
import APIClient
import Common

struct CourseServiceImpl: CourseService {

    let client = APIClient()

    // MARK: - Get Courses For Dashboard
    struct GetCoursesRequest: APIRequest {
        typealias Response = CoursesForDashboardDTO

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/course/courses/for-dashboard"
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
        typealias Response = CourseForOverviewDTO

        var courseId: Int

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/course/courses/\(courseId)/for-overview"
        }
    }

    func getCourse(courseId: Int) async -> DataState<CourseForOverviewDTO> {
        let result = await client.sendRequest(GetCourseRequest(courseId: courseId))

        switch result {
        case let .success((response, _)):
            // Mirror the web client and copy it onto the course so views can read it directly.
            var response = response
            // TODO: Iris
//            response.course.irisEnabledInCourse = response.irisEnabledInCourse
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct GetExercisesRequest: APIRequest {
        typealias Response = CourseExercisesForOverviewDTO

        var courseId: Int

        var method: HTTPMethod { .get }

        var resourceName: String {
            "api/course/courses/\(courseId)/exercises-for-overview"
        }
    }

    func getExerciseOverview(courseId: Int) async -> DataState<CourseExercisesForOverviewDTO> {
        let result = await client.sendRequest(GetExercisesRequest(courseId: courseId))

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct GetLecturesRequest: APIRequest {
        typealias Response = [Lecture]

        var courseId: Int

        var method: HTTPMethod { .get }

        var resourceName: String {
            "api/lecture/courses/\(courseId)/lectures-for-overview"
        }
    }

    func getLectureOverview(courseId: Int) async -> DataState<[Lecture]> {
        let result = await client.sendRequest(GetLecturesRequest(courseId: courseId))

        switch result {
        case let .success((response, _)):
            return .done(response: response)
        case let .failure(error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct GetTabsRequest: APIRequest {
        typealias Response = CourseAvailableTabsDTO

        var courseId: Int

        var method: HTTPMethod { .get }

        var resourceName: String {
            "api/course/courses/\(courseId)/available-tabs"
        }
    }

    func getAvailableTabs(courseId: Int) async -> DataState<CourseAvailableTabsDTO> {
        let result = await client.sendRequest(GetTabsRequest(courseId: courseId))

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
            return "api/course/courses/\(courseId)/for-assessment-dashboard"
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
            "api/course/courses/\(courseId)/members/search?loginOrName=\(loginOrName)"
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
