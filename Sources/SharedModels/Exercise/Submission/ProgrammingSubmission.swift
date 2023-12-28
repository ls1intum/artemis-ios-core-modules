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

    public init(id: Int? = nil,
                submitted: Bool? = nil,
                submissionDate: Date? = nil,
                exampleSubmission: Bool? = nil,
                durationInMinutes: Double? = nil,
                results: [Result]? = nil,
                participation: Participation? = nil,
                buildFailed: Bool? = nil) {
        self.id = id
        self.submitted = submitted
        self.submissionDate = submissionDate
        self.exampleSubmission = exampleSubmission
        self.durationInMinutes = durationInMinutes
        self.results = results
        self.participation = participation
        self.buildFailed = buildFailed
    }
}
