//
//  URLAttachment.swift
//  
//
//  Created by Sven Andabaka on 30.04.23.
//

import Foundation

public struct URLAttachment: BaseAttachment {

    public var id: Int
    public var name: String?
    public var visibleToStudents: Bool?
//    public var link: String?
//    public var version: Int?
//    public var uploadDate: Date?
//    public var releaseDate: Date?

    public static var type: String {
        "URL"
    }
}
