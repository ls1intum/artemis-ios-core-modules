import Foundation
import UserStore

public struct Message: BaseMessage {

    public var id: Int64
    public var author: ConversationUser?
    public var creationDate: Date?
    public var updatedDate: Date?
    public var content: String?
    public var tokenizedContent: String?
    public var authorRoleTransient: UserRole?

    public var title: String?
    public var visibleForStudents: Bool?
    public var reactions: [Reaction]?
    public var answers: [AnswerMessage]?
    public var tags: [String]?
    public var exercise: Exercise?
    public var lecture: Lecture?
    public var course: Course?
    public var courseWideContext: CourseWideContext?
    public var conversation: Conversation?
    public var displayPriority: DisplayPriority?
//    var plagiarismCase: PlagiarismCase?
    public var resolved: Bool?
    public var answerCount: Int?
    public var voteCount: Int?

    public init(id: Int64,
                author: ConversationUser? = nil, 
                creationDate: Date? = nil,
                updatedDate: Date? = nil,
                content: String? = nil,
                tokenizedContent: String? = nil,
                authorRoleTransient: UserRole? = nil,
                title: String? = nil,
                visibleForStudents: Bool? = nil,
                reactions: [Reaction]? = nil,
                answers: [AnswerMessage]? = nil,
                tags: [String]? = nil,
                exercise: Exercise? = nil,
                lecture: Lecture? = nil,
                course: Course? = nil,
                courseWideContext: CourseWideContext? = nil,
                conversation: Conversation? = nil,
                displayPriority: DisplayPriority? = nil,
                resolved: Bool? = nil,
                answerCount: Int? = nil,
                voteCount: Int? = nil) {
        self.id = id
        self.author = author
        self.creationDate = creationDate
        self.updatedDate = updatedDate
        self.content = content
        self.tokenizedContent = tokenizedContent
        self.authorRoleTransient = authorRoleTransient
        self.title = title
        self.visibleForStudents = visibleForStudents
        self.reactions = reactions
        self.answers = answers
        self.tags = tags
        self.exercise = exercise
        self.lecture = lecture
        self.course = course
        self.courseWideContext = courseWideContext
        self.conversation = conversation
        self.displayPriority = displayPriority
        self.resolved = resolved
        self.answerCount = answerCount
        self.voteCount = voteCount
    }
}

extension Message: Equatable, Hashable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.answers?.count ?? 0 == rhs.answers?.count ?? 0 &&
        lhs.reactions?.count ?? 0 == rhs.reactions?.count ?? 0
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
