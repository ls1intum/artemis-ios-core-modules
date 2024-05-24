import XCTest
@testable import ArtemisMarkdown

final class ArtemisMarkdownTests: XCTestCase {
    func testAttachmentsRegex() throws {
        let inputString = "[attachment]uml-blue(lecture/3/LectureAttachment_2024-05-24T21-05-08-351_d37182b7.png)[/attachment]"
        let match = try XCTUnwrap(RegexReplacementVisitors.attachments.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "uml-blue")
        XCTAssertEqual(match.path, "lecture/3/LectureAttachment_2024-05-24T21-05-08-351_d37182b7.png")
    }

    func testAttachmentUnitsRegex() throws {
        let inputString = "[lecture-unit]Inheritance (part 1)(attachment-unit/7/AttachmentUnit_2024-05-24T21-12-25-915_Inheritance__part_1_.pdf)[/lecture-unit]"
        let match = try XCTUnwrap(RegexReplacementVisitors.attachmentUnits.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "Inheritance (part 1)")
        XCTAssertEqual(match.path, "attachment-unit/7/AttachmentUnit_2024-05-24T21-12-25-915_Inheritance__part_1_.pdf")
    }

    func testExercisesRegex() throws {
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

    func testMessagesRegex() throws {
        let inputString = "#13"
        let match = try XCTUnwrap(RegexReplacementVisitors.messages.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.id, "13")
    }

    func testSlidesRegex() throws {
        let inputString = "[slide]Polymorphism Slide 1(attachment-unit/10/slide/1)[/slide]"
        let match = try XCTUnwrap(RegexReplacementVisitors.slides.regex.wholeMatch(in: inputString))
        XCTAssertEqual(match.name, "Polymorphism Slide 1")
        XCTAssertEqual(match.path, "attachment-unit/10/slide/1")
    }
}
