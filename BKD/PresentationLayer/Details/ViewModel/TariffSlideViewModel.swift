//
//  TariffSlideViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit

class TariffSlideViewModel: NSObject {
static let shared = TariffSlideViewModel()
    
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
}
