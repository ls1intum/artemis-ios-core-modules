//
//  RemovedFromChannelNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.04.25.
//

public struct RemovedFromChannelNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var channelModerator: String?
    public var channelName: String?
    public var channelId: Int?
}

extension RemovedFromChannelNotification: DisplayableNotification {
    public var title: String {
        R.string.localizable.artemisAppSingleUserNotificationTitleRemoveUserChannel()
    }

    public var body: String? {
        guard let channelName, let channelModerator else { return nil }
        return R.string.localizable.artemisAppSingleUserNotificationTextRemoveUserChannel(channelName, channelModerator)
    }
}
