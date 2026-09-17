//
//  File.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 16.09.26.
//

import Foundation
import UserStore

public struct CourseForOverviewDTO: Codable, Identifiable {
    public let id: Int
    public let title: String?
    public let color: String?
    public let courseIcon: String?
    public let testCourse: Bool?
    public let onlineCourse: Bool?
    public let enrollmentEnabled: Bool?
    public let unenrollmentEnabled: Bool?
    public let courseInformationSharingConfiguration: CourseInformationSharingConfiguration?
    public let courseInformationSharingMessagingCodeOfConduct: String?

    /**
     * checks if the currently logged-in user is at least tutor
     */
    public var isAtLeastTutorInCourse: Bool {
        let roles = User.roles(in: id).flatMap(\.roles)
        return roles.contains(.instructor) || roles.contains(.editor) || roles.contains(.teachingAssistant) ||
        User.hasAnyAuthorityDirect(authority: .admin) || User.hasAnyAuthorityDirect(authority: .superAdmin)
    }

    /**
     * checks if the currently logged-in user is at least instructor in the given course
     */
    public var isAtLeastInstructorInCourse: Bool {
        let roles = User.roles(in: id).flatMap(\.roles)
        return roles.contains(.instructor) || User.hasAnyAuthorityDirect(authority: .admin) || User.hasAnyAuthorityDirect(authority: .superAdmin)
    }

    /**
     * checks if the currently logged-in user is at least editor in the given course
     */
    public var isAtLeastEditorInCourse: Bool {
        let roles = User.roles(in: id).flatMap(\.roles)
        return roles.contains(.instructor) || roles.contains(.editor) ||
        User.hasAnyAuthorityDirect(authority: .admin) || User.hasAnyAuthorityDirect(authority: .superAdmin)
    }

    public static let mock = CourseForOverviewDTO(id: 1,
                                                  title: "Interactive Learning",
                                                  color: nil,
                                                  courseIcon: nil,
                                                  testCourse: nil,
                                                  onlineCourse: nil,
                                                  enrollmentEnabled: nil,
                                                  unenrollmentEnabled: nil,
                                                  courseInformationSharingConfiguration: .communicationAndMessaging,
                                                  courseInformationSharingMessagingCodeOfConduct: nil)
}

public extension CourseForOverviewDTO {
    init(course: Course) {
        self.id = course.id
        self.title = course.title ?? ""
        self.color = course.color
        self.courseIcon = course.courseIcon
        self.testCourse = nil
        self.onlineCourse = nil
        self.enrollmentEnabled = nil
        self.unenrollmentEnabled = nil
        self.courseInformationSharingConfiguration = course.courseInformationSharingConfiguration
        self.courseInformationSharingMessagingCodeOfConduct = course.courseInformationSharingMessagingCodeOfConduct
    }
}

extension CourseForOverviewDTO: Hashable {
    public static func == (lhs: CourseForOverviewDTO, rhs: CourseForOverviewDTO) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
