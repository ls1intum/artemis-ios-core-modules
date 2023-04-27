//
//  File.swift
//
//
//  Created by Sven Andabaka on 27.02.23.
//

import Foundation

public struct Lecture: Codable {
    public let id: Int
    public let title: String?
    public let description: String?
    public let startDate: Date?
    public let endDate: Date?
    //    public let attachments: [Attachment]
}
