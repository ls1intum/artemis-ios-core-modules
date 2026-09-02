//
//  LoginOptionsDTO.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 01.09.26.
//

public struct LoginOptionsDTO: Decodable {
    public enum LoginMethod: String, Decodable {
        case password = "PASSWORD"
        case oidc = "OIDC"
        case saml2 = "SAML2"
    }

    public let loginMethod: LoginMethod
    public let idpName: String?
}
