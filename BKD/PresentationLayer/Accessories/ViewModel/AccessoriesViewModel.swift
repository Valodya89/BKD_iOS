//
//  AccessoriesViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

class AccessoriesViewModel: NSObject {
    
    func getTotalAccesories(accessoryPrice: Double,
                              totalPrice: Double,
                              isIncrease: Bool,
                              didResult: @escaping (String) -> ()) {
        var value: Double = 0.0
        if isIncrease {
            value = totalPrice + accessoryPrice
        } else {
            value = totalPrice - accessoryPrice
        }
       // let newValue = String(value).replacingOccurrences(of: ".", with: ",")

        didResult(String(value))
    }
    
//    func countTotalAccesories(accessoryImg:UIImage,
//                              accessoryName:String,
//                              accessoryPrice:Double,
//                              accessoryCount:Int,
//                              totalPrice: Double,
//                              isIncrease: Bool,
//                              index: Int,
//                              didResult: @escaping (String) -> ()) {
//        var value: Double = 0.0
//        if isIncrease {
//            value = totalPrice + accessoryPrice
//        } else {
//            value = totalPrice - accessoryPrice
//        }
//        // let newValue = String(value).replacingOccurrences(of: ".", with: ",")
//
//        didResult(String(value))
//    }
}
