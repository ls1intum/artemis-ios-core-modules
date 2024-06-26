import Foundation

public struct TextExercise: BaseExercise {

    public typealias SelfType = TextExercise

    public static var type: String {
        "text"
    }

    public var id: Int
    public var title: String?
    public var shortName: String?
    public var maxPoints: Double?
    public var bonusPoints: Double?
    public var dueDate: Date?
    public var releaseDate: Date?
    public var assessmentDueDate: Date?
    public var difficulty: Difficulty?
    public var mode: Mode = .individual
    public var categories: [Category]? = []
    public var visibleToStudents: Bool?
    public var teamMode: Bool?
    public var secondCorrectionEnabled: Bool?
    public var problemStatement: String?
    public var assessmentType: AssessmentType?
    public var allowComplaintsForAutomaticAssessments: Bool?
    public var allowManualFeedbackRequests: Bool?
    public var includedInOverallScore: IncludedInOverallScore = .includedCompletely
    public var exampleSolutionPublicationDate: Date?
    public var studentParticipations: [Participation]?
    public var attachments: [Attachment]? = []
    public var studentAssignedTeamIdComputed: Bool?
    public var studentAssignedTeamId: Int?
    public var gradingCriteria: [GradingCriterion]?
    public var gradingInstructions: String?
    public var numberOfAssessmentsOfCorrectionRounds: [DueDateStat]?
    public var numberOfOpenComplaints: Int?
    public var numberOfOpenMoreFeedbackRequests: Int?
    public var numberOfSubmissions: DueDateStat?
    public var totalNumberOfAssessments: DueDateStat?

    public var exampleSolution: String?

    public func copyWithUpdatedParticipations(newParticipations: [Participation]) -> TextExercise {
        var clone = self
        clone[keyPath: \.studentParticipations] = newParticipations
        return clone
    }
}

public extension TextExercise {
    init(id: Int) {
        self.id = id
    }

    static let mock = TextExercise(
        id: 14,
        title: "Spaceship Design",
        dueDate: .now.addingTimeInterval(-120),
        releaseDate: .yesterday,
        assessmentDueDate: .tomorrow,
        mode: .individual,
        includedInOverallScore: .includedCompletely
    )
}
