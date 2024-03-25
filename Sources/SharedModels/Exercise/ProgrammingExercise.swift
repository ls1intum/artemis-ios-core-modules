import Foundation

public struct ProgrammingExercise: BaseExercise {
    public typealias SelfType = ProgrammingExercise

    public static var type: String {
        "programming"
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
    public var programmingLanguage: ProgrammingLanguage?
    public var studentAssignedTeamIdComputed: Bool?
    public var studentAssignedTeamId: Int?
    public var gradingCriteria: [GradingCriterion]?
    public var gradingInstructions: String?
    public var numberOfAssessmentsOfCorrectionRounds: [DueDateStat]?
    public var numberOfOpenComplaints: Int?
    public var numberOfOpenMoreFeedbackRequests: Int?
    public var numberOfSubmissions: DueDateStat?
    public var totalNumberOfAssessments: DueDateStat?

    public var buildAndTestStudentSubmissionsAfterDueDate: Date?
    public var templateParticipation: TemplateParticipation?
    public var solutionParticipation: SolutionParticipation?

    public init(id: Int) {
        self.id = id
    }

    public func copyWithUpdatedParticipations(newParticipations: [Participation]) -> ProgrammingExercise {
        var clone = self
        clone[keyPath: \.studentParticipations] = newParticipations
        return clone
    }
}

public enum ProgrammingLanguage: String, RawRepresentable, Codable {
    case java = "JAVA"
    case python = "PYTHON"
    case c = "C"
    case haskell = "HASKELL"
    case kotlin = "KOTLIN"
    case vhdl = "VHDL"
    case assembler = "ASSEMBLER"
    case swift = "SWIFT"
    case ocaml = "OCAML"
    case empty = "EMPTY"
}
