import UserStore
import Foundation

public struct Account: Codable {
    public let id: Int64
    public let login: String
    public let name: String
    public let firstName: String
    public let lastName: String?
    public let email: String
    public let langKey: String
    public let authorities: [Authority]?
    public let groups: [String]?

    public static func hasGroup(group: String?) -> Bool {
        guard let group,
              UserSession.shared.isLoggedIn,
              let user = UserSession.shared.user,
              user.authorities != nil,
              let groups = user.groups else {
            return false
        }
        return groups.contains(group)
    }

    public static func hasAnyAuthorityDirect(authority: Authority) -> Bool {
        guard UserSession.shared.isLoggedIn,
              let user = UserSession.shared.user,
              let userAuthorities = user.authorities else {
            return false
        }

        return userAuthorities.contains(authority)
    }
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
