//
//  TutorialGroupUnassignedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct TutorialGroupUnassignedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var groupTitle: String?
    public var groupId: Int?
    public var moderatorName: String?
}

extension TutorialGroupUnassignedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupUnassigned()
    }

    public var body: String? {
        R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupUnassigned(groupTitle ?? "", moderatorName ?? "user")
    }
}
