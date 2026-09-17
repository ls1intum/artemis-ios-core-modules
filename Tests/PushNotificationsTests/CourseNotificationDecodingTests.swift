import XCTest
@testable import PushNotifications

/// An install talks to whichever Artemis version its institution has deployed, so the values of a notification arrive
/// under one of two keys: the flat `parameters` map, which every deployed server still writes into the push body, or
/// the typed `payload` that replaces it once the server no longer has to serve app versions reading the flat one.
///
/// Both failure modes here are quiet rather than loud. Reading the key the server did not use throws and the push is
/// dropped with a log line, and a version the app rejects is dropped before it is even decoded.
final class CourseNotificationDecodingTests: XCTestCase {

    private enum Failure: Error {
        case unexpectedNotificationType
    }

    private func decode(_ body: String) throws -> CoursePushNotification {
        let notification = try JSONDecoder().decode(PushNotification.self, from: Data(body.utf8))
        return try XCTUnwrap(notification.courseNotificationDTO)
    }

    private func newPost(_ notification: CoursePushNotification,
                         file: StaticString = #filePath,
                         line: UInt = #line) throws -> NewPostNotification {
        guard case .newPost(let value) = notification else {
            XCTFail("Expected a newPostNotification, decoded \(notification)", file: file, line: line)
            throw Failure.unexpectedNotificationType
        }
        return value
    }

    // MARK: - Versions

    func testAcceptsTheVersionsItCanDecode() {
        XCTAssertTrue(PushNotificationVersion(version: 1).isValid)
        XCTAssertTrue(PushNotificationVersion(version: 2).isValid)
    }

    func testRejectsAVersionItCannotDecode() {
        // Discarding a shape this app has never seen is right. What would not be is discarding one it can read, which
        // is what an equality check did to every version raise the server might make.
        XCTAssertFalse(PushNotificationVersion(version: 3).isValid)
        XCTAssertFalse(PushNotificationVersion(version: 0).isValid)
    }

    // MARK: - Shapes

    func testReadsTheFlatParametersAnOlderServerSends() throws {
        let notification = try newPost(decode("""
        {"version": 1, "courseNotificationDTO": {
          "notificationType": "newPostNotification", "notificationId": 1, "courseId": 42,
          "category": "COMMUNICATION", "status": "UNSEEN",
          "parameters": {"postId": 90037, "channelName": "channel", "authorName": "Author",
                         "courseTitle": "Course Title", "courseIconUrl": "icon.url"}}}
        """))

        XCTAssertEqual(notification.postId, 90037)
        XCTAssertEqual(notification.channelName, "channel")
        XCTAssertEqual(notification.authorName, "Author")
        XCTAssertEqual(notification.courseId, 42)
        XCTAssertEqual(notification.courseTitle, "Course Title")
        XCTAssertEqual(notification.courseIconUrl, "icon.url")
    }

    func testReadsTheTypedPayloadWithTheSharedValuesBesideIt() throws {
        let notification = try newPost(decode("""
        {"version": 2, "courseNotificationDTO": {
          "notificationType": "newPostNotification", "notificationId": 1, "courseId": 42,
          "category": "COMMUNICATION", "status": "UNSEEN",
          "courseTitle": "Course Title", "courseIconUrl": "icon.url",
          "payload": {"postId": 90037, "channelName": "channel", "authorName": "Author"}}}
        """))

        XCTAssertEqual(notification.postId, 90037)
        XCTAssertEqual(notification.channelName, "channel")
        XCTAssertEqual(notification.courseId, 42)
        // Not type specific, so this shape carries them beside the payload. `communicationInfo` reads them off the
        // notification, so losing them here would empty the course name out of every communication push.
        XCTAssertEqual(notification.courseTitle, "Course Title")
        XCTAssertEqual(notification.courseIconUrl, "icon.url")
    }

    func testPrefersTheTypedPayloadWhenTheServerSendsBoth() throws {
        // What a 10.0 server returns over REST and websocket: the typed payload, and the flat map beside it for app
        // versions that have not migrated.
        let notification = try newPost(decode("""
        {"version": 2, "courseNotificationDTO": {
          "notificationType": "newPostNotification", "notificationId": 1, "courseId": 42,
          "category": "COMMUNICATION", "status": "UNSEEN", "courseTitle": "Course Title",
          "payload": {"postId": 90037, "channelName": "typed"},
          "parameters": {"postId": 90037, "channelName": "flat", "courseTitle": "Course Title"}}}
        """))

        XCTAssertEqual(notification.channelName, "typed")
    }

    func testFailsOneNotificationRatherThanGuessingWhenNeitherKeyIsPresent() throws {
        let body = """
        {"version": 2, "courseNotificationDTO": {
          "notificationType": "newPostNotification", "notificationId": 1, "courseId": 42,
          "category": "COMMUNICATION", "status": "UNSEEN"}}
        """

        XCTAssertThrowsError(try decode(body)) { error in
            guard case DecodingError.keyNotFound = error else {
                return XCTFail("Expected a keyNotFound naming the keys that were tried, got \(error)")
            }
        }
    }

    func testReadsANotificationTypeItDoesNotKnow() throws {
        // The server gains notification types regularly, and one it does not know should cost this app the one push
        // rather than throwing out of the decode.
        let notification = try decode("""
        {"version": 2, "courseNotificationDTO": {
          "notificationType": "somethingAddedAfterThisRelease", "notificationId": 1, "courseId": 42,
          "category": "GENERAL", "status": "UNSEEN", "payload": {}}}
        """)

        guard case .unknown = notification else {
            return XCTFail("Expected the unknown case, decoded \(notification)")
        }
    }
}
