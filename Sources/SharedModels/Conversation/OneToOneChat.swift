//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import Foundation
import SwiftUI

public struct OneToOneChat: BaseConversation {
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

    public var members: [ConversationUser]?

    public var conversationName: String {
        let otherUser = (members ?? []).first(where: { $0.isRequestingUser == false })
        return otherUser?.name ?? ""
    }

    public var icon: Image? {
        nil
    }

    public init(type: ConversationType,
                id: Int64,
                creationDate: Date? = nil,
                lastMessageDate: Date? = nil,
                creator: ConversationUser? = nil,
                lastReadDate: Date? = nil,
                unreadMessagesCount: Int? = nil,
                isFavorite: Bool? = nil,
                isHidden: Bool? = nil,
                isCreator: Bool? = nil,
                isMember: Bool? = nil,
                numberOfMembers: Int? = nil,
                members: [ConversationUser]? = nil) {
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
        self.members = members
    }
}
