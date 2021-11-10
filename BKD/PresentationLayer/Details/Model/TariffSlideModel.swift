//
//  TariffSlideModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit


struct TariffSlideModel {

    public var type: String?
    public var name: String?
    public var bckgColor: UIColor?
    public var typeColor: UIColor?
    public var value: String?
    public var specialValue: String?
    public var discountPercent: Double?
    public var flexibleStaringPrice: Double?


    public var fuelConsumption: Bool = false
    public var isOpenOptions: Bool = false
    public var isItOption: Bool = false
    public var isSelected:Bool = false
    public var options: [TariffSlideModel]?
    public var tariff: [Tariff]?
}





