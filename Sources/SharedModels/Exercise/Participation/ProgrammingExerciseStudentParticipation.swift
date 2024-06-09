import Foundation

public struct ProgrammingExerciseStudentParticipation: StudentParticipation, Codable {

    public static var type: String {
        "programming"
    }

    public var student: User?
    public var team: Team?
    public var participantIdentifier: String?
    public var testRun: Bool?
    public var id: Int
    public var initializationState: InitializationState?
    public var initializationDate: Date?
    public var individualDueDate: Date?
    public var results: [Result]?
    public var exercise: Exercise?
    public var submissions: [Submission]?
    public var repositoryUrl: String?
    public var buildPlanId: String?
}

public extension ProgrammingExerciseStudentParticipation {
    static let mock = ProgrammingExerciseStudentParticipation(
        student: .mock,
        team: .none,
        participantIdentifier: "party",
        testRun: false,
        id: 11,
        initializationState: .finished,
        initializationDate: .yesterday,
        individualDueDate: .yesterday,
        results: [],
        exercise: .programming(exercise: .mockPastDeadline),
        submissions: [],
        repositoryUrl: "none",
        buildPlanId: "buildplan"
    )
}
