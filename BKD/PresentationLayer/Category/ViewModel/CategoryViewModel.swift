//
//  CategoryViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-08-21.
//

import UIKit

class CategoryViewModel: NSObject {
    let dispatchGroup = DispatchGroup()

    var carsListByTipe:[String : [CarsModel]] = [ : ]
    /// get cars list by car type
    func getCarsByTypes( carTypes: [CarTypes],
                        completion: @escaping ([String : [CarsModel]]?) -> Void) {
        
            for i in 0 ..< carTypes.count {
                dispatchGroup.enter()

                    let criteria = ["fieldName": "type",
                                    "fieldValue": carTypes[i].id,
                                    "searchOperation" : SearchOperation.equals.rawValue ] as [String : Any]
                SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarsByType(criteria: criteria))) { [self] (result) in
                        
                        switch result {
                        case .success(let data):
                            guard let carList = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
                                print("error")
                                dispatchGroup.leave()
                                return
                            }
                            print(carList.content as Any)
                            carsListByTipe.updateValue(carList.content!, forKey: carTypes[i].id)
                            dispatchGroup.leave()
                        case .failure(let error):
                            print(error.description)
                            dispatchGroup.leave()
                            break
                        }
                    }


            }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: { [self] in
            completion(self.carsListByTipe)
               print("Finished all requests.")
           })
    }
    
    ///Get vehicle model
    func getVehicleModel(car: CarsModel, carType: String) -> VehicleModel {
        var vehicle = VehicleModel()
        vehicle.setVehicle(car: car)
        vehicle.vehicleType = carType
        return vehicle
    }

}
