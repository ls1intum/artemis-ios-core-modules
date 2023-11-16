import Foundation

public protocol StudentParticipation: BaseParticipation {
    var student: User? { get }
    var team: Team? { get }
    var participantIdentifier: String? { get }
    var testRun: Bool? { get }
}

public struct StudentParticipationImpl: StudentParticipation, Codable {

    public static var type: String {
        "student"
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

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case student
        case team
        case participantIdentifier
        case testRun
        case id
        case initializationState
        case initializationDate
        case individualDueDate
        case results
        case exercise
        case submissions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case StudentParticipationImpl.type:
            self = try StudentParticipationImpl(from: decoder)
        default:
            self.student = nil
            self.team = nil
            self.participantIdentifier = nil
            self.testRun = nil
            self.id = 0
            self.initializationState = nil
            self.initializationDate = nil
            self.individualDueDate = nil
            self.results = nil
            self.exercise = nil
            self.submissions = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.type, forKey: .type)
        try container.encode(student, forKey: .student)
        try container.encode(team, forKey: .team)
        try container.encode(participantIdentifier, forKey: .participantIdentifier)
        try container.encode(testRun, forKey: .testRun)
        try container.encode(id, forKey: .id)
        try container.encode(initializationState, forKey: .initializationState)
        try container.encode(initializationDate, forKey: .initializationDate)
        try container.encode(individualDueDate, forKey: .individualDueDate)
        try container.encode(results, forKey: .results)
        try container.encode(exercise, forKey: .exercise)
        try container.encode(submissions, forKey: .submissions)
    }
}
