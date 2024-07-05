//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import Foundation
import SwiftUI

public struct Channel: BaseConversation {
    public var type: ConversationType
    public var id: Int64
    public var creationDate: Date?
    public var lastMessageDate: Date?
    public var creator: ConversationUser?
    public var lastReadDate: Date?
    public var unreadMessagesCount: Int?
    public var isFavorite: Bool?
    public var isHidden: Bool?
    public var isMuted: Bool?
    public var isCreator: Bool?
    public var isMember: Bool?
    public var numberOfMembers: Int?

    public var name: String?
    public var description: String?
    public var topic: String?
    public var isPublic: Bool?
    public var isAnnouncementChannel: Bool?
    public var isArchived: Bool?
    public var hasChannelModerationRights: Bool?
    public var isChannelModerator: Bool?
    public var tutorialGroupId: Int?
    public var tutorialGroupTitle: String?
    public var subType: ChannelSubType?

    public var conversationName: String {
        if isArchived ?? false {
            return "\(name ?? "") \(R.string.localizable.archived())"
        }
        return name ?? ""
    }

    public var icon: Image? {
        if isArchived ?? false {
            return Image(systemName: "archivebox.fill")
        }
        if isAnnouncementChannel ?? false {
            return Image(systemName: "megaphone.fill")
        }
        if isPublic ?? false {
            return Image(systemName: "number")
        }
        return Image(systemName: "lock.fill")
    }

    public static let mock = Channel(
        type: .channel,
        id: 1,
        creationDate: .yesterday,
        lastMessageDate: .yesterday,
        creator: .none,
        lastReadDate: .yesterday,
        unreadMessagesCount: 0,
        isFavorite: false,
        isHidden: false,
        isMuted: false,
        isCreator: false,
        isMember: true,
        numberOfMembers: 1,
        name: "Announcements",
        isPublic: true,
        isAnnouncementChannel: true,
        isArchived: false
    )
}

public extension Channel {
    init(id: Int64) {
        self.type = .channel
        self.id = id
    }
}

public enum ChannelSubType: String, RawRepresentable, Codable {
    case general
    case exercise
    case lecture
    case exam
}
