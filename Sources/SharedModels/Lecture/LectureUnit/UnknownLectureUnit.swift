//
//  UnknownLectureUnit.swift
//  
//
//  Created by Sven Andabaka on 02.05.23.
//

import Foundation
import SwiftUI

public struct UnknownLectureUnit: BaseLectureUnit {
    public static var type: String {
        "unknown"
    }

    public var id: Int64
    public var name: String?
    public var releaseDate: Date?
    public var lecture: Lecture?

    public var visibleToStudents: Bool?
    public var completed: Bool?

    public var image: Image {
        Image(systemName: "questionmark")
    }
}
