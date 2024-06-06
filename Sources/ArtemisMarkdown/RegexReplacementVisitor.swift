//
//  RegexReplacementVisitor.swift
//
//
//  Created by Nityananda Zbil on 19.10.23.
//

import Foundation
import UserStore

struct RegexReplacementVisitor<Output> {
    let regex: Regex<Output>
    let replacement: (Regex<Output>.Match) -> String

    func visit(input: inout String) {
        input.replace(regex, with: replacement)
    }
}

enum RegexReplacementVisitors {

    // (?<ATTACHMENT>\[attachment].*?\[\/attachment])
    static let attachments = RegexReplacementVisitor(
        regex: #/\[attachment\](?<name>.*?)\((?<path>lecture/\d+/.*?)\)\[/attachment\]/#
    ) { match in
        "![Attachment](fa-file) [\(match.name)](mention://attachment/\(match.path))"
    }

    // (?<ATTACHMENT_UNITS>\[lecture-unit].*?\[\/lecture-unit])
    static let attachmentUnits = RegexReplacementVisitor(
        regex: #/\[lecture-unit\](?<name>.*?)\((?<path>attachment-unit/\d+/.*?)\)\[/lecture-unit\]/#
    ) { match in
        "![Lecture unit](fa-file) [\(match.name)](mention://lecture-unit/\(match.path))"
    }

    // (?<CHANNEL>\[channel].*?\[\/channel])
    static let channels = RegexReplacementVisitor(
        regex: #/\[channel\](?<name>.*?)\((?<id>.*?)\)\[/channel\]/#
    ) { match in
        "[#\(match.name)](mention://channel/\(match.id))"
    }

    // (?<PROGRAMMING>\[programming].*?\[\/programming])|
    // (?<MODELING>\[modeling].*?\[\/modeling])|
    // (?<QUIZ>\[quiz].*?\[\/quiz])|
    // (?<TEXT>\[text].*?\[\/text])|
    // (?<FILE_UPLOAD>\[file-upload].*?\[\/file-upload])
    static let exercises = RegexReplacementVisitor(
        regex: #/\[(?<start>[\w-]*?)\](?<name>.*?)\((?<path>/courses/\d+/exercises/\d+)\)\[/(?<stop>[\w-]*?)\]/#
    ) { match in
        guard match.start == match.stop,
              let exercise = Exercise.allCases.first(where: { $0.rawValue == match.start }),
              let baseURL = UserSession.shared.institution?.baseURL,
              let url = URL(string: String(match.path), relativeTo: baseURL) else {
            return String(match.0)
        }
        return "![\(exercise.title)](\(exercise.icon)) [\(match.name)](mention://exercise/\(url.lastPathComponent))"
    }

    static let ins = RegexReplacementVisitor(regex: #/<ins>(?<ins>.*?)</ins>/#) { match in
        String(match.ins)
    }

    // (?<LECTURE>\[lecture].*?\[\/lecture])
    static let lectures = RegexReplacementVisitor(
        regex: #/\[lecture\](?<name>.*?)\((?<path>/courses/\d+/lectures/\d+)\)\[/lecture\]/#
    ) { match in
        guard let baseURL = UserSession.shared.institution?.baseURL,
              let url = URL(string: String(match.path), relativeTo: baseURL) else {
            return String(match.0)
        }
        return "![Lecture](fa-chalkboard-user) [\(match.name)](mention://lecture/\(url.lastPathComponent))"
    }

    // (?<USER>\[user].*?\[\/user])
    static let members = RegexReplacementVisitor(regex: #/\[user\](?<name>.*?)\((?<login>.*?)\)\[/user\]/#) { match in
        "[@\(match.name)](mention://member/\(match.login))"
    }

    // (?<POST>#\d+)
    static let messages = RegexReplacementVisitor(regex: #/\#(?<id>\d+)/#) { match in
        return "![Message](fa-message) [#\(match.id)](mention://message/\(match.id))"
    }

    // (?<SLIDE>\[slide].*?\[\/slide])
    static let slides = RegexReplacementVisitor(
        regex: #/\[slide\](?<name>.*?)\((?<path>attachment-unit/\d+/slide/\d+)\)\[/slide\]/#
    ) { match in
        "![Slide](fa-file) [\(match.name)](mention://slide/\(match.path))"
    }

    static func visitAll(input: inout String) {
        for visit in [
            attachments.visit(input:),
            attachmentUnits.visit(input:),
            channels.visit(input:),
            exercises.visit(input:),
            ins.visit(input:),
            lectures.visit(input:),
            members.visit(input:),
            messages.visit(input:),
            slides.visit(input:)
        ] {
            visit(&input)
        }
    }
}

// MARK: - Supporting Types

private enum Exercise: String, CaseIterable {
    case programming
    case quiz
    case text
    case fileUpload = "file-upload"
    case modeling

    var title: String {
        switch self {
        case .programming:
            return "Programming"
        case .quiz:
            return "Quiz"
        case .text:
            return "Text"
        case .fileUpload:
            return "File Upload"
        case .modeling:
            return "Modeling"
        }
    }

    var icon: String {
        switch self {
        case .programming:
            return "fa-keyboard"
        case .quiz:
            return "fa-check-double"
        case .fileUpload:
            return "fa-file-upload"
        case .text:
            return "fa-font"
        case .modeling:
            return "fa-diagram-project"
        }
    }
}
