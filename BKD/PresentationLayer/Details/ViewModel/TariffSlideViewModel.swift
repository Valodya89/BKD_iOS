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
func getCurrentOption(model: TariffSlideModel, tariff: Tariff) -> Int {
    var optionsArr:[String] = []
    switch tariff {
        case .hourly:
            optionsArr = tariffOptionsArr[0]
            break
        case .daily:
            optionsArr = tariffOptionsArr[1]
            break
        case .weekly:
            optionsArr = tariffOptionsArr[2]
            break
        case .monthly:
            optionsArr = tariffOptionsArr[3]
            break
        case .flexible:
            break

        }
    return getIndexOfOption(optionsArr: optionsArr, model: model)
   
}
    
    func getIndexOfOption(optionsArr: [String], model: TariffSlideModel) -> Int {
        for (index, item) in optionsArr.enumerated() {
            let optionNameArr = model.option!.components(separatedBy: " ")
            let firstStr: String = optionNameArr[0]
            let newStr = firstStr + optionNameArr[1].prefix(1)
            if item.caseInsensitiveCompare(newStr) == .orderedSame {
                return index
            }
        }
        return 0
    }
    
    func getOptionString(tariff:Tariff, index: Int) -> String {
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
