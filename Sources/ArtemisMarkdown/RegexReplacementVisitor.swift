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
    static let channels = RegexReplacementVisitor(regex: #/\[channel\](?<name>.*?)\((?<id>.*?)\)\[/channel\]/#) { match in
        "[#\(match.name)](mention://channel/\(match.id))"
    }

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

    static let lectures = RegexReplacementVisitor(
        regex: #/\[lecture\](?<name>.*?)\((?<path>/courses/\d+/lectures/\d+)\)\[/lecture\]/#
    ) { match in
        guard let baseURL = UserSession.shared.institution?.baseURL,
              let url = URL(string: String(match.path), relativeTo: baseURL) else {
            return String(match.0)
        }
        return "![Lecture](fa-chalkboard-user) [\(match.name)](mention://lecture/\(url.lastPathComponent))"
    }

    static let members = RegexReplacementVisitor(regex: #/\[user\](?<name>.*?)\((?<login>.*?)\)\[/user\]/#) { match in
        "[@\(match.name)](mention://member/\(match.login))"
    }

    static func visitAll(input: inout String) {
        for visit in [
            channels.visit(input:),
            exercises.visit(input:),
            ins.visit(input:),
            lectures.visit(input:),
            members.visit(input:)
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
            return "file-upload"
        case .text:
            return "text"
        case .modeling:
            return "uml"
        }
    }
}
