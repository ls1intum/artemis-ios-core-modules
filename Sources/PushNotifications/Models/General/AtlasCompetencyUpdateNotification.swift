//
//  AtlasCompetencyUpdateNotification.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 07.11.26.
//

import Foundation

public struct AtlasCompetencyUpdateNotification: CourseBaseNotification {
    public var courseId: Int?
    public var courseTitle: String?
    public var courseIconUrl: String?

    public var outcome: String?
    public var exerciseCount: Int
    public var appliedCount: Int
    public var createdCount: Int
    public var editedCount: Int
    public var deletedCount: Int
    public var assignedCount: Int
    public var unassignedCount: Int
    public var changesMarkdown: String?
    public var omittedCount: Int
}
