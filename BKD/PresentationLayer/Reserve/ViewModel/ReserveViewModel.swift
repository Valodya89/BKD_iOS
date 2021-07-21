//
//  ReserveViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

class ReserveViewModel: NSObject {
    private let keychain = KeychainManager()

    
    func isUserSignIn(completion: @escaping (Bool) -> Void) {
        completion(keychain.isUserLoggedIn())
    }

    func getAdditionalAccessories(vehicleModel:VehicleModel) -> Array<Any>?  {
        var accessories:[AccessoriesModel]?
        if (vehicleModel.ifHasAccessories == true) {
            accessories = []
            let additionalAccessories: [AccessoriesModel]? = vehicleModel.additionalAccessories
            
            for i in (0..<Int(additionalAccessories!.count)) {
                let model: AccessoriesModel = additionalAccessories![i]
                if model.isAdded {
                    accessories?.append(model)
                }
            }
        }
        return accessories
    }
    
    
    func getAdditionalDrivers(vehicleModel:VehicleModel) -> Array<Any>?  {
        var drivers:[MyDriversModel]?
        if (vehicleModel.ifHasAditionalDriver == true) {
            drivers = []
            let additionalDrivers: [MyDriversModel]? = vehicleModel.additionalDrivers
            
            for i in (0..<Int(additionalDrivers!.count)) {
                let model: MyDriversModel = additionalDrivers![i]
                if model.isSelected {
                    drivers?.append(model)
                }
            }
        }
        return drivers
    }
    
    func getPrices(vehicleModel:VehicleModel) -> Array<Any>? {
        var prices:[PriceModel] = []
       
        if vehicleModel.vehicleValue > 0.0 {
            prices.append(PriceModel(priceTitle: "Price", price: vehicleModel.vehicleValue))
        }
        if vehicleModel.vehicleOffertValue > 0.0 {
            prices.append(PriceModel(priceTitle: "Special offer", price: vehicleModel.vehicleOffertValue, discountPrecent: vehicleModel.vehicleDiscountValue))
        }
        if vehicleModel.noWorkingTimeTotalPrice > 0.0 {
            prices.append(PriceModel(priceTitle: "Additional service", price: vehicleModel.noWorkingTimeTotalPrice))
        }
        if vehicleModel.customLocationTotalPrice > 0.0 {
            prices.append(PriceModel(priceTitle: "Custom location", price: vehicleModel.customLocationTotalPrice))
        }
        if vehicleModel.accessoriesTotalPrice > 0.0 {
            prices.append(PriceModel(priceTitle: "Accessories", price: vehicleModel.accessoriesTotalPrice))
        }
        if vehicleModel.driversTotalPrice > 0.0 {
            prices.append(PriceModel(priceTitle: "Additional driver", price: vehicleModel.driversTotalPrice))
        }
        return prices
    }
    
    func getTotalPrice(totalPrices:[PriceModel]) -> Double {
        var total: Double = 0
        for item  in totalPrices {
            let item = item as PriceModel
            total += item.price!
        }
     return total
    }
}
