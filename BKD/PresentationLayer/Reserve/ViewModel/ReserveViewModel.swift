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

    ///Get additional accessoties list
    func getAdditionalAccessories(vehicleModel: VehicleModel) -> Array<Any>?  {
        var accessories:[AccessoriesEditModel]?
        if (vehicleModel.ifHasAccessories == true) {
            accessories = []
            let additionalAccessories: [AccessoriesEditModel]? = vehicleModel.additionalAccessories
            
            for i in (0..<Int(additionalAccessories!.count)) {
                let model: AccessoriesEditModel = additionalAccessories![i]
                if model.isAdded {
                    accessories?.append(model)
                }
            }
        }
        return accessories
    }
    
    
    ///Get additional drivers list
    func getAdditionalDrivers(vehicleModel:VehicleModel) -> [MyDriversModel]?  {
        
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
    
    
    ///Get accessories for add rent request
    func getAccessoriesToRequest(accessories: [AccessoriesEditModel]?) -> [[String : Any]?] {
        var accessoryArr: [[String : Any]?] = []
        accessories?.forEach({ accessory in
            if accessory.isAdded {
                let dic  = ["id" : accessory.id ?? "",
                            "count": accessory.count ?? 0] as [String : Any]
                accessoryArr.append(dic)
            }
        })
        return accessoryArr
    }
    
    ///Get accessories for add rent request
    func getAdditionalDriversToRequest(additionalDrivers: [MyDriversModel]?) -> [String?] {
        var driversArr: [String?] = []
        additionalDrivers?.forEach({ driver in
            driversArr.append(driver.driver?.id)
        })
        return driversArr
    }
    
    
    ///Get location for add rent request
    func getLocationToRequest(search: SearchModel,
                              isPickUpLocation: Bool) -> [String : Any] {
        
        //"var locationDic: [String : Any]?
        if isPickUpLocation {
            if search.isPickUpCustomLocation {
                return ["type": "CUSTOM",
                        "customLocation": [
                            "name": search.pickUpLocation ?? "",
                            "longitude": search.pickUpLocationLongitude ?? 0.0,
                            "latitude": search.pickUpLocationLatitude ?? 0.0
                                ]
                            ]
            } else {
                return ["type": "PARKING",
                        "parking": [
                            "id": search.pickUpLocationId ?? ""
                                ]
                            ]
            }
        } else {
            if search.isRetuCustomLocation {
                return ["type": "CUSTOM",
                                "customLocation": [
                                    "name": search.returnLocation ?? "",
                                    "longitude": search.returnLocationLongitude ?? 0.0,
                                    "latitude": search.returnLocationLatitude ?? 0.0
                                ]
                            ]
            } else {
                return ["type": "PARKING",
                        "parking": [
                            "id": search.returnLocationId ?? ""
                                ]
                            ]
            }
        }
    }
    
    ///Add Rent car
    func addRent(vehicleModel: VehicleModel,
                 completion: @escaping (Rent?, String?) -> Void) {
        
        let accessoriesArr = getAccessoriesToRequest(accessories: vehicleModel.additionalAccessories)
        let additionalDriversArr = getAdditionalDriversToRequest(additionalDrivers: vehicleModel.additionalDrivers)
        let pickupLocation = getLocationToRequest(search: vehicleModel.searchModel!, isPickUpLocation: true)
        let returnLocation = getLocationToRequest(search: vehicleModel.searchModel!, isPickUpLocation: false)

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addRent(carId: vehicleModel.vehicleId ?? "",
                                                                                  startDate: (vehicleModel.searchModel?.pickUpTime ?? Date()).timeIntervalSince1970,
                            endDate: (vehicleModel.searchModel?.returnTime ?? Date()).timeIntervalSince1970,
                            accessories: accessoriesArr,
                            additionalDrivers: additionalDriversArr,
                            pickupLocation: pickupLocation,
                            returnLocation: returnLocation))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<Rent>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.content as Any)
                completion(result.content, nil)

            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
        }
    }
   
}
