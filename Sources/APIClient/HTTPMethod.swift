//
//  File.swift
//
//
//  Created by Sven Andabaka on 09.01.23.
//

import Foundation

public enum HTTPMethod: String, CustomStringConvertible {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put

    public var description: String {
        return rawValue.uppercased()
    }
}
