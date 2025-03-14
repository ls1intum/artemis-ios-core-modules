import Foundation
import Common
import UserStore
import DesignLibrary
import SwiftUI

/**
 * Representation of a single course.
 */
public struct Course: Codable, Identifiable {
    public var id: Int
    public var title: String? = ""
    public var description: String? = ""
    public var shortName: String? = ""
    public var courseIcon: String?
    public var color: String?
    public var semester: String? = ""
    public var registrationConfirmationMessage: String? = ""
    public var exercises: [Exercise]?
    public var exams: [Exam]?
    public var lectures: [Lecture]?
    public var accuracyOfScores: Int?
    public var courseInformationSharingConfiguration: CourseInformationSharingConfiguration
    public var courseInformationSharingMessagingCodeOfConduct: String? = ""
    public var instructorGroupName: String?
    public var editorGroupName: String?
    public var teachingAssistantGroupName: String?
    public var faqEnabled: Bool?

    // helper attributes, if DTO does not contain complete data
    public var numberOfLectures: Int?

    public var courseIconURL: URL? {
        guard let courseIcon else { return nil }
        return URL(string: courseIcon, relativeTo: UserSessionFactory.shared.institution?.baseURL)
    }

    public var courseColor: Color {
        guard let color else {
            return Color.Artemis.artemisBlue
        }
        return UIColor(hexString: color).suColor
    }

    /// Returns all exercises which have no due date or a due date in the future
    public var upcomingExercises: [Exercise] {
        return (exercises ?? [])
            .filter { exercise in
                guard let dueDate = exercise.baseExercise.dueDate else {
                    return true
                }
                return dueDate > Date.now
            }
            .sorted(by: { exerciseA, exerciseB in
                if let dueDateA = exerciseA.baseExercise.dueDate,
                   let dueDateB = exerciseB.baseExercise.dueDate {
                    return dueDateA < dueDateB
                } else if exerciseA.baseExercise.dueDate == nil {
                    return false
                } else {
                    return true
                }
            })
    }

    /**
     * checks if the currently logged-in user is at least tutor
     */
    public var isAtLeastTutorInCourse: Bool {
        User.hasGroup(group: instructorGroupName) ||
        User.hasGroup(group: editorGroupName) ||
        User.hasGroup(group: teachingAssistantGroupName) ||
        User.hasAnyAuthorityDirect(authority: .admin)
    }

    /**
     * checks if the currently logged-in user is at least instructor in the given course
     */
    public var isAtLeastInstructorInCourse: Bool {
        User.hasGroup(group: instructorGroupName) ||
        User.hasAnyAuthorityDirect(authority: .admin)
    }

    /**
     * checks if the currently logged-in user is at least editor in the given course
     */
    public var isAtLeastEditorInCourse: Bool {
        User.hasGroup(group: instructorGroupName) ||
        User.hasGroup(group: editorGroupName) ||
        User.hasAnyAuthorityDirect(authority: .admin)
    }

    /**
     * Rounds the given value to the accuracy defined by the course.
     * @param value The value that should be rounded.
     * @returns The rounded value.
     */
    public static func roundValueSpecifiedByCourseSettings(value: Double, for course: Course?) -> Double {
        let accuracy = Double(course?.accuracyOfScores ?? 1)
        return round(value * pow(10.0, accuracy)) / pow(10.0, accuracy)
    }
}

public extension Course {
    init(id: Int,
         title: String? = "",
         description: String? = "",
         courseIcon: String? = nil,
         semester: String? = "",
         registrationConfirmationMessage: String? = "",
         exercises: [Exercise]? = nil,
         courseInformationSharingConfiguration: CourseInformationSharingConfiguration) {
        self.id = id
        self.title = title
        self.description = description
        self.courseIcon = courseIcon
        self.semester = semester
        self.registrationConfirmationMessage = registrationConfirmationMessage
        self.exercises = exercises
        self.courseInformationSharingConfiguration = courseInformationSharingConfiguration
    }

    static let mock = Course(
        id: 1,
        title: "Interactive Learning",
        exercises: [
            .programming(exercise: .mock),
            .programming(exercise: .mockPastDeadline),
            .text(exercise: .mock)
        ],
        courseInformationSharingConfiguration: .communicationAndMessaging,
        instructorGroupName: "tumuser"
    )
}

extension Course: Hashable {
    public static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum CourseInformationSharingConfiguration: String, ConstantsEnum {
    /**
     * Both Communication and Messaging are disabled VALUE = 0
     */
    case disabled = "DISABLED"

    /**
     * Both Communication and Messaging are enabled VALUE = 1
     */
    case communicationAndMessaging = "COMMUNICATION_AND_MESSAGING"
    /**
     * Only Communication is enabled VALUE = 2
     */
    case communicationOnly = "COMMUNICATION_ONLY"
    case unknown
}
