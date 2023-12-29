import XCTest
@testable import ArtemisMarkdown

final class ArtemisMarkdownTests: XCTestCase {
    func testExerciseRegex() throws {
        let inputString = "[file-upload]An Exercise(/courses/1/exercises/2)[/file-upload]"
        let match = try XCTUnwrap(RegexReplacementVisitors.exercises.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "An Exercise")
        XCTAssertEqual(match.path, "/courses/1/exercises/2")
    }

    func testInsRegex() throws {
        let inputString = "<ins>Hello</ins>"
        let match = try XCTUnwrap(RegexReplacementVisitors.ins.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.ins, "Hello")
    }

    func testLecturesRegex() throws {
        let inputString = "[lecture]A Lecture(/courses/1/lectures/2)[/lecture]"
        let match = try XCTUnwrap(RegexReplacementVisitors.lectures.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "A Lecture")
        XCTAssertEqual(match.path, "/courses/1/lectures/2")
    }

    func testMembersRegex() throws {
        let inputString = "[user]Full Name(login)[/user]"
        let match = try XCTUnwrap(RegexReplacementVisitors.members.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "Full Name")
        XCTAssertEqual(match.login, "login")
    }
}
