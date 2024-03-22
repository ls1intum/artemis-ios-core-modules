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
        if let user = UserSession.shared.user {
            account = .done(response: user)
        } else {
            account = .loading
        }
    }

    func logout() {
        isLoading = true
        Task {
            defer {
                APIClient().perfomLogout()
            }
            let result = await PushNotificationServiceFactory.shared.unregister()
            isLoading = false

            switch result {
            case .success:
                if let notificationDeviceConfiguration = UserSession.shared.getCurrentNotificationDeviceConfiguration() {
                    UserSession.shared.saveNotificationDeviceConfiguration(
                        token: notificationDeviceConfiguration.apnsDeviceToken,
                        encryptionKey: nil,
                        skippedNotifications: notificationDeviceConfiguration.skippedNotifications)
                }
            case .failure(let error):
                if let error = error as? APIClientError {
                    switch error {
                    case .httpURLResponseError(let statusCode, _):
                        if statusCode == .methodNotAllowed {
                            // TODO: schedule task to retry above functionality
                        }
                    case .networkError:
                        // TODO: schedule task to retry above functionality
                        break
                    default:
                        // do nothing
                        break
                    }
                }
                log.error(error.localizedDescription)
                self.error = UserFacingError(title: error.localizedDescription)
            default:
                return
            }
        }
    }
}
