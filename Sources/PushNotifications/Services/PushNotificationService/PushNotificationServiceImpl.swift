//
//  File.swift
//
//
//  Created by Sven Andabaka on 16.02.23.
//

import Foundation
import APIClient
import UserStore
import Common

class PushNotificationServiceImpl: PushNotificationService {

    let client = APIClient()

    struct UnregisterRequest: APIRequest {
        typealias Response = RawResponse

        var token: String
        var deviceType = "APNS"

        var method: HTTPMethod {
            return .delete
        }

        var resourceName: String {
            return "api/communication/push_notification/unregister"
        }
    }

    func unregister() async -> NetworkResponse {
        guard let notificationConfiguration = UserSessionFactory.shared.getCurrentNotificationDeviceConfiguration(),
              !notificationConfiguration.skippedNotifications else {
            return .success
        }
        guard let deviceToken = notificationConfiguration.apnsDeviceToken else { return .failure(error: APIClientError.wrongParameters)}
        let result = await client.sendRequest(UnregisterRequest(token: deviceToken))

        switch result {
        case .success:
            return .success
        case .failure(let error):
            switch error {
            case .httpURLResponseError(statusCode: .notFound, _):
                return .success
            default:
                return .failure(error: error)
            }
        }
    }

    struct RegisterResponse: Codable {
        let secretKey: String
        let algorithm: String
    }

    struct RegisterRequest: APIRequest {
        typealias Response = RegisterResponse

        var token: String
        var deviceType = "APNS"
        var apiType = 1
        var versionCode = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        var method: HTTPMethod {
            return .post
        }

        var resourceName: String {
            return "api/communication/push_notification/register"
        }
    }

    func register(deviceToken: String) async -> NetworkResponse {
        let result = await client.sendRequest(RegisterRequest(token: deviceToken))

        switch result {
        case .success(let response):
            UserSessionFactory.shared.saveNotificationDeviceConfiguration(token: deviceToken, encryptionKey: response.0.secretKey, skippedNotifications: false)
            return .success
        case .failure(let error):
            UserSessionFactory.shared.notificationSetupError = UserFacingError(error: error)
            return .failure(error: error)
        }
    }

    struct GetNotificationSettingsInfoRequest: APIRequest {
        typealias Response = NotificationSettingsInfo

        var method: HTTPMethod { .get }

        var resourceName: String {
            return "api/communication/notification/info"
        }
    }

    func getNotificationSettingsInfo() async -> DataState<NotificationSettingsInfo> {
        let result = await client.sendRequest(GetNotificationSettingsInfoRequest())

        switch result {
        case .success(let (response, _)):
            return .done(response: response)
        case .failure(let error):
            log.error(error, "Could not load Notification Settings Info")
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct GetNotificationSettingsRequest: APIRequest {
        typealias Response = NotificationSettings

        var method: HTTPMethod { .get }

        let courseId: Int

        var resourceName: String {
            return "api/communication/notification/\(courseId)/settings"
        }
    }

    func getNotificationSettings(for courseId: Int) async -> DataState<NotificationSettings> {
        let result = await client.sendRequest(GetNotificationSettingsRequest(courseId: courseId))

        switch result {
        case .success(let (response, _)):
            return .done(response: response)
        case .failure(let error):
            log.error(error, "Could not load Notification Settings")
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct UpdateNotificationSettingRequest: APIRequest {
        typealias Response = RawResponse

        var method: HTTPMethod { .put }

        let courseId: Int
        let notificationTypeChannels: [String: [NotificationChannel: Bool]]

        var resourceName: String {
            return "api/communication/notification/\(courseId)/setting-specification"
        }
    }

    func updateSetting(in courseId: Int, for typeNumber: String, setting: [NotificationChannel: Bool]) async -> NetworkResponse {
        let result = await client.sendRequest(UpdateNotificationSettingRequest(courseId: courseId, notificationTypeChannels: [typeNumber: setting]))

        switch result {
        case .success(let (response, _)):
            return .success
        case .failure(let error):
            log.error(error, "Could not update Notification Setting")
            return .failure(error: UserFacingError(error: error))
        }
    }

    struct SelectNotificationSettingPresetRequest: APIRequest {
        typealias Response = RawResponse

        var method: HTTPMethod { .put }

        let courseId: Int
        let preset: Int

        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(preset)
        }

        var resourceName: String {
            return "api/communication/notification/\(courseId)/setting-preset"
        }
    }

    func selectPreset(in courseId: Int, with preset: Int) async -> NetworkResponse {
        let result = await client.sendRequest(SelectNotificationSettingPresetRequest(courseId: courseId, preset: preset))

        switch result {
        case .success(let (response, _)):
            return .success
        case .failure(let error):
            log.error(error, "Could not update Notification Preset")
            return .failure(error: UserFacingError(error: error))
        }
    }
}
