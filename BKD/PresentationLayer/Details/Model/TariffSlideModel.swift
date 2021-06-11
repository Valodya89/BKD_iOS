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
    public var details: [TariffSlideDetailsModel]

}

struct TariffSlideDetailsModel {
    public var title: String
    public var value: String
    public var bckgColor: UIColor


}
