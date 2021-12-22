//
//  AddAccident.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-12-21.
//

import UIKit

struct AddAccident: Codable {
    let id: String
    let rentId: String
    let userId: String
    let date: Double
    let address: String
    let longitude: Double
    let latitude: Double
    let damages: [Damage?]
    let form: [Form?]
}


struct Damage: Codable {
     let comment: String
     let image: Logo
    }

struct Form: Codable {
     let comment: String
     let image: Logo
    }
