import Foundation

public struct FileAttachment: BaseAttachment {

    public var id: Int
    public var name: String?
    public var visibleToStudents: Bool?
    public var link: String?
    public var version: Int?
    public var uploadDate: Date?
    public var releaseDate: Date?

    public static var type: String {
        "FILE"
    }

    public init(id: Int,
                name: String? = nil,
                visibleToStudents: Bool? = nil,
                link: String? = nil,
                version: Int? = nil,
                uploadDate: Date? = nil,
                releaseDate: Date? = nil) {
        self.id = id
        self.name = name
        self.visibleToStudents = visibleToStudents
        self.link = link
        self.version = version
        self.uploadDate = uploadDate
        self.releaseDate = releaseDate
    }
}
