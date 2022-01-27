//
//  EditedPriceManager.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-01-22.
//

import UIKit

final class EditedPriceManager {
    static let shared = EditedPriceManager()
    
    var pickUpCustomLocationPrice: Double?
    var returnCustomLocationPrice: Double?
    var pickUpNoWorkingTimePrice: Double?
    var returnNoWorkingTimePrice: Double?
    var carPrice: Double?
    var carOffertPrice: Double?
    var carDiscountPrecent: Double?
    var accessoriesPrice: Double?
    var additionalDriversPrice: Double?
    var totalPrice: Double?

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
        if totalNoWorkibngTotal > 0 {
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
        self.totalPrice = total
        
     return total
    }
    
    
}

