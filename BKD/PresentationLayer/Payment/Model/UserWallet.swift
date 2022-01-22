//
//  UserWallet.swift
//  BKD
//
//  Created by Karine Karapetyan on 03-12-21.
//

import Foundation

struct UserWallet : Decodable {
    
    public let id: String
    public let balance: Double
    public let debt: Double
    public let freeze: Double
    public let currency: String
    public let creationDate: Double
    public let card: String?
}
