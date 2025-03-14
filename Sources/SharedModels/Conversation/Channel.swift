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
    public var isCourseWide: Bool?
    public var hasChannelModerationRights: Bool?
    public var isChannelModerator: Bool?
    public var tutorialGroupId: Int?
    public var tutorialGroupTitle: String?
    public var subType: ChannelSubType?
    public var subTypeReferenceId: Int?

    public var conversationName: String {
        if isArchived ?? false {
            return "\(name ?? "") \(R.string.localizable.archived())"
        }
        return name ?? ""
    }

    public var icon: AnyView? {
        if isArchived ?? false {
            return AnyView(Image(systemName: "archivebox.fill").resizable())
        }
        if isAnnouncementChannel ?? false {
            return AnyView(Image(systemName: "megaphone.fill").resizable())
        }
        if isPublic ?? false {
            return AnyView(Image(systemName: "number").resizable())
        }
        return AnyView(Image(systemName: "lock.fill").resizable())
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
