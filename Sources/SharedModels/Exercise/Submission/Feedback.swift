//
//  Feedback.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//
// swiftlint:disable identifier_name

import Foundation

public struct Feedback: Codable, Identifiable, Hashable {
    public var id: Int?
    public var text: String? /// max length = 500
    public var detailText: String? /// max length = 5000
    public var reference: String?
    public var credits: Double? /// score of element
    public var type: FeedbackType?
    public var positive: Bool?
    public var testCase: ProgrammingExerciseTestCase?
    public var gradingInstruction: GradingInstruction?

    public init(id: Int? = nil,
                text: String? = nil,
                detailText: String? = nil,
                reference: String? = nil,
                credits: Double? = nil,
                type: FeedbackType? = nil,
                positive: Bool? = nil,
                testCase: ProgrammingExerciseTestCase? = nil,
                gradingInstruction: GradingInstruction? = nil) {
        self.id = id
        self.text = text
        self.detailText = detailText
        self.reference = reference
        self.credits = credits
        self.type = type
        self.positive = positive
        self.testCase = testCase
        self.gradingInstruction = gradingInstruction
    }
}

// Based on: https://github.com/ls1intum/Artemis/blob/develop/src/main/java/de/tum/in/www1/artemis/domain/enumeration/FeedbackType.java
public enum FeedbackType: String, ConstantsEnum {
    case automatic = "AUTOMATIC"
    case automaticAdapted = "AUTOMATIC_ADAPTED"
    case manual = "MANUAL"
    case manualUnreferenced = "MANUAL_UNREFERENCED"
    case unknown

    public var isManual: Bool {
        self == .manual || self == .manualUnreferenced
    }

    public var isAutomatic: Bool {
        self == .automatic || self == .automatic
    }
}
