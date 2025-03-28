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
