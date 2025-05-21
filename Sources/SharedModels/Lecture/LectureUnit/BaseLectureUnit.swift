//
//  BaseLectureUnit.swift
//  
//
//  Created by Sven Andabaka on 02.05.23.
//

import Foundation
import SwiftUI

public protocol BaseLectureUnit: Codable {

    static var type: String { get }

    var id: Int64 { get }
    var name: String? { get }
    var releaseDate: Date? { get }
    var lecture: Lecture? { get }
//    var learningGoals: [LearningGoal]? { get } not implemented yet
    // calculated property
    var visibleToStudents: Bool? { get }
    var completed: Bool? { get }

    var image: Image { get }
}

public enum LectureUnit: Codable {
    fileprivate enum Keys: String, CodingKey {
        case type
    }

    case attachmentVideo(lectureUnit: AttachmentVideoUnit)
    case exercise(lectureUnit: ExerciseUnit)
    case text(lectureUnit: TextUnit)
    case online(lectureUnit: OnlineUnit)
    case unknown(lectureUnit: UnknownLectureUnit)

    public var baseUnit: any BaseLectureUnit {
        switch self {
        case .attachmentVideo(let lectureUnit): return lectureUnit
        case .exercise(let lectureUnit): return lectureUnit
        case .text(let lectureUnit): return lectureUnit
        case .online(let lectureUnit): return lectureUnit
        case .unknown(let lectureUnit): return lectureUnit
        }
    }

    public var id: Int64 {
        baseUnit.id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(String.self, forKey: Keys.type)
        switch type {
        case AttachmentVideoUnit.type: self = .attachment(lectureUnit: try AttachmentVideoUnit(from: decoder))
        case ExerciseUnit.type: self = .exercise(lectureUnit: try ExerciseUnit(from: decoder))
        case TextUnit.type: self = .text(lectureUnit: try TextUnit(from: decoder))
        case OnlineUnit.type: self = .online(lectureUnit: try OnlineUnit(from: decoder))
        default: self = .unknown(lectureUnit: try UnknownLectureUnit(from: decoder))
        }
    }

    public init?(lectureUnit: BaseLectureUnit) {
        if let lectureUnit = lectureUnit as? AttachmentVideoUnit {
            self = .attachment(lectureUnit: lectureUnit)
            return
        }
        if let lectureUnit = lectureUnit as? ExerciseUnit {
            self = .exercise(lectureUnit: lectureUnit)
            return
        }
        if let lectureUnit = lectureUnit as? TextUnit {
            self = .text(lectureUnit: lectureUnit)
            return
        }
        if let lectureUnit = lectureUnit as? OnlineUnit {
            self = .online(lectureUnit: lectureUnit)
            return
        }

        return nil
    }
}
