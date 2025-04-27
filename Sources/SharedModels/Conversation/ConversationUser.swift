//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import Foundation
import UserStore

public struct ConversationUser: UserPublicInfo {
    public var id: Int64
    public var login: String?
    public var name: String?
    public var firstName: String?
    public var lastName: String?
    private var imageUrl: String?
    public var isInstructor: Bool?
    public var isEditor: Bool?
    public var isTeachingAssistant: Bool?
    public var isStudent: Bool?

    public var isChannelModerator: Bool?
    public var isRequestingUser: Bool?

    public var imagePath: URL? {
        guard let imageUrl else { return nil }
        return UserSessionFactory.shared.institution?.baseURL?
            .appending(path: "api/core/files")
            .appending(path: imageUrl)
    }
}

public extension ConversationUser {
    init(id: Int64) {
        self.id = id
    }

    init(id: Int64, name: String, imageUrl: String?) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
    }
}

// MARK: Hashable

extension ConversationUser: Hashable {}
