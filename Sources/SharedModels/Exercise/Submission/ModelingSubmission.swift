//
//  File.swift
//  
//
//  Created by Sven Andabaka on 21.03.23.
//

import Foundation

public struct ModelingSubmission: BaseSubmission {
    public static var type: String {
        "modeling"
    }

    public var id: Int?
    public var submitted: Bool?
    public var submissionDate: Date?
    public var exampleSubmission: Bool?
    public var durationInMinutes: Double?
    public var results: [Result?]?
    public var participation: Participation?

    public var model: String?
    public var explanationText: String?

    private enum CodingKeys: String, CodingKey {
        case type = "submissionExerciseType"
        case id
        case submitted
        case submissionDate
        case exampleSubmission
        case durationInMinutes
        case results
        case participation
        case model
        case explanationText
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        submitted = try container.decodeIfPresent(Bool.self, forKey: .submitted)
        submissionDate = try container.decodeIfPresent(Date.self, forKey: .submissionDate)
        exampleSubmission = try container.decodeIfPresent(Bool.self, forKey: .exampleSubmission)
        durationInMinutes = try container.decodeIfPresent(Double.self, forKey: .durationInMinutes)
        results = try container.decodeIfPresent([Result?].self, forKey: .results)
        participation = try container.decodeIfPresent(Participation.self, forKey: .participation)
        model = try container.decodeIfPresent(String.self, forKey: .model)
        explanationText = try container.decodeIfPresent(String.self, forKey: .explanationText)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(submitted, forKey: .submitted)
        try container.encode(submissionDate, forKey: .submissionDate)
        try container.encode(exampleSubmission, forKey: .exampleSubmission)
        try container.encode(durationInMinutes, forKey: .durationInMinutes)
        try container.encode(results, forKey: .results)
        try container.encode(participation, forKey: .participation)
        try container.encode(model, forKey: .model)
        try container.encode(explanationText, forKey: .explanationText)
    }
}
