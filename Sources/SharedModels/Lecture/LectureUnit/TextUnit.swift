//
//  TextUnit.swift
//  
//
//  Created by Sven Andabaka on 02.05.23.
//

import Foundation
import SwiftUI

public struct TextUnit: BaseLectureUnit {
    public static var type: String {
        "text"
    }

    public var id: Int64
    public var name: String?
    public var releaseDate: Date?
    public var lecture: Lecture?

    public var visibleToStudents: Bool?
    public var completed: Bool?

    public var content: String?

    public var image: Image {
        Image("scroll-solid", bundle: .module)
    }

    public init(id: Int64,
                name: String? = nil,
                releaseDate: Date? = nil,
                lecture: Lecture? = nil,
                visibleToStudents: Bool? = nil,
                completed: Bool? = nil,
                content: String? = nil) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.lecture = lecture
        self.visibleToStudents = visibleToStudents
        self.completed = completed
        self.content = content
    }
}
