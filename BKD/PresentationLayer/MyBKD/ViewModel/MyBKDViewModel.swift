//
//  MyBKDViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit

final class MyBKDViewModel: NSObject {
    private let keychainManager = KeychainManager()

    var isUserSignIn: Bool {
        return keychainManager.isUserLoggedIn()
    }
    
    func logout() {
        keychainManager.removeData()
    }
}
