//
//  File.swift
//
//
//  Created by Sven Andabaka on 09.01.23.
//

import Foundation
import Common

public class UserSession: ObservableObject {

    // Login Data
    @Published public internal(set) var isLoggedIn = false
    @Published public internal(set) var username: String?
    @Published public internal(set) var password: String?
    @Published public internal(set) var tokenExpired = false

    // Push Notifications
    @Published internal var notificationDeviceConfigurations: [NotificationDeviceConfiguration] = []
    @Published public var notificationSetupError: UserFacingError?

    // Institution Selection
    @Published public internal(set) var institution: InstitutionIdentifier?

    internal init() {
        setupLoginData()
        setupNotificationData()
        setupInstitutionSelection()
    }

    private func setupInstitutionSelection() {
        if let institutionData = KeychainHelper.shared.read(service: .institutionKey, account: "Artemis") {
            institution = InstitutionIdentifier(value: String(decoding: institutionData, as: UTF8.self))
        } else {
            institution = .tum
            saveInstitution(identifier: .tum)
        }
    }

    private func setupNotificationData() {
        if let notificationDeviceConfigurationData = KeychainHelper.shared.read(service: .notificationConfigKey, account: "Artemis") {
            let decoder = JSONDecoder()
            do {
                notificationDeviceConfigurations = try decoder.decode([NotificationDeviceConfiguration].self, from: notificationDeviceConfigurationData)
            } catch {
                log.error("Could not decrypt notificationDeviceConfigurations")
                notificationDeviceConfigurations = []
            }
        }
    }

    private func setupLoginData() {
        if let tokenData = KeychainHelper.shared.read(service: .isLoggedInKey, account: "Artemis") {
            isLoggedIn = String(decoding: tokenData, as: UTF8.self) == "true"
        }

        if let username = KeychainHelper.shared.read(service: .usernameKey, account: "Artemis") {
            self.username = String(decoding: username, as: UTF8.self)
        }

        if let password = KeychainHelper.shared.read(service: .passwordKey, account: "Artemis") {
            self.password = String(decoding: password, as: UTF8.self)
        }
    }

    public func setTokenExpired(expired: Bool) {
        tokenExpired = expired
    }

    public func setUserLoggedIn(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
        let isLoggedInData = Data(isLoggedIn.description.utf8)
        KeychainHelper.shared.save(isLoggedInData, service: .isLoggedInKey, account: "Artemis")
    }

    public func saveUsername(username: String?) {
        self.username = username

        if let username {
            let usernameData = Data(username.description.utf8)
            KeychainHelper.shared.save(usernameData, service: .usernameKey, account: "Artemis")
        } else {
            KeychainHelper.shared.delete(service: .usernameKey, account: "Artemis")
        }
    }

    public func savePassword(password: String?) {
        self.password = password

        if let password {
            let passwordData = Data(password.description.utf8)
            KeychainHelper.shared.save(passwordData, service: .passwordKey, account: "Artemis")
        } else {
            KeychainHelper.shared.delete(service: .passwordKey, account: "Artemis")
        }
    }

    public func saveNotificationDeviceConfiguration(token: String?, encryptionKey: String?, skippedNotifications: Bool) {
        guard let institution else { return }
        let notificationDeviceConfiguration = NotificationDeviceConfiguration(institutionIdentifier: institution,
                                                                              username: username,
                                                                              skippedNotifications: skippedNotifications,
                                                                              apnsDeviceToken: token,
                                                                              notificationsEncryptionKey: encryptionKey)

        if let index = notificationDeviceConfigurations.firstIndex(where: { $0.institutionIdentifier == institution && $0.username == username }) {
            notificationDeviceConfigurations[index] = notificationDeviceConfiguration
        } else {
            notificationDeviceConfigurations.append(notificationDeviceConfiguration)
        }

        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(notificationDeviceConfigurations) {
            KeychainHelper.shared.save(encodedData, service: .notificationConfigKey, account: "Artemis")
        }
    }

    public func getCurrentNotificationDeviceConfiguration() -> NotificationDeviceConfiguration? {
        notificationDeviceConfigurations.first(where: { $0.institutionIdentifier == institution && $0.username == username })
    }

    /// Gets the currently active key for decrypting notifications.
    /// This force-loads the latest keychain data because the notification extension can outlive the app,
    /// thus the key may have changed while the UserSession is still in memory
    public func getCurrentNotificationEncryptionKey() -> Data? {
        setupLoginData()
        setupInstitutionSelection()
        setupNotificationData()
        guard let config = getCurrentNotificationDeviceConfiguration(),
              let key = config.notificationsEncryptionKey,
              let keyAsData = Data(base64Encoded: key) else {
            return nil
        }
        return keyAsData
    }

    public func saveInstitution(identifier: InstitutionIdentifier?) {
        self.institution = identifier

        if let identifier {
            let identifierData = Data(identifier.value.utf8)
            KeychainHelper.shared.save(identifierData, service: .institutionKey, account: "Artemis")
        } else {
            KeychainHelper.shared.delete(service: .institutionKey, account: "Artemis")
        }
    }

    // only used for debugging
    public func wipeKeychain() {
        KeychainHelper.shared.delete(service: .usernameKey, account: "Artemis")
        KeychainHelper.shared.delete(service: .isLoggedInKey, account: "Artemis")
        KeychainHelper.shared.delete(service: .passwordKey, account: "Artemis")
        KeychainHelper.shared.delete(service: .institutionKey, account: "Artemis")
        KeychainHelper.shared.delete(service: .notificationConfigKey, account: "Artemis")
    }
}

public struct NotificationDeviceConfiguration: Codable {
    var institutionIdentifier: InstitutionIdentifier
    var username: String?
    public var skippedNotifications: Bool
    public var apnsDeviceToken: String?
    public var notificationsEncryptionKey: String?
}

fileprivate extension String {
    static let usernameKey = "Username"
    static let passwordKey = "Password"
    static let notificationConfigKey = "NotificationConfigurations"
    static let institutionKey = "Institution"
    static let isLoggedInKey = "LoginStatus"
}
