//
//  StudentParticipation.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 04.08.26.
//

public extension DTO.StudentQuizParticipation {
    var quizBatches: [DTO.QuizBatch] {
        switch self {
        case .afterQuizEnd(let withSolutions): withSolutions.exercise?.quizBatches ?? []
        case .beforeQuizStart(let withoutQuestions): withoutQuestions.exercise?.quizBatches ?? []
        case .liveQuiz(let withQuestions): withQuestions.exercise?.quizBatches ?? []
        }
    }
}
