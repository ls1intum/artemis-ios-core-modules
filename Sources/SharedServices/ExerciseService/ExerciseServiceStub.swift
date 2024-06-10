//
//  ExerciseServiceStub.swift
//  
//
//  Created by Anian Schleyer on 09.06.24.
//

import Common
import SharedModels

struct ExerciseServiceStub: ExerciseService {
    func getExercise(exerciseId: Int) async -> DataState<Exercise> {
        return .done(response: .programming(exercise: .mockPastDeadline))
    }

    func getExerciseStatsForDashboard(exerciseId: Int) async -> DataState<ExerciseStatistics> {
        return .done(response: .mock)
    }

    func getExerciseStatsForAssessmentDashboard(exerciseId: Int) async -> DataState<ExerciseStatsForAssessmentDashboard> {
        return .done(response: .mock)
    }

    func getExerciseForAssessment(exerciseId: Int) async -> DataState<Exercise> {
        return .done(response: .programming(exercise: .mockPastDeadline))
    }
}
