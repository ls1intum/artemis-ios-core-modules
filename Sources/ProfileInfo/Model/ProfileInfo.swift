//
//  File.swift
//
//
//  Created by Sven Andabaka on 06.02.23.
//

import Foundation

public struct ProfileInfo: Codable {
    public let contact: String
    public let imprint: URL?
    public let build: Build
    public let features: [String]
    public let registrationEnabled: Bool
    public let needsToAcceptTerms: Bool
    public let allowedLdapUsernamePattern: String?
    public let accountName: String
    public let externalUserManagementURL: URL?
    public let externalUserManagementName: String?
    public let versionControlUrl: URL?
    public let externalCredentialProvider: String?
    public let externalPasswordResetLinkMap: [String: String]?
    public let useExternal: Bool
    public let buildPlanURLTemplate: String?
    public let activeProfiles: [String]
    public let compatibleVersions: PlatformVersionCompatibility?
    public let saml2: Saml2?
}

public struct Build: Codable {
    public let name: String
    public let version: String
}

public struct Saml2: Codable {
    public let buttonLabel: String
    public let identityProviderName: String?
    public let passwordLoginDisabled: Bool
}

public struct PlatformVersionCompatibility: Codable {
    public let android: AppVersionCompatibility
    public let ios: AppVersionCompatibility
}

public struct AppVersionCompatibility: Codable {
    public let min: String
    public let recommended: String
}
