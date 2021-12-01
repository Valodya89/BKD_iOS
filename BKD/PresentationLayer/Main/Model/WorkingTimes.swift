//
//  Settings.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-07-21.
//

import UIKit

struct  Settings: Codable {
    let id: String
    let registrationAgreementUrl: String
    let reservationAgreementUrl: String
    let workStart: String
    let workEnd: String
    let metadata: [String : String]
}



struct  FlexibleTimes: Codable {
    let id: String
    let type: String
    let start: String?
    let end: String?
    let active: Bool
}
