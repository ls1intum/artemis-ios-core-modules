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
            return "api/public/account"
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
}
