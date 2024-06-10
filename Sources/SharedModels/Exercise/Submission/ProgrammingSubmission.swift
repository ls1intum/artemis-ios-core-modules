//
//  File.swift
//  
//
//  Created by Sven Andabaka on 21.03.23.
//

import Foundation

public struct ProgrammingSubmission: BaseSubmission {
    public static var type: String {
        "programming"
    }

    public var id: Int?
    public var submitted: Bool?
    public var submissionDate: Date?
    public var exampleSubmission: Bool?
    public var durationInMinutes: Double?
    public var results: [Result?]?
    public var participation: Participation?

    public var buildFailed: Bool?
}

public extension ProgrammingSubmission {
    static let mock = ProgrammingSubmission(
        id: 1,
        submitted: true,
        submissionDate: .yesterday,
        exampleSubmission: false,
        durationInMinutes: 10,
        results: [],
        participation: nil,
        buildFailed: false
    )
}
