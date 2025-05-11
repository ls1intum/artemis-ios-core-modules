//
//  File.swift
//
//
//  Created by Sven Andabaka on 16.02.23.
//

import Foundation
import Common

public protocol PushNotificationService {

    /**
     * Register Device to receive Push Notifications
     */
    func register(deviceToken: String) async -> NetworkResponse

    /**
     * Unregister Device to receive Push Notifications
     */
    func unregister() async -> NetworkResponse

    /**
     * Get Notification Settings Info
     */
    func getNotificationSettingsInfo() async -> DataState<NotificationSettingsInfo>

    /**
     * Get Notification Settings
     */
    func getNotificationSettings(for courseId: Int) async -> DataState<NotificationSettings>

    /**
     * Update Notification Settings for the given notification type
     */
    func updateSetting(in courseId: Int, for typeNumber: String, setting: [NotificationChannel: Bool]) async -> NetworkResponse

    /**
     * Use a notification preset from the server
     */
    func selectPreset(in courseId: Int, with preset: Int) async -> NetworkResponse
}

public enum PushNotificationServiceFactory {

    public static let shared: PushNotificationService = PushNotificationServiceImpl()
}
