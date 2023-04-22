import UserStore
import Foundation

public struct Account: Codable {
    public let id: Int64
    public let login: String
    public let name: String
    public let firstName: String
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
            guard isLoggedIn else { return nil }
            return UserDefaults.standard.object(forKey: "User") as? User
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "User")
        }
    }
}
