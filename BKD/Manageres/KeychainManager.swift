//
//  KeychainManager.swift
//  MimoBike
//
//  Created by Albert on 14.05.21.
//

import Foundation
import KeychainAccess

protocol UserToken {
//    var user: UserResponse? { get }
    var token: TokenResponse? { get }
}

final class KeychainManager {
    
    let keychain = Keychain(service: "com.BKD.bkdrental")
    let accessTokenKey = "AccessToken"
    let refreshTokenKey = "RefreshToken"
    let expiresInKey = "RefreshToken"
    let userName = "UserName"
    let password = "Password"
    let phoneCodeId = "PhoneCodeId"
    let phoneNumber = "PhoneNumber"
    let userFullName = "UserFullName"

    
    // MARK: - Functions
    
    /// Save userName in keychain
    func saveUsername(username: String) {
        do {
            try keychain.set(username, key: userName)
        } catch let error {
            print(error)
        }
    }
    
    /// Save password in keychain
    func savePassword(passw: String) {
        do {
            try keychain.set(passw, key: password)
        } catch let error {
            print(error)
        }
    }
    
    /// Save full name of user in keychain
    func saveUserFullName(fullName: String) {
        do {
            try keychain.set(fullName, key: userFullName)
        } catch let error {
            print(error)
        }
    }
    
    /// Save token in keychain
    func saveToken(token: String) {
        do {
            try keychain.set(token, key: accessTokenKey)
        } catch let error {
            print(error)
        }
    }
    
    /// Save refresh token in keychain
    func saveRefreshToken(token: String) {
        do {
            try keychain.set(token, key: refreshTokenKey)
        } catch let error {
            print(error)
        }
    }
    
    /// Save expires In in keychain
    func saveExpireIn(expiresIn: Double) {
        do {
            let willExpireIn = Date().timeIntervalSince1970 + expiresIn /*(expiresIn * 1000)*/
            try keychain.set(String(format: "%.0f", willExpireIn), key: expiresInKey)
        } catch let error {
            print(error)
        }
    }
    
    /// Save phone code in keychain
    func savePhoneCodeId(id: String) {
        do {
            try keychain.set(id, key: phoneCodeId)
        } catch let error {
            print(error)
        }
    }
    
    /// Save phone number in keychain
    func savePhoneNumber(number: String) {
        do {
            try keychain.set(number, key: phoneNumber)
        } catch let error {
            print(error)
        }
    }
    
    /// Check user token
    func isUserLoggedIn() -> Bool {
        return keychain[accessTokenKey] != nil
    }
    
    
    /// Check user token
    func isTokenExpired() -> Bool {
        guard let expiresInString = keychain[expiresInKey],
              let expiresIn = Double(expiresInString) else { return true }
        return expiresIn < Date().timeIntervalSince1970
    }
    
    /// Get token from keychain
    func getAccessToken() -> String? {
        let token = try? keychain.getString(accessTokenKey)
        return token
    }
    
    /// Get refresh token from keychain
    func getRefreshToken() -> String? {
        let token = try? keychain.getString(refreshTokenKey)
        return token
    }
    
    /// Get token from keychain
    func getUsername() -> String? {
        let username = try? keychain.getString(userName)
        return username
    }
    
    /// Get refresh token from keychain
    func getPasswor() -> String? {
        let passw = try? keychain.getString(password)
        return passw
    }
    
    /// Get full name of user from keychain
    func getUserFullName() -> String? {
        let fullName = try? keychain.getString(userFullName)
        return fullName
    }
    
    /// Get phone code id from keychain
    func getPhoneCodeId() -> String? {
        let phoneId = try? keychain.getString(phoneCodeId)
        return phoneId
    }
    
    /// Get phone number from keychain
    func getPhoneNumber() -> String? {
        let number = try? keychain.getString(phoneNumber)
        return number
    }
    
    /// Delete token from keychain
    func removeData() {
        do {
            try keychain.removeAll()
        } catch let error {
            debugPrint("Error: \(error)")
        }
    }
    
    /// Remove all keychain data when run first time
    func resetIfNeed() {
        if !UserDefaults.standard.bool(forKey: "hasRunBefore") {
            // Remove Keychain items here
            do {
                try keychain.removeAll()
            } catch let error {
                debugPrint("Error: \(error)")
            }
            
            // Update the flag indicator
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
        }
    }
    
    func parse(from content: TokenResponse) {
        self.saveToken(token: content.accessToken ?? "")
        self.saveRefreshToken(token: content.refreshToken ?? "")
        self.saveExpireIn(expiresIn: content.expiresIn ?? 0)
    }
}
