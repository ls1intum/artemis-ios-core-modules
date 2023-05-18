//
//  File.swift
//
//
//  Created by Sven Andabaka on 10.02.23.
//

import Foundation
import Common
import SharedModels

public protocol AccountService {
    /**
     * Perform a login request to the server.
     */
    func getAccount() async -> DataState<Account>
}

public enum AccountServiceFactory {
    public static let shared: AccountService = AccountServiceImpl()
}
