//
//  PhoneVerify.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-11-21.
//

import Foundation

struct PhoneVerify: Decodable {
    let username: String
    let status: String
    let name: String
    let surname: String
    let phoneCode: String?
    let phoneNumber: String?
}
