//
//  Tariff.swift
//  Tariff
//
//  Created by Karine Karapetyan on 30-09-21.
//

import UIKit

struct Tariff: Codable {

    let id: String
    let type: String
    let name: String
    let duration: Double
    let percentage: Double
    let depositApplies: Bool
    let fuelCompensation: Bool
    let deposit: Double
    let active: Bool
    let vatincluded: Bool
}


