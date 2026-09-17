//
//  CourseAccessRightsDTO.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 17.09.26.
//

import Foundation

public struct CourseAccessRightsDTO: Codable {
    let courseId: Int
    let roles: [CourseRole]
}

public enum CourseRole: String, ConstantsEnum {
    case student = "STUDENT"
    case teachingAssistant = "TEACHING_ASSISTANT"
    case editor = "EDITOR"
    case instructor = "INSTRUCTOR"
    case unknown
}
