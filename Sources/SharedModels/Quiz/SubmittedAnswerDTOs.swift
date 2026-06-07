//
//  SubmittedAnswerDTOs.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 01.06.26.
//

// Extensions for simpler initializers for omitting type information.
// JSON Subtypes are seemingly not properly supported by OpenAPI generator

public extension DTO.DragAndDropSubmittedAnswerFromLiveClient {
    init(_ dto: Value2Payload) {
        self.init(value1: .init(_type: "drag-and-drop"), value2: dto)
    }
}

public extension DTO.ShortAnswerSubmittedAnswerFromLiveClient {
    init(_ dto: Value2Payload) {
        self.init(value1: .init(_type: "short-answer"), value2: dto)
    }
}

public extension DTO.MultipleChoiceSubmittedAnswerFromLiveClient {
    init(_ dto: Value2Payload) {
        self.init(value1: .init(_type: "multiple-choice"), value2: dto)
    }
}

public typealias QuizTrainingAnswer = Operations.SubmitForTraining.Input.Body.JsonPayload
