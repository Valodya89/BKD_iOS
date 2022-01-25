//
//  EditReservetionAdvancedViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-01-22.
//

import Foundation

final class EditReservetionAdvancedViewModel {
    
    ///Get edited reservation accessories list
    func getEditedAccessories(editAccessories: [EditAccessory]) -> [AccessoriesEditModel]? {
        
        return AccessoriesEditModel().getEditedAccessories(editAccessories: editAccessories)
        
    }
    
    ///Get additional drivers to update rent request
    func getAdditionalDriversToRequest(additionalDrivers: [DriverToRent]?) -> [String?] {

        var additionalDriverArr: [String?] = []
        additionalDrivers?.forEach({ driver in
            additionalDriverArr.append(driver.id)
        })
        return additionalDriverArr
    }
    
    ///Get accessories for add rent request
    func getAccessoriesToRequest(accessories: [EditAccessory]?) -> [[String : Any]?] {
        var accessoryArr: [[String : Any]?] = []
        accessories?.forEach({ accessory in
            let dic  = ["id" : accessory.id,
                        "count": accessory.count] as [String : Any]
            accessoryArr.append(dic)
        })
        return accessoryArr
    }
    
    ///Add Rent car
    func updateRent(rentId: String,
                    editReservationModel: EditReservationModel,
                    searchModel: SearchModel,
                    completion: @escaping (Rent?) -> Void) {
        
//        let endDate = (Date().combineDate(date: searchModel.returnDate ?? Date(), withTime: searchModel.returnTime ?? Date())
//        )!.timeIntervalSince1970
        
        let reserveVM = ReserveViewModel()
        let accessoriesArr = getAccessoriesToRequest(accessories: editReservationModel.accessories)
        let additionalDriversArr = getAdditionalDriversToRequest(additionalDrivers: editReservationModel.additionalDrivers)
        let pickupLocation = reserveVM.getLocationToRequest(search: searchModel, isPickUpLocation: true)
        let returnLocation = reserveVM.getLocationToRequest(search: searchModel, isPickUpLocation: false)
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.updateRent(rentId: rentId, carId: editReservationModel.carId ?? "", startDate: editReservationModel.startDate ?? 0.0, endDate: editReservationModel.endDate ?? 0.0, accessories: accessoriesArr, additionalDrivers: additionalDriversArr, pickupLocation: pickupLocation, returnLocation: returnLocation))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<Rent>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
}
