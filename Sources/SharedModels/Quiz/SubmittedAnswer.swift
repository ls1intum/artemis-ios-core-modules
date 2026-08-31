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
