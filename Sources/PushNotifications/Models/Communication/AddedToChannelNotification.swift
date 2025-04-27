//
//  AddedToChannelNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct AddedToChannelNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var channelModerator: String?
    public var channelName: String?
    public var channelId: Int?
}
