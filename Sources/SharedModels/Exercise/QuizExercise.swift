import Foundation

public struct QuizExercise: BaseExercise {

    public typealias SelfType = QuizExercise

    public static var type: String {
        "quiz"
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

    public var course: EmbeddedCourse?
    public var allowedNumberOfAttempts: Int?
    public var remainingNumberOfAttempts: Int?
    public var randomizeQuestionOrder: Bool?
    public var isOpenForPractice: Bool?
    public var duration: Int?
    public var quizQuestions: [QuizQuestion]? = []
    public var status: QuizStatus?
    public var quizMode: QuizMode? = QuizMode.INDIVIDUAL
    public var quizEnded: Bool?
    public var quizBatches: [QuizBatch]? = []

    public init(id: Int) {
        self.id = id
    }

    public func copyWithUpdatedParticipations(newParticipations: [Participation]) -> QuizExercise {
        var clone = self
        clone[keyPath: \.studentParticipations] = newParticipations
        return clone
    }

    public var isUninitialized: Bool {
        notEndedSubmittedOrFinished && startedQuizBatch
    }

    public var notStarted: Bool {
        notEndedSubmittedOrFinished && !startedQuizBatch
    }

    private var notEndedSubmittedOrFinished: Bool {
        !(quizEnded ?? false)
        && (studentParticipations?.first?.baseParticipation.initializationState == nil
            || ![InitializationState.initialized, InitializationState.finished].contains(
                studentParticipations?.first?.baseParticipation.initializationState)
        )
    }

    private var startedQuizBatch: Bool {
        (quizBatches ?? []).contains(where: { $0.started ?? false })
    }
}

public enum QuizStatus: String, RawRepresentable, Codable {
    case closed = "CLOSED"
    case openForPractice = "OPEN_FOR_PRACTICE"
    case active = "ACTIVE"
    case visible = "VISIBLE"
    case invisible = "INVISIBLE"
}

public enum QuizMode: String, RawRepresentable, Codable {
    case SYNCHRONIZED
    case BATCHED
    case INDIVIDUAL
}

public struct QuizBatch: Codable {
    public var id: Int?
    public var startTime: Date?
    public var started: Bool?
    public var ended: Bool?
    public var submissionAllowed: Bool?
    public var password: String?
}

public struct EmbeddedCourse: Codable {
    public var id: Int
    public var title: String
}
