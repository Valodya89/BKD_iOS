//
//  ReserveViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

class ReserveViewModel: NSObject {

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
}
