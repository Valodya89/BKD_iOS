//
//  AccessoriesViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

class AccessoriesViewModel: NSObject {
static let shared = AccessoriesModel()
    
    func countTotalAccesories(accessories: AccessoriesModel, isIncrease: Bool, price: Double,
                              didResult: @escaping (String) -> ()) {
        var value: Double = 0.0
        if isIncrease {
            value = price + accessories.accessoryPrice!
        } else {
            value = price - accessories.accessoryPrice!
        }
        let newValue = String(value).replacingOccurrences(of: ".", with: ",")
        
        didResult(newValue)        
    }
}
