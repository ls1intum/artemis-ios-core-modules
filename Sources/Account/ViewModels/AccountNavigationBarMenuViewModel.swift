//
//  File.swift
//
//
//  Created by Sven Andabaka on 10.02.23.
//

import Foundation
import Common
import APIClient
import SharedModels
import UserStore
import PushNotifications

@MainActor
class AccountNavigationBarMenuViewModel: ObservableObject {
    @Published var account: DataState<Account> = .loading
    @Published var error: UserFacingError?
    @Published var isLoading = false

    init() {
        getAccount()
    }

    func getAccount() {
        if let user = UserSessionFactory.shared.user {
            account = .done(response: user)
        } else {
            account = .loading
        }
    }

    func logout() {
        isLoading = true
        Task {
            let result = await PushNotificationServiceFactory.shared.unregister()
            isLoading = false

            switch result {
            case .success:
                if let notificationDeviceConfiguration = UserSessionFactory.shared.getCurrentNotificationDeviceConfiguration() {
                    UserSessionFactory.shared.saveNotificationDeviceConfiguration(
                        token: notificationDeviceConfiguration.apnsDeviceToken,
                        encryptionKey: nil,
                        skippedNotifications: notificationDeviceConfiguration.skippedNotifications)
                }
                APIClient().perfomLogout()
            case .failure(let error):
                if let error = error as? APIClientError {
                    switch error {
                    case .httpURLResponseError(let statusCode, _):
                        if statusCode == .methodNotAllowed {
                            // ignore network error and login anyway
                            // TODO: schedule task to retry above functionality
                            APIClient().perfomLogout()
                        }
                    case .networkError:
                        // ignore network error and login anyway
                        // TODO: schedule task to retry above functionality
                        APIClient().perfomLogout()
                    default:
                        // do nothing
                        break
                    }                }
                log.error(error.localizedDescription)
                self.error = UserFacingError(title: error.localizedDescription)
            default:
                return
            }
        }
    }
}
