//
//  Country.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-07-21.
//

import UIKit

struct Country: Codable {
    let id: String
    let code: String
    let country: String?
    let nationalDocumentMask: String?
}
