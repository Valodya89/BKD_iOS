//
//  TokenResponse.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 09.08.21.
//

import Foundation

struct TokenResponse: Decodable {
    let accessToken: String?
    let tokenType: String?
    let refreshToken: String?
    let expiresIn: Double?
    let scope: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope
    }
}
