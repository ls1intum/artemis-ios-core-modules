//
//  Questions.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 13.07.26.
//

import Foundation

public extension DTO.QuizQuestionWithoutSolution {
    func asQuestionWithSolution() -> DTO.QuizQuestionWithSolution? {
        if let dragItems, let dropLocations {
            let scoringTypeMapped: DTO.DragAndDropQuizQuestionWithSolution.ScoringTypePayload? = switch scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }
            return .dragAndDrop(.init(id: id,
                                      title: title,
                                      text: text,
                                      hint: hint,
                                      points: points,
                                      scoringType: scoringTypeMapped,
                                      randomizeOrder: randomizeOrder,
                                      invalid: invalid,
                                      _type: _type,
                                      explanation: nil,
                                      backgroundFilePath: backgroundFilePath,
                                      dropLocations: dropLocations,
                                      dragItems: dragItems,
                                      correctMappings: nil))
        }

        if let spots {
            let scoringTypeMapped: DTO.ShortAnswerQuizQuestionWithSolution.ScoringTypePayload? = switch scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }
            return .shortAnswer(.init(id: id,
                                      title: title,
                                      text: text,
                                      hint: hint,
                                      points: points,
                                      scoringType: scoringTypeMapped,
                                      randomizeOrder: randomizeOrder,
                                      invalid: invalid,
                                      _type: _type,
                                      explanation: nil,
                                      spots: spots,
                                      solutions: nil,
                                      similarityValue: similarityValue,
                                      matchLetterCase: matchLetterCase,
                                      correctMappings: nil))
        }

        if let answerOptions {
            let scoringTypeMapped: DTO.MultipleChoiceQuizQuestionWithSolution.ScoringTypePayload? = switch scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }

            let answerOptionsMapped: [DTO.AnswerOptionWithSolution] = answerOptions.map {
                DTO.AnswerOptionWithSolution(id: $0.id, text: $0.text, hint: $0.hint, invalid: $0.invalid, explanation: nil, isCorrect: nil)
            }
            return .multipleChoice(.init(id: id,
                                         title: title,
                                         text: text,
                                         hint: hint,
                                         points: points,
                                         scoringType: scoringTypeMapped,
                                         randomizeOrder: randomizeOrder,
                                         invalid: invalid,
                                         _type: _type,
                                         explanation: nil,
                                         answerOptions: answerOptionsMapped,
                                         singleChoice: singleChoice))
        }

        return nil
    }
}
