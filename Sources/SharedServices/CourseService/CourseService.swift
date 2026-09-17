import Foundation
import SharedModels
import Common

public protocol CourseService {

    /// Fetch courses for dashboard
    func getCourses() async -> DataState<CoursesForDashboardDTO>

    /// Fetch the course for dashboard
    func getCourse(courseId: Int) async -> DataState<CourseForOverviewDTO>

    /// Fetch overview of exercises in course
    func getExerciseOverview(courseId: Int) async -> DataState<CourseExercisesForOverviewDTO>

    /// Fetch overview of lectures in course
    func getLectureOverview(courseId: Int) async -> DataState<[Lecture]>

    /// Fetch which tabs can be shown in course
    func getAvailableTabs(courseId: Int) async -> DataState<CourseAvailableTabsDTO>

    /// Fetch the course for assessment dashboard (with some assessment-related data)
    func getCourseForAssessment(courseId: Int) async -> DataState<Course>

    /// Fetch the course's members by searching the login or name
    func getCourseMembers(courseId: Int, searchLoginOrName: String) async -> DataState<[UserNameAndLoginDTO]>
}

public enum CourseServiceFactory: DependencyFactory {
    public static let liveValue: CourseService = CourseServiceImpl()

    public static let testValue: CourseService = CourseServiceStub()
}
