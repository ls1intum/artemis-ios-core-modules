//
//  File.swift
//  
//
//  Created by Sven Andabaka on 06.04.23.
//

import Foundation

public struct Reaction: Codable {
    public var id: Int64
    public var user: ConversationUser?
    public var creationDate: Date?
    public var emojiId: String
    public var post: Message?
    public var answerPost: AnswerMessage?

    public init(id: Int64,
                user: ConversationUser? = nil,
                creationDate: Date? = nil,
                emojiId: String,
                post: Message? = nil,
                answerPost: AnswerMessage? = nil) {
        self.id = id
        self.user = user
        self.creationDate = creationDate
        self.emojiId = emojiId
        self.post = post
        self.answerPost = answerPost
    }
}

extension Reaction: Equatable, Hashable {
    public static func == (lhs: Reaction, rhs: Reaction) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
