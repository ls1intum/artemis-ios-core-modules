//
//  DeregisteredFromTutorialGroupNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

// swiftlint:disable:next type_name
public struct DeregisteredFromTutorialGroupNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var groupTitle: String?
    public var groupId: Int?
    public var moderatorName: String?
}

extension DeregisteredFromTutorialGroupNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupDeregistrationStudent()
    }

    public var body: String? {
        R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupDeregistrationStudent(groupTitle ?? "", moderatorName ?? "user")
    }
}
