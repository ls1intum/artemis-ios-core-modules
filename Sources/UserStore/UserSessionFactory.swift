//
//  UserSessionFactory.swift
//
//
//  Created by Nityananda Zbil on 06.06.24.
//

import Common

public enum UserSessionFactory: DependencyFactory {
    public static let liveValue = UserSession()

    public static let testValue: UserSession = UserSessionStub()
}
