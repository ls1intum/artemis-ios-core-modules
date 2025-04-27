//
//  TutorialGroupDeletedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct TutorialGroupDeletedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var groupTitle: String?
    public var groupId: Int?
    public var moderatorName: String?
}

extension TutorialGroupDeletedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppTutorialGroupNotificationTitleTutorialGroupDeleted()
    }

    public var body: String? {
        R.string.localizable.artemisAppTutorialGroupNotificationTextTutorialGroupDeleted(groupTitle ?? "")
    }
}
