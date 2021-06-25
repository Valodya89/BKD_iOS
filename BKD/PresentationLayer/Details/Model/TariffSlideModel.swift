//
//  TariffSlideModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit


struct TariffSlideModel {
    public var title: String
    public var option: String?
    public var bckgColor: UIColor
    public var titleColor: UIColor
    public var value: String?
    public var isOpenOptions: Bool = false
    public var isItOption: Bool = false
    public var options: [TariffSlideModel]?
}

//struct TariffSlideOptionsModel {
//    public var tariffOptionsArr: [String]?
//
//
//}
