//
//  File.swift
//  
//
//  Created by Sven Andabaka on 21.03.23.
//

import Foundation
import CryptoKit

public struct TextSubmission: BaseSubmission {
    public static var type: String {
        "text"
    }

    public var id: Int?
    public var submitted: Bool?
    public var submissionDate: Date?
    public var exampleSubmission: Bool?
    public var durationInMinutes: Double?
    public var results: [Result?]?
    public var participation: Participation?

    public var text: String?
    public var blocks: [TextBlock]?
}

public extension TextSubmission {
    private enum CodingKeys: String, CodingKey {
        case type = "submissionExerciseType"
        case id
        case submitted
        case submissionDate
        case exampleSubmission
        case durationInMinutes
        case results
        case participation
        case text
        case blocks
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        submitted = try container.decodeIfPresent(Bool.self, forKey: .submitted)
        submissionDate = try container.decodeIfPresent(Date.self, forKey: .submissionDate)
        exampleSubmission = try container.decodeIfPresent(Bool.self, forKey: .exampleSubmission)
        durationInMinutes = try container.decodeIfPresent(Double.self, forKey: .durationInMinutes)
        results = try container.decodeIfPresent([Result?].self, forKey: .results)
        participation = try container.decodeIfPresent(Participation.self, forKey: .participation)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        blocks = try container.decodeIfPresent([TextBlock].self, forKey: .blocks)
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
        try container.encode(text, forKey: .text)
        try container.encode(blocks, forKey: .blocks)
    }
}

public struct TextBlock: Codable {
    public var id: String?
    public var text: String?
    public var startIndex: Int?
    public var endIndex: Int?
    public var type: TextBlockType
    public var numberOfAffectedSubmissions: Int?

    // not decoded/encoded
    public var submissionId: Int?

    public init(submissionId: Int?, text: String? = nil, startIndex: Int? = nil, endIndex: Int? = nil) {
        self.id = nil
        self.text = text
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.submissionId = submissionId
        self.type = .MANUAL
        self.numberOfAffectedSubmissions = nil
    }

    /// Computes and sets the id of this block (identical to de.tum.in.www1.artemis.domain.TextBlock:computeId)
    public mutating func computeId() {
        let submissionId = submissionId ?? 0
        let startIndex = startIndex ?? 0
        let endIndex = endIndex ?? 0
        let text = text ?? ""

        let idData = "\(submissionId);\(startIndex)-\(endIndex);\(text)".utf8
        self.id = Insecure.SHA1.hash(data: Data(idData)).map({ String(format: "%02hhx", $0) }).joined()
    }
}

public enum TextBlockType: String, Codable {
    case AUTOMATIC, MANUAL
}
