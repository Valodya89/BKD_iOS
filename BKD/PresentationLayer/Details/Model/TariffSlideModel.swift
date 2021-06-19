//
//  TariffSlideModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit


struct TariffSlideModel {
    public var title: String
    public var bckgColor: UIColor
    public var titleColor: UIColor
    public var value: String?
    public var isOpenDetails: Bool = false
    public var details: [TariffSlideModel]?
}

//struct TariffSlideDetailsModel {
//    public var title: String
//    public var value: String
//    public var bckgColor: UIColor
//
//
//}
