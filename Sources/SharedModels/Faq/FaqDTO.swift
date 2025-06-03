//
//  FaqDTO.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 24.10.24.
//

import Foundation
import SwiftUI

public struct FaqDTO: Codable, Identifiable {
    public var id: Int64?
    public var questionTitle: String
    public var questionAnswer: String
    public var categories: [FaqCategory]?
    public var faqState: FaqState
    public var course: Course?

    public init() {
        questionTitle = ""
        questionAnswer = ""
        categories = []
        faqState = .unknown
    }

    enum CodingKeys: CodingKey {
        case id
        case questionTitle
        case questionAnswer
        case categories
        case faqState
        case course
    }
}

extension FaqDTO {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int64.self, forKey: .id)
        questionTitle = try container.decode(String.self, forKey: .questionTitle)
        questionAnswer = try container.decode(String.self, forKey: .questionAnswer)
        categories = try container.decodeIfPresent([String].self, forKey: .categories)?.compactMap(FaqCategory.init(jsonString:))
        faqState = try container.decode(FaqState.self, forKey: .faqState)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(questionTitle, forKey: .questionTitle)
        try container.encode(questionAnswer, forKey: .questionAnswer)
        try container.encodeIfPresent(categories?.map(\.asJsonString), forKey: .categories)
        try container.encode(faqState, forKey: .faqState)
        try container.encodeIfPresent(course, forKey: .course)
    }
}

public struct FaqCategory: Codable, Hashable {
    public let color: String
    public let category: String

    public var uiColor: UIColor {
        UIColor(hexString: color)
    }
}

extension FaqCategory {
    init?(jsonString: String) {
        if let decoded = try? JSONDecoder().decode(Self.self, from: Data(jsonString.utf8)) {
            self = decoded
        } else {
            return nil
        }
    }

    var asJsonString: String? {
        let data = try? JSONEncoder().encode(self)
        return data.map { String(decoding: $0, as: UTF8.self) }
    }
}
