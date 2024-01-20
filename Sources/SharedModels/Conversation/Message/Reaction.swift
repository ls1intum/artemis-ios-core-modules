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
}

//public extension Reaction {
//    init(id: Int64) {
//        self.id = id
//    }
//}

// MARK: Equatable & Hashable

extension Reaction: Equatable, Hashable {
    public static func == (lhs: Reaction, rhs: Reaction) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
