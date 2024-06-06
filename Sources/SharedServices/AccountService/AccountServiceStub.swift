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

class AccountServiceStub: AccountService {
    func getAccount() async -> DataState<Account> {
        UserSession.shared.user = Account.mock
        return .done(response: Account.mock)
    }
}
