//
//  MyBKDViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit

class MyBKDViewModel: NSObject {
    private let keychainManager = KeychainManager()

    
    func logout() {
        keychainManager.removeData()
        //UserManager.share.userResponse = nil
    
    }
}
