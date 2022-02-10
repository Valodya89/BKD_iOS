//
//  Account.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-02-22.
//

import Foundation

struct Account: Codable {
    
    let username: String
    let status: String
    let name: String
    let surname: String
    let phoneCode: String
    let phoneNumber: String
    let phoneVerified: Bool
}
