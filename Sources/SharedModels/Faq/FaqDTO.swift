//
//  FaqDTO.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 24.10.24.
//

import Foundation

public struct FaqDTO: Codable, Identifiable {
    public var id: Int64
    public var questionTitle: String
    public var questionAnswer: String
    public var categories: Set<String>?
    public var state: FaqState?
}
