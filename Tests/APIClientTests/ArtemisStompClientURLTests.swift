import Foundation
import XCTest
@testable import APIClient

final class ArtemisStompClientURLTests: XCTestCase {
    func testHTTPUsesWSWithTheConfiguredPort() throws {
        let baseURL = try XCTUnwrap(URL(string: "http://localhost:18088"))

        let result = ArtemisStompClient.webSocketURL(for: baseURL)

        XCTAssertEqual(result?.absoluteString, "ws://localhost:18088/websocket/websocket")
    }

    func testHTTPSUsesWSSWithTheConfiguredPort() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://artemis.example.org:8443"))

        let result = ArtemisStompClient.webSocketURL(for: baseURL)

        XCTAssertEqual(result?.absoluteString, "wss://artemis.example.org:8443/websocket/websocket")
    }

    func testDefaultHTTPSKeepsTheExistingEndpoint() throws {
        for baseString in ["https://artemis.example.org", "https://artemis.example.org/"] {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            let result = try XCTUnwrap(ArtemisStompClient.webSocketURL(for: baseURL))

            XCTAssertEqual(result.scheme, "wss")
            XCTAssertEqual(result.host(), "artemis.example.org")
            XCTAssertEqual(result.port ?? 443, 443)
            XCTAssertEqual(result.path(), "/websocket/websocket")
        }
    }

    func testPreservesTheInstanceContextPath() throws {
        for baseString in ["https://artemis.example.org/campus/artemis", "https://artemis.example.org/campus/artemis/"] {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            let result = ArtemisStompClient.webSocketURL(for: baseURL)

            XCTAssertEqual(result?.absoluteString, "wss://artemis.example.org/campus/artemis/websocket/websocket", baseString)
        }
    }

    func testPreservesPercentEncodedContextPathSegments() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://artemis.example.org/campus%2Fartemis"))

        let result = ArtemisStompClient.webSocketURL(for: baseURL)

        XCTAssertEqual(result?.absoluteString, "wss://artemis.example.org/campus%2Fartemis/websocket/websocket")
    }

    func testAcceptsMixedCaseHTTPSchemes() throws {
        let cases = [
            ("hTtP://localhost:18088", "ws://localhost:18088/websocket/websocket"),
            ("HtTpS://artemis.example.org:8443", "wss://artemis.example.org:8443/websocket/websocket")
        ]

        for (baseString, expected) in cases {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            XCTAssertEqual(ArtemisStompClient.webSocketURL(for: baseURL)?.absoluteString, expected, baseString)
        }
    }

    func testPreservesIPv6HostAndPort() throws {
        let baseURL = try XCTUnwrap(URL(string: "http://[::1]:18088/artemis"))

        let result = ArtemisStompClient.webSocketURL(for: baseURL)

        XCTAssertEqual(result?.absoluteString, "ws://[::1]:18088/artemis/websocket/websocket")
    }

    func testDoesNotForwardBaseURLCredentialsQueryOrFragment() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://name:password@artemis.example.org/campus?ignored=true#fragment"))

        let result = ArtemisStompClient.webSocketURL(for: baseURL)

        XCTAssertEqual(result?.absoluteString, "wss://artemis.example.org/campus/websocket/websocket")
    }

    func testRejectsUnsupportedSchemes() throws {
        for baseString in ["ftp://artemis.example.org", "ws://artemis.example.org", "wss://artemis.example.org", "file:///artemis"] {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            XCTAssertNil(ArtemisStompClient.webSocketURL(for: baseURL), baseString)
        }
    }

    func testRejectsRelativeURLs() throws {
        for baseString in ["/artemis", "artemis", "//artemis.example.org/artemis"] {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            XCTAssertNil(ArtemisStompClient.webSocketURL(for: baseURL), baseString)
        }
    }

    func testRejectsHTTPURLsWithoutAHost() throws {
        for baseString in ["http:/artemis", "https:/artemis"] {
            let baseURL = try XCTUnwrap(URL(string: baseString))

            XCTAssertNil(ArtemisStompClient.webSocketURL(for: baseURL), baseString)
        }
    }

    func testRejectsRelativeURLsEvenWithABaseURL() throws {
        let parentURL = try XCTUnwrap(URL(string: "https://artemis.example.org/campus/"))

        for relativePath in ["artemis", "/artemis"] {
            let baseURL = try XCTUnwrap(URL(string: relativePath, relativeTo: parentURL))

            XCTAssertNil(ArtemisStompClient.webSocketURL(for: baseURL), relativePath)
        }
    }
}
