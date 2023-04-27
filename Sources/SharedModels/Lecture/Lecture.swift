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
    //    public let attachments: [Attachment]

    public var image: Image {
        return Image("chalkboard-teacher-solid", bundle: .module)
    }
}

extension Lecture: Equatable, Hashable { }
