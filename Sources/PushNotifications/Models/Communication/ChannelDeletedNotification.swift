//
//  ChannelDeletedNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct ChannelDeletedNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var deletingUser: String?
    public var channelName: String?
}

extension ChannelDeletedNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleDeleteChannel()
    }

    public var body: String? {
        guard let channelName, let deletingUser else { return nil }
        return R.string.localizable.artemisAppSingleUserNotificationTextDeleteChannel(channelName, deletingUser)
    }
}
