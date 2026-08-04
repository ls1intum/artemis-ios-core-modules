//
//  Questions.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 13.07.26.
//

import Foundation

public extension DTO.QuizQuestionWithoutSolution {
    // swiftlint:disable:next function_body_length
    func asQuestionWithSolution() -> DTO.QuizQuestionWithSolution? { // swiftlint:disable:this cyclomatic_complexity
        switch self {
        case .dragAndDrop(let dnd):
            let scoringTypeMapped: DTO.DragAndDropQuizQuestionWithSolution.ScoringTypePayload? = switch dnd.scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }
            return .dragAndDrop(.init(id: dnd.id,
                                      title: dnd.title,
                                      text: dnd.text,
                                      hint: dnd.hint,
                                      points: dnd.points,
                                      scoringType: scoringTypeMapped,
                                      randomizeOrder: dnd.randomizeOrder,
                                      invalid: dnd.invalid,
                                      _type: dnd._type,
                                      explanation: dnd.explanation,
                                      backgroundFilePath: dnd.backgroundFilePath,
                                      dropLocations: dnd.dropLocations,
                                      dragItems: dnd.dragItems,
                                      correctMappings: nil))
        case .shortAnswer(let sa):
            let scoringTypeMapped: DTO.ShortAnswerQuizQuestionWithSolution.ScoringTypePayload? = switch sa.scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }
            return .shortAnswer(.init(id: sa.id,
                                      title: sa.title,
                                      text: sa.text,
                                      hint: sa.hint,
                                      points: sa.points,
                                      scoringType: scoringTypeMapped,
                                      randomizeOrder: sa.randomizeOrder,
                                      invalid: sa.invalid,
                                      _type: sa._type,
                                      explanation: sa.explanation,
                                      spots: sa.spots,
                                      solutions: sa.solutions,
                                      similarityValue: sa.similarityValue,
                                      matchLetterCase: sa.matchLetterCase,
                                      correctMappings: nil))
        case .multipleChoice(let mc):
            let scoringTypeMapped: DTO.MultipleChoiceQuizQuestionWithSolution.ScoringTypePayload? = switch mc.scoringType {
            case .allOrNothing: .allOrNothing
            case .proportionalWithPenalty: .proportionalWithPenalty
            case .proportionalWithoutPenalty: .proportionalWithoutPenalty
            default: nil
            }

            let answerOptionsMapped: [DTO.AnswerOptionWithSolution] = (mc.answerOptions ?? []).map {
                DTO.AnswerOptionWithSolution(id: $0.id, text: $0.text, hint: $0.hint, invalid: $0.invalid, explanation: nil, isCorrect: nil)
            }
            return .multipleChoice(.init(id: mc.id,
                                         title: mc.title,
                                         text: mc.text,
                                         hint: mc.hint,
                                         points: mc.points,
                                         scoringType: scoringTypeMapped,
                                         randomizeOrder: mc.randomizeOrder,
                                         invalid: mc.invalid,
                                         _type: mc._type,
                                         explanation: mc.explanation,
                                         answerOptions: answerOptionsMapped,
                                         singleChoice: mc.singleChoice))
        }
    }
}
