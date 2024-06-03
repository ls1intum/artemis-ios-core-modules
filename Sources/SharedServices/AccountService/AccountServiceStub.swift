//
//  File.swift
//  
//
//  Created by Anian Schleyer on 03.06.24.
//

import Foundation
import Common
import SharedModels
import UserStore

public class AccountServiceStub: AccountService {
    public func getAccount() async -> DataState<Account> {
        UserSession.shared.user = Account.mock
        return .done(response: Account.mock)
    }
}
