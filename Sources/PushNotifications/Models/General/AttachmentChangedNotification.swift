//
//  AttachmentChangedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 28.03.25.
//

public struct AttachmentChangedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var attachmentName: String?
    public var exerciseOrLectureName: String?
    public var exerciseId: Int?
    public var lectureId: Int?
}

extension AttachmentChangedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppGroupNotificationTitleAttachmentChange()
    }

    public var subtitle: String? {
        exerciseOrLectureName
    }

    public var body: String? {
        R.string.localizable.attatchmentChangedBody(attachmentName ?? "attachment")
    }
}
