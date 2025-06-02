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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id)
        self.questionTitle = try container.decode(String.self, forKey: .questionTitle)
        self.questionAnswer = try container.decode(String.self, forKey: .questionAnswer)
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories)?.compactMap(FaqCategory.init(jsonString:))
        self.faqState = try container.decode(FaqState.self, forKey: .faqState)
        self.course = try container.decodeIfPresent(Course.self, forKey: .course)
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
}
