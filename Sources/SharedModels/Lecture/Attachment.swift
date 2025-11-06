import Foundation

public struct Attachment: Codable {
    public var id: Int
    public var name: String?
    public var visibleToStudents: Bool?
    public var link: String?
    public var version: Int?
    public var uploadDate: Date?
    public var releaseDate: Date?

    public var pathExtension: String? {
        guard let name = link else { return nil }
        let filename: NSString = name as NSString
        return filename.pathExtension.uppercased()
    }
}
