//
//  TutorialGroupAssignedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct TutorialGroupAssignedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var groupTitle: String?
    public var groupId: Int?
    public var moderatorName: String?
}

extension TutorialGroupAssignedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleTutorialGroupAssigned()
    }
    
    public var body: String? {
        R.string.localizable.artemisAppSingleUserNotificationTextTutorialGroupAssigned(groupTitle ?? "", moderatorName ?? "")
    }
}
