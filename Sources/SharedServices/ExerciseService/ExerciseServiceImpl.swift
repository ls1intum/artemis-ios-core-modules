//
//  ExerciseServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 15.05.23.
//

import Foundation
import Common
import APIClient
import SharedModels

public class ExerciseServiceImpl: ExerciseService {

    let client = APIClient()

    // MARK: - Get Exercise
    struct GetExerciseRequest: APIRequest {
        typealias Response = ExerciseDetailsDTO

        var exerciseId: Int

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/exercises/\(exerciseId)/details"
        }
    }

    public func getExercise(exerciseId: Int) async -> DataState<Exercise> {
        let result = await client.sendRequest(GetExerciseRequest(exerciseId: exerciseId))

        switch result {
        case .success((let response, _)):
            return .done(response: response.exercise)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Exercise For Assessment
    struct GetExerciseForAssessmentRequest: APIRequest {
        typealias Response = Exercise

        var exerciseId: Int

        var method: HTTPMethod {
            .get
        }

        var resourceName: String {
            "api/exercises/\(exerciseId)/for-assessment-dashboard"
        }
    }

    public func getExerciseForAssessment(exerciseId: Int) async -> DataState<Exercise> {
        let result = await client.sendRequest(GetExerciseForAssessmentRequest(exerciseId: exerciseId))

        switch result {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Exercise Statistics For Dashboard
    struct GetExerciseStatsForDashboardRequest: APIRequest {
        typealias Response = ExerciseStatistics

        var exerciseId: Int

        var method: HTTPMethod {
            .get
        }

        var params: [URLQueryItem] {
            [URLQueryItem(name: "exerciseId", value: String(exerciseId))]
        }

        var resourceName: String {
            "api/management/statistics/exercise-statistics"
        }
    }

    public func getExerciseStatsForDashboard(exerciseId: Int) async -> DataState<ExerciseStatistics> {
        let result = await client.sendRequest(GetExerciseStatsForDashboardRequest(exerciseId: exerciseId))

        switch result {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }

    // MARK: - Get Exercise Statistics For Assessment Dashboard
    // swiftlint:disable:next type_name
    struct GetExerciseStatsForAssessmentDashboardRequest: APIRequest {
        typealias Response = ExerciseStatsForAssessmentDashboard

        var exerciseId: Int

        var method: HTTPMethod {
            .get
        }

        var resourceName: String {
            "api/exercises/\(exerciseId)/stats-for-assessment-dashboard"
        }
    }

    public func getExerciseStatsForAssessmentDashboard(exerciseId: Int) async -> DataState<ExerciseStatsForAssessmentDashboard> {
        let result = await client.sendRequest(GetExerciseStatsForAssessmentDashboardRequest(exerciseId: exerciseId))

        switch result {
        case .success((let response, _)):
            return .done(response: response)
        case .failure(let error):
            return .failure(error: UserFacingError(error: error))
        }
    }
}
