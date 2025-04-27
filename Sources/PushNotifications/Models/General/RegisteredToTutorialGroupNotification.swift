//
//  RegisteredToTutorialGroupNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct RegisteredToTutorialGroupNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var groupTitle: String?
    public var groupId: Int?
    public var moderatorName: String?
}

extension RegisteredToTutorialGroupNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupRegistrationStudent()
    }

    public var body: String? {
        R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupRegistrationStudent(groupTitle ?? "", moderatorName ?? "user")
    }
}
