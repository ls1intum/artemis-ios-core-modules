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
            return Image(systemName: "bell.fill")
        }
        if isPublic ?? false {
            return Image(systemName: "number")
        }
        return Image(systemName: "lock.fill")
    }

    public init(type: ConversationType,
                id: Int64, creationDate: Date? = nil,
                lastMessageDate: Date? = nil,
                creator: ConversationUser? = nil,
                lastReadDate: Date? = nil,
                unreadMessagesCount: Int? = nil,
                isFavorite: Bool? = nil,
                isHidden: Bool? = nil,
                isCreator: Bool? = nil,
                isMember: Bool? = nil,
                numberOfMembers: Int? = nil,
                name: String? = nil,
                description: String? = nil,
                topic: String? = nil,
                isPublic: Bool? = nil,
                isAnnouncementChannel: Bool? = nil,
                isArchived: Bool? = nil,
                hasChannelModerationRights: Bool? = nil,
                isChannelModerator: Bool? = nil,
                tutorialGroupId: Int? = nil,
                tutorialGroupTitle: String? = nil,
                subType: ChannelSubType? = nil) {
        self.type = type
        self.id = id
        self.creationDate = creationDate
        self.lastMessageDate = lastMessageDate
        self.creator = creator
        self.lastReadDate = lastReadDate
        self.unreadMessagesCount = unreadMessagesCount
        self.isFavorite = isFavorite
        self.isHidden = isHidden
        self.isCreator = isCreator
        self.isMember = isMember
        self.numberOfMembers = numberOfMembers
        self.name = name
        self.description = description
        self.topic = topic
        self.isPublic = isPublic
        self.isAnnouncementChannel = isAnnouncementChannel
        self.isArchived = isArchived
        self.hasChannelModerationRights = hasChannelModerationRights
        self.isChannelModerator = isChannelModerator
        self.tutorialGroupId = tutorialGroupId
        self.tutorialGroupTitle = tutorialGroupTitle
        self.subType = subType
    }
}

public enum ChannelSubType: String, RawRepresentable, Codable {
    case general
    case exercise
    case lecture
    case exam
}
