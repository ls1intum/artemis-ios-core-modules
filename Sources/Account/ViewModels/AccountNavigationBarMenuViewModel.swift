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
import SharedServices

@MainActor
class AccountNavigationBarMenuViewModel: ObservableObject {
    @Published var account: DataState<Account> = .loading
    @Published var profilePicUrl: URL?
    @Published var error: UserFacingError?
    @Published var isLoading = false

    init() {
        getAccount()
    }

    func getAccount() {
        if let user = UserSessionFactory.shared.user {
            account = .done(response: user)
            profilePicUrl = account.value?.imagePath
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
                APIClient().performLogout()
            case .failure(let error):
                if let error = error as? APIClientError {
                    switch error {
                    case .httpURLResponseError(let statusCode, _):
                        if statusCode == .methodNotAllowed {
                            // ignore network error and login anyway
                            // TODO: schedule task to retry above functionality
                            APIClient().performLogout()
                        }
                    case .networkError:
                        // ignore network error and login anyway
                        // TODO: schedule task to retry above functionality
                        APIClient().performLogout()
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

    /// Updates the saved user with current profile pic url
    func updateProfilePicUrl() async {
        guard let account = account.value else { return }

        let result = await AccountServiceFactory.shared.getAccount()
        switch result {
        case .done(let account):
            UserSessionFactory.shared.user = account
            self.account = .done(response: account)
            profilePicUrl = account.imagePath
        default:
            profilePicUrl = nil
        }
    }
}
