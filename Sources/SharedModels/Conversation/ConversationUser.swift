//
//  File.swift
//  
//
//  Created by Sven Andabaka on 05.04.23.
//

import Foundation

public struct ConversationUser: UserPublicInfo {
    public var id: Int64
    public var login: String?
    public var name: String?
    public var firstName: String?
    public var lastName: String?
    public var isInstructor: Bool?
    public var isEditor: Bool?
    public var isTeachingAssistant: Bool?
    public var isStudent: Bool?

    public var isChannelModerator: Bool?
    public var isRequestingUser: Bool?

    public init(id: Int64,
                login: String? = nil,
                name: String? = nil,
                firstName: String? = nil,
                lastName: String? = nil,
                isInstructor: Bool? = nil,
                isEditor: Bool? = nil,
                isTeachingAssistant: Bool? = nil,
                isStudent: Bool? = nil,
                isChannelModerator: Bool? = nil,
                isRequestingUser: Bool? = nil) {
        self.id = id
        self.login = login
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.isInstructor = isInstructor
        self.isEditor = isEditor
        self.isTeachingAssistant = isTeachingAssistant
        self.isStudent = isStudent
        self.isChannelModerator = isChannelModerator
        self.isRequestingUser = isRequestingUser
    }
}

extension ConversationUser: Hashable { }
