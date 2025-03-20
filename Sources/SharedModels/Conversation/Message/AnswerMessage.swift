//
//  File.swift
//  
//
//  Created by Sven Andabaka on 06.04.23.
//

import Foundation

public struct AnswerMessage: BaseMessage {
    public var id: Int64
    public var author: ConversationUser?
    public var creationDate: Date?
    public var updatedDate: Date?
    public var content: String?
    public var tokenizedContent: String?
    public var authorRole: UserRole?

    public var resolvesPost: Bool?
    public var reactions: [Reaction]?
    public var post: Message?
    public var isSaved: Bool?
}

public extension AnswerMessage {
    init(id: Int64) {
        self.id = id
    }
}

// MARK: Equatable & Hashable

extension AnswerMessage: Equatable, Hashable {
    public static func == (lhs: AnswerMessage, rhs: AnswerMessage) -> Bool {
        lhs.id == rhs.id &&
        lhs.reactions?.count ?? 0 == rhs.reactions?.count ?? 0 &&
        lhs.content == rhs.content
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
