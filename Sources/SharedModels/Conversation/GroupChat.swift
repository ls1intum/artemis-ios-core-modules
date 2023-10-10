//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import Foundation
import SwiftUI

public struct GroupChat: BaseConversation {
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
    public var members: [ConversationUser]?

    public var conversationName: String {
        if let name, !name.isEmpty {
            return name
        }
        // fallback to the list of members if no name is set
        let membersWithoutUser = (members ?? []).filter { $0.isRequestingUser == false }
        if membersWithoutUser.isEmpty {
            return R.string.localizable.onlyYou()
        }
        if membersWithoutUser.count < 3 {
            return membersWithoutUser
                .map { $0.name ?? "" }
                .joined(separator: ", ")
        }
        return "\(membersWithoutUser.map { $0.name ?? "" }.prefix(2).joined(separator: ", ")), \(R.string.localizable.others(membersWithoutUser.count - 2))"
    }

    public var icon: Image? {
        Image(systemName: "person.3.fill")
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
        self.name = name
        self.members = members
    }
}
