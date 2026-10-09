//
//  File.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 13.07.26.
//

// Helpers for mapping between quiz answer types
public extension DTO.SubmittedAnswerFromLiveClient {
    func asAnswerFromStudent() -> DTO.SubmittedAnswerFromStudent? {
        switch self {
        case .dragAndDrop(let dnd):
            guard let questionId = dnd.quizQuestion?.id else {
                return nil
            }
            let mappings = (dnd.mappings ?? []).compactMap {
                if let dragId = $0.dragItem?.id, let dropId = $0.dropLocation?.id {
                    return DTO.DragAndDropMappingReEvaluate(dragItemId: dragId,
                                                            dropLocationId: dropId)
                }
                return nil
            }
            return .dragAndDrop(.init(questionId: questionId,
                                      mappings: mappings,
                                      _type: .dragAndDrop))

        case .multipleChoice(let mc):
            guard let questionId = mc.quizQuestion?.id else {
                return nil
            }
            let selected = (mc.selectedOptions ?? []).compactMap(\.id)
            return .multipleChoice(.init(questionId: questionId,
                                         selectedOptions: selected,
                                         _type: .multipleChoice))

        case .shortAnswer(let sa):
            guard let questionId = sa.quizQuestion?.id else {
                return nil
            }
            let submitted = (sa.submittedTexts ?? []).compactMap {
                if let text = $0.text, !text.isEmpty, let spotId = $0.spot?.id {
                    return DTO.ShortAnswerSubmittedTextFromStudent(text: text, spotId: spotId)
                }
                return nil
            }
            return .shortAnswer(.init(questionId: questionId,
                                      submittedTexts: submitted,
                                      _type: .shortAnswer))
        }
    }
}

public extension DTO.SubmittedAnswerBeforeEvaluation {
    func asAnswerFromLiveClient() -> DTO.SubmittedAnswerFromLiveClient {
        switch self {
        case .dragAndDrop(let dnd):
            let mappings = (dnd.mappings ?? []).compactMap {
                if let dragId = $0.dragItem?.id, let dropId = $0.dropLocation?.id {
                    return DTO.DragAndDropMappingFromLiveClient(dragItem: .init(id: dragId),
                                                                dropLocation: .init(id: dropId))
                }
                return nil
            }
            return .dragAndDrop(.init(quizQuestion: .init(id: dnd.quizQuestion?.id),
                                      mappings: mappings,
                                      _type: .dragAndDrop))
        case .multipleChoice(let mc):
            let selected = (mc.selectedOptions ?? []).compactMap(\.id).map(DTO.EntityIdRef.init(id:))
            return .multipleChoice(.init(quizQuestion: .init(id: mc.quizQuestion?.id),
                                         selectedOptions: selected,
                                         _type: .multipleChoice))
        case .shortAnswer(let sa):
            let submitted = (sa.submittedTexts ?? []).compactMap {
                if let text = $0.text, !text.isEmpty, let spotId = $0.spot?.id {
                    return DTO.ShortAnswerSubmittedTextFromLiveClient(text: text, spot: .init(id: spotId))
                }
                return nil
            }
            return .shortAnswer(.init(quizQuestion: .init(id: sa.quizQuestion?.id),
                                      submittedTexts: submitted,
                                      _type: .shortAnswer))
        }
    }
}

public extension DTO.SubmittedAnswerAfterEvaluation {
    var score: Double? {
        switch self {
        case .dragAndDrop(let answer): answer.scoreInPoints
        case .multipleChoice(let answer): answer.scoreInPoints
        case .shortAnswer(let answer): answer.scoreInPoints
        }
    }

    var question: DTO.QuizQuestionWithSolution? {
        switch self {
        case .dragAndDrop(let answer): answer.quizQuestion
        case .multipleChoice(let answer): answer.quizQuestion
        case .shortAnswer(let answer): answer.quizQuestion
        }
    }
}
