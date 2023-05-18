//
//  ExerciseService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 15.05.23.
//

import Foundation
import SharedModels
import Common

public protocol ExerciseService {

    /// Fetch the exercise with details including all results for the currently logged-in user
    func getExercise(exerciseId: Int) async -> DataState<Exercise>

    /// Fetch the exercise with some details that can be useful for tutors
    func getExerciseForAssessment(exerciseId: Int) async -> DataState<Exercise>

    /// Fetch the exercise statistics for dashboard
    func getExerciseStatsForDashboard(exerciseId: Int) async -> DataState<ExerciseStatistics>

    /// Fetch the exercise statistics for assessment dashboard
    func getExerciseStatsForAssessmentDashboard(exerciseId: Int) async -> DataState<ExerciseStatsForAssessmentDashboard>
}

public enum ExerciseServiceFactory {

    public static let shared: ExerciseService = ExerciseServiceImpl()
}
