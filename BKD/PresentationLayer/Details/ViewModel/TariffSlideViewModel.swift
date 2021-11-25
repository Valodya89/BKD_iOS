//
//  TariffSlideViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit

class TariffSlideViewModel: NSObject {
    
    /// get current option index
    func getIndexOfOption(tariffArr: [Tariff], model: TariffSlideModel) -> Int {
        for (index, item) in tariffArr.enumerated() {
            if model.name == item.name {
                return index
            }
        }
        return 0
    }
    
    func getOptionString(tariff:TariffState, tariffSlideList: [TariffSlideModel], index: Int) -> String {
        var optionsArr:[Tariff] = []
        var optionStr: String = ""
        var option: String = ""
        var index = index
        switch tariff {
        case .hourly:
            optionsArr = tariffSlideList[0].tariff!
            optionStr = Constant.Texts.hours
            break
        case .daily:
            optionsArr = tariffSlideList[1].tariff!
            optionStr = Constant.Texts.days
            break
        case .weekly:
            optionsArr = tariffSlideList[2].tariff!
            optionStr = Constant.Texts.weeks
            break
        case .monthly:
            optionsArr = tariffSlideList[3].tariff!
            optionStr = Constant.Texts.month
            index = 0
            break
        case .flexible:
            return ""
        }
        option = String(optionsArr[index].duration)
        
        return option.dropLast() + " " + optionStr
    }
    
    
    ///Get Tariff state index
    func getTariffStateIndex(tariffState: TariffState) -> NSInteger {
        switch tariffState {
        case .hourly:
            return 0
        case .daily:
            return 1
        case .weekly:
            return 2
        case .monthly:
            return 3
        case .flexible:
            return NSInteger(4)
        }
    }
   
}
