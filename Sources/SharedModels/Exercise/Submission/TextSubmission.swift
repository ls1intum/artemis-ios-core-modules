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

        let idData = "\(submissionId);\(startIndex)-\(endIndex);\(text)".data(using: .utf8) ?? Data()
        self.id = Insecure.SHA1.hash(data: idData).map({ String(format: "%02hhx", $0) }).joined()
    }
}

public enum TextBlockType: String, Codable {
    case AUTOMATIC, MANUAL
}
