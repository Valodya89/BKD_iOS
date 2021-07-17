//
//  RestrictedZones.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-07-21.
//

import UIKit

struct RestrictedZones: Codable {
    let id:String
    let name:String
    let longitude:Double
    let latitude:Double
    let radius:Double
}
