//
//  FilterModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-05-21.
//

import UIKit

struct EquipmentModel {
    public var equipmentImg: UIImage
    public var equipmentName: String
    public var didSelect: Bool = false

}

struct ExteriorModel {
    var exterior: Exterior?
    var didSelect: Bool = false
}

struct Exterior: Codable {
    let length: Double
    let width: Double
    let height: Double
    
    func getExterior() -> String {
        return "\(length)x\(width)x\(height)\(Constant.Texts.m)"
    }
}
