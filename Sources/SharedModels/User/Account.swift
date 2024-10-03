import UserStore
import Foundation

public struct Account: Codable {
    public let id: Int64
    public let login: String
    public let name: String
    public let firstName: String
    public let lastName: String?
    private let imageUrl: String?
    public let email: String
    public let langKey: String
    public let authorities: [Authority]?
    public let groups: [String]?
    public let lastNotificationRead: Date?
    public let visibleRegistrationNumber: String?
    public let createdDate: Date?

    public static func hasGroup(group: String?) -> Bool {
        guard let group,
              UserSessionFactory.shared.isLoggedIn,
              let user = UserSessionFactory.shared.user,
              user.authorities != nil,
              let groups = user.groups else {
            return false
        }
        return groups.contains(group)
    }

    public static func hasAnyAuthorityDirect(authority: Authority) -> Bool {
        guard UserSessionFactory.shared.isLoggedIn,
              let user = UserSessionFactory.shared.user,
              let userAuthorities = user.authorities else {
            return false
        }

        return userAuthorities.contains(authority)
    }

    public var imagePath: URL? {
        guard var imageUrl else { return nil }
        if imageUrl.starts(with: "/") {
            imageUrl.removeFirst()
        }
        let baseUrl = UserSessionFactory.shared.institution?.baseURL
        return baseUrl?.appending(path: imageUrl)
    }
}

public extension Account {
    static let mock = Account(
        id: 1,
        login: "chloe_mitchell",
        name: "Chloe Mitchell",
        firstName: "Chloe",
        lastName: "Mitchell",
        imageUrl: nil,
        email: "chloe_mitchell@gmail.com",
        langKey: "en",
        authorities: [.user],
        groups: ["tumuser"],
        lastNotificationRead: .yesterday,
        visibleRegistrationNumber: "04242424",
        createdDate: .distantPast
    )
}

public typealias User = Account

public enum Authority: String, RawRepresentable, Codable {
    case admin = "ROLE_ADMIN"
    case instructor = "ROLE_INSTRUCTOR"
    case editor = "ROLE_EDITOR"
    case teachingAssistent = "ROLE_TA"
    case user = "ROLE_USER"
}

public extension UserSession {
    var user: User? {
        get {
            guard isLoggedIn,
                  let userData = UserDefaults.standard.object(forKey: "User") as? Data else { return nil }
            return try? JSONDecoder().decode(Account.self, from: userData)
        }
        set(newValue) {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "User")
            }
        }
    }
}
