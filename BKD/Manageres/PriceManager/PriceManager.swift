//
//  PriceManager.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-11-21.
//

import UIKit

final class PriceManager {
    static let shared = PriceManager()
    
    var pickUpCustomLocationPrice: Double?
    var returnCustomLocationPrice: Double?
    var pickUpNoWorkingTimePrice: Double?
    var returnNoWorkingTimePrice: Double?
    var carPrice: Double?
    var carOffertPrice: Double?
    var carDiscountPrecent: Double?
    var accessoriesPrice: Double?
    var additionalDriversPrice: Double?
    
    ///Calculate custom location total price
    func getCustomLocationTotalPrice() -> Double? {
        let total = Float(pickUpCustomLocationPrice ?? 0) + Float(returnCustomLocationPrice ?? 0)
        return total > 0 ? Double(total) : nil
    }
    
    ///Calculate no working times total price
    func getNoWorkingTimesTotalPrice() -> Double? {
        let total = Float(pickUpNoWorkingTimePrice ?? 0) + Float(returnNoWorkingTimePrice ?? 0)
        return total > 0 ? Double(total) : nil
    }

    
    ///Get price list
    func getPrices() -> [PriceModel] {
        
        var prices:[PriceModel] = []
        
        if let price = carPrice {
            prices.append(PriceModel(priceTitle: Constant.Texts.price, price:
                                        price))
        }
        if carOffertPrice ?? 0 > 0 &&
            carDiscountPrecent ?? 0 > 0
        {
            prices.append(PriceModel(priceTitle: Constant.Texts.specialOffer, price: carOffertPrice, discountPrecent: carDiscountPrecent))
        }
        
        let totalLocation = getCustomLocationTotalPrice() ?? 0
        if totalLocation > 0 {
            prices.append(PriceModel(priceTitle: Constant.Texts.customLocation, price: totalLocation))
        }
        let totalNoWorkibngTotal = getNoWorkingTimesTotalPrice() ?? 0
        if totalLocation > 0 {
            prices.append(PriceModel(priceTitle: Constant.Texts.additionalService, price: totalNoWorkibngTotal))
        }
        
        if accessoriesPrice ?? 0.0 > 0.0 {
            prices.append(PriceModel(priceTitle: Constant.Texts.accessories, price: accessoriesPrice))
        }
        if additionalDriversPrice ?? 0.0 > 0.0 {
            prices.append(PriceModel(priceTitle: Constant.Texts.additionalDriver, price: additionalDriversPrice))
        }
        return prices
    }
    
    
    ///Get Total price
    func getTotalPrice(totalPrices:[PriceModel]) -> Double {
        var total: Double = 0
        for item  in totalPrices {
            let item = item as PriceModel
            total += item.price!
        }
        if carOffertPrice ?? 0 > 0 && carDiscountPrecent ?? 0 > 0 {
            total -= carPrice ?? 0
        }
     return total
    }
    
//    ///Get price list
//    func getPrices() -> Array<Any>? {
//        var prices:[PriceModel] = []
//       let priceManage = PriceManager.shared
//
//        if let price = priceManage.carPrice {
//            prices.append(PriceModel(priceTitle: Constant.Texts.price, price:
//                                        price))
//        }
//        if priceManage.carOffertPrice ?? 0 > 0 &&
//            priceManage.carDiscountPrecent ?? 0 > 0
//        {
//            prices.append(PriceModel(priceTitle: Constant.Texts.specialOffer, price: priceManage.carOffertPrice, discountPrecent: priceManage.carDiscountPrecent))
//        }
//
//        let totalLocation = priceManage.getCustomLocationTotalPrice() ?? 0
//        if totalLocation > 0 {
//            prices.append(PriceModel(priceTitle: Constant.Texts.customLocation, price: totalLocation))
//        }
//        let totalNoWorkibngTotal = priceManage.getNoWorkingTimesTotalPrice() ?? 0
//        if totalLocation > 0 {
//            prices.append(PriceModel(priceTitle: Constant.Texts.additionalService, price: totalNoWorkibngTotal))
//        }
//
//        if priceManage.accessoriesPrice ?? 0.0 > 0.0 {
//            prices.append(PriceModel(priceTitle: Constant.Texts.accessories, price: priceManage.accessoriesPrice))
//        }
//        if priceManage.additionalDriversPrice ?? 0.0 > 0.0 {
//            prices.append(PriceModel(priceTitle: Constant.Texts.additionalDriver, price: priceManage.additionalDriversPrice))
//        }
//        return prices
//    }
//
//
//    ///Get Total price
//    func getTotalPrice(totalPrices:[PriceModel]) -> Double {
//        var total: Double = 0
//        for item  in totalPrices {
//            let item = item as PriceModel
//            total += item.price!
//        }
//     return total
//    }
    
}
