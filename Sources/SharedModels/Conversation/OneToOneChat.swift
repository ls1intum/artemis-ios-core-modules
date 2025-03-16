//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import DesignLibrary
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
    public var isMuted: Bool?
    public var isCreator: Bool?
    public var isMember: Bool?
    public var numberOfMembers: Int?

    public var members: [ConversationUser]?

    private var otherUser: ConversationUser? {
        (members ?? []).first(where: { $0.isRequestingUser == false })
    }

    public var conversationName: String {
        otherUser?.name ?? ""
    }

    public var icon: AnyView? {
        if let imagePath = otherUser?.imagePath {
            AnyView(
                ArtemisAsyncImage(imageURL: imagePath) {
                    Image(systemName: "lock.fill")
                        .resizable()
                }
                .frame(width: 30, height: 30)
                .clipShape(.rect(cornerRadius: .s))
            )
        } else if let name = otherUser?.name, let id = otherUser?.id {
            AnyView(
                ProfilePictureInitialsView(name: name, userId: "\(id)", size: 30)
                    .clipShape(.rect(cornerRadius: .s))
            )
        } else {
            AnyView(Image(systemName: "lock.fill").resizable())
        }
    }
}

public extension OneToOneChat {
    init(id: Int64) {
        self.type = .oneToOneChat
        self.id = id
    }
}
