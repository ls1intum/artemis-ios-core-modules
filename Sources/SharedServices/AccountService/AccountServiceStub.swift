//
//  AccountServiceStub.swift
//  
//
//  Created by Anian Schleyer on 03.06.24.
//

import Foundation
import Common
import SharedModels
import UserStore

struct AccountServiceStub: AccountService {
    func getAccount() async -> DataState<Account> {
        UserSessionFactory.shared.user = Account.mock
        return .done(response: Account.mock)
    }
}
