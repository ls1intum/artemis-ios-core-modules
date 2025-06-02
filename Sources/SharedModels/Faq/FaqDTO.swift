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
    public var categories: Set<String>?
    public var faqState: FaqState
    public var course: Course?

    public var categoriesAsModel: [FaqCategory]? {
        categories?.compactMap(FaqCategory.init(jsonString:))
    }

    public init() {
        questionTitle = ""
        questionAnswer = ""
        categories = []
        faqState = .unknown
    }
}

public struct FaqCategory: Codable {
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
