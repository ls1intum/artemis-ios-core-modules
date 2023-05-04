//
//  OnlineUnit.swift
//  
//
//  Created by Sven Andabaka on 02.05.23.
//

import Foundation
import SwiftUI

public struct OnlineUnit: BaseLectureUnit {
    public static var type: String {
        "online"
    }

    public var id: Int64
    public var name: String?
    public var releaseDate: Date?
    public var lecture: Lecture?

    public var visibleToStudents: Bool?
    public var completed: Bool?

    public var description: String?
    public var source: String?

    public var image: Image {
        Image("link-solid", bundle: .module)
    }
}
