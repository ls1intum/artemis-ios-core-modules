//
//  File.swift
//
//
//  Created by Sven Andabaka on 10.02.23.
//

import Foundation
import APIClient
import Common
import SharedModels
import UserStore

struct AccountServiceImpl: AccountService {
    private let client = APIClient()

    struct GetAccountRequest: APIRequest {
        typealias Response = Account

        var method: HTTPMethod {
            return .get
        }

        var resourceName: String {
            return "api/core/public/account"
        }
    }

    func getAccount() async -> DataState<Account> {
        let result = await client.sendRequest(GetAccountRequest())

        switch result {
        case .success((let account, _)):
            UserSessionFactory.shared.user = account
            return .done(response: account)
        case .failure(let error):
            return DataState(error: error)
        }
    }

    struct SelectLLMUsageRequest: APIRequest {
        typealias Response = RawResponse

        let selection: AiSelectionDecision

        var method: HTTPMethod {
            return .put
        }

        var resourceName: String {
            return "api/account/users/select-llm-usage"
        }
    }

    func updateLLMSelection(_ selection: AiSelectionDecision) async -> NetworkResponse {
        let result = await client.sendRequest(SelectLLMUsageRequest(selection: selection))

        switch result {
        case .success:
            // Refresh the cached account so the new choice is reflected app-wide (e.g. the Iris gate).
            _ = await getAccount()
            return .success
        case .failure(let error):
            return .failure(error: error)
        }
    }
}
