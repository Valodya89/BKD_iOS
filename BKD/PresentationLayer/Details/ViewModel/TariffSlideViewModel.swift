//
//  TariffSlideViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit

class TariffSlideViewModel: NSObject {
//static let shared = TariffSlideViewModel()
    
    /// get current option index
    func getIndexOfOption(tariffArr: [Tariff], model: TariffSlideModel) -> Int {
        for (index, item) in tariffArr.enumerated() {
            if model.name == item.name {
                return index
            }
        }
        return 0
    }
    
    func getOptionString(tariff:TariffState, index: Int) -> String {
        var optionsArr:[String] = []
        var optionStr: String = ""
        var option: String = ""
        var index = index
        switch tariff {
        case .hourly:
            optionsArr = tariffOptionsArr[0]
            optionStr = Constant.Texts.hours
            break
        case .daily:
            optionsArr = tariffOptionsArr[1]
            optionStr = Constant.Texts.days
            break
        case .weekly:
            optionsArr = tariffOptionsArr[2]
            optionStr = Constant.Texts.weeks
            break
        case .monthly:
            optionsArr = tariffOptionsArr[3]
            optionStr = Constant.Texts.month
            index = 0
            break
        case .flexible:
            return ""
        }
        option = optionsArr[index]
        
        return option.dropLast() + " " + optionStr
    }
    
        
   
}
