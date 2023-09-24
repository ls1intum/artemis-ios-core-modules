//
//  File.swift
//
//
//  Created by Sven Andabaka on 27.02.23.
//

import Foundation
import SwiftUI

public struct Lecture: Codable, Identifiable {
    public let id: Int
    public let title: String?
    public let description: String?
    public let startDate: Date?
    public let endDate: Date?
    public let attachments: [Attachment]?
    public let lectureUnits: [LectureUnit]?

    public var image: Image {
        return Image("chalkboard-teacher-solid", bundle: .module)
    }

    public init(id: Int, 
                title: String?,
                description: String?,
                startDate: Date?,
                endDate: Date?,
                attachments: [Attachment]?,
                lectureUnits: [LectureUnit]?) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.attachments = attachments
        self.lectureUnits = lectureUnits
    }
}

extension Lecture: Equatable, Hashable {
    public static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
