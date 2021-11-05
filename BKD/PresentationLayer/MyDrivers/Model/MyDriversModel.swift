//
//  MyDriversModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

struct MyDriversModel {
    public var fullname: String
    public var licenciNumber: String
    public var price: Double
    public var isSelected: Bool = false
    public var isWaitingForAdmin: Bool = false
    public var totalPrice: Double?
    public var driver: MainDriver?

}
