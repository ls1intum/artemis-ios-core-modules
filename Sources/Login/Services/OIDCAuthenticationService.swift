//
//  OIDCAuthenticationService.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 05.09.26.
//
import AuthenticationServices
import Common
import Foundation

@MainActor
class OIDCAuthenticationService: NSObject {
    // expect callback starting with "de.tum.cit.ase.artemis" from server
    private let callbackScheme = "de.tum.cit.ase.artemis"

    // start OIDC authentication flow and return exchange code and codeVerifier
    func authenticate(baseURL: URL, rememberMe: Bool) async throws -> (code: String, codeVerifier: String) {
        let codeVerifier = PKCEService.generateCodeVerifier()
        let codeChallenge = PKCEService.generateCodeChallenge(from: codeVerifier)

        var components = URLComponents(
            url: baseURL.appending(path: "oauth2/authorization/oidc"),
            resolvingAgainstBaseURL: true
        )
        components?.queryItems = [
            URLQueryItem(name: "redirect", value: "ios"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "rememberMe", value: rememberMe.description)
        ]

        guard let authURL = components?.url else {
            throw URLError(.badURL)
        }
        // Get the callback url from server when user is successfully authentication by identity provider
        let callbackURL = try await startAuthenticationSession(url: authURL)
        let code = try extractCode(from: callbackURL)

        return (code: code, codeVerifier: codeVerifier)
    }

    private func startAuthenticationSession(url: URL) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let callbackURL else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                continuation.resume(returning: callbackURL)
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false

            session.start()
        }
    }

    private func extractCode(from url: URL) throws -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.cannotParseResponse)
        }
        // if server sent error -> process it
        if let error = components.queryItems?.first(where: { $0.name == "error" })?.value {
            throw UserFacingError(title: mapErrorMessage(error))
        }
        // if server sent code -> extract it
        guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            throw URLError(.cannotParseResponse)
        }

        return code
    }

    private func mapErrorMessage(_ errorCode: String) -> String {
        switch errorCode {
        case "deactivated":
            return "Your Artemis account is deactivated. Please contact support."
        case "invalid_request":
            return "Invalid authentication request. Please try again."
        case "server_error":
            return "Server failed to generate an authorization code. Please try again later."
        default:
            return "Authentication failed (\(errorCode))."
        }
    }
}

extension OIDCAuthenticationService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scene = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
        return scene?.keyWindow ?? ASPresentationAnchor(windowScene: scene!)
    }
}
