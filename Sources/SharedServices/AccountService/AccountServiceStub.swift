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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        // swiftlint:disable:next force_try
        let acc = try! decoder.decode(Account.self, from: accountJSON.data(using: .utf8)!)
        UserSession.shared.user = acc
        return .done(response: acc)
    }

    // TODO: Replace with Mock
    private let accountJSON = """
        {
            "createdBy": "anonymousUser",
            "lastModifiedBy": "anonymousUser",
            "lastModifiedDate": "2023-01-11T10:10:17Z",
            "id": 18129,
            "login": "artemis",
            "name": "Anian Schleyer",
            "firstName": "Anian",
            "lastName": "Schleyer",
            "email": "anian.schleyer@tum.de",
            "visibleRegistrationNumber": "04242424",
            "activated": true,
            "langKey": "en",
            "authorities": [
                "ROLE_INSTRUCTOR",
                "ROLE_USER",
                "ROLE_TA"
            ],
            "groups": [
                "artemis-ios2324intro-instructors",
                "artemis-gbs2324-tutors",
                "artemis-FPV22-students",
                "artemis-gbs2223-students",
                "ios2324tutors",
                "artemis-pgdp2223-tutors",
                "ios23sap",
                "artemis-ios23intro-students",
                "ios23quality-students",
                "artemis-ITPP24-students",
                "artemis-numprog2324-students",
                "artemis-ios23-students",
                "artemis-EIST22-students",
                "artemis-c23-students",
                "artemis-era2122-students",
                "artemis-numprog24-students",
                "artemis-ios23tc-students",
                "artemis-gad22-students",
                "artemis-numprog23-students",
                "tumuser",
                "artemis-pgdp2122-students",
                "ios23",
                "artemis-eist22exam-students",
                "artemis-fpv22exam-students",
                "artemis-c22-students"
            ],
            "guidedTourSettings": [
                {
                    "id": 28452,
                    "guidedTourKey": "course_overview_tour",
                    "guidedTourStep": 2,
                    "guidedTourState": "STARTED"
                },
                {
                    "id": 30293,
                    "guidedTourKey": "course_exercise_overview_tour",
                    "guidedTourStep": 3,
                    "guidedTourState": "STARTED"
                }
            ],
            "internal": false
        }
        """
}
