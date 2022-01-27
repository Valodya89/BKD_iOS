//
//  MyDriversViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-11-21.
//

import UIKit
import SwiftUI

class MyDriversViewModel: NSObject {
    
    ///Get driver list
    func getMyDrivers(completion: @escaping ([MainDriver]?, String?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAdditionalDrivers)) { (result) in
            
            switch result {
            case .success(let data):
                guard let myDriver = BkdConverter<BaseResponseModel<[MainDriver]>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil,nil)
                    return
                }
                print(myDriver.message as Any)
                completion(myDriver.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)

                break
            }
        }
    }
    
   
    ///Set additional driver list
    func setActiveDriverList(allDrivers: [MainDriver]) -> [MyDriversModel] {
        var  myDriverList: [MyDriversModel] = []
        allDrivers.forEach { driver in
            if driver.state == Constant.Texts.state_agree {
                let myDriverModel = MyDriversModel(fullname: driver.getFullname(),
                                    licenciNumber: driver.drivingLicenseNumber ?? "",
                                    price: 0.0,
                                    isWaitingForAdmin: true,
                                    driver: driver)
                myDriverList.append(myDriverModel)
            } else if driver.state == Constant.Texts.state_accepted {
                let myDriverModel = MyDriversModel(fullname: driver.getFullname(),
                                  licenciNumber: driver.drivingLicenseNumber ?? "",
                                   price: 0.0,
                                   isWaitingForAdmin: false,
                                   driver: driver)
                myDriverList.append(myDriverModel)
            }
        }
        print (myDriverList)
       return myDriverList
    }
    
    ///Get driver which will continue to fill
    func getDriverToContinueToFill(allDrivers: [MainDriver], completion: @escaping (MainDriver?) -> Void){
        for currDriver in allDrivers {
            if currDriver.state != Constant.Texts.state_agree && currDriver.state != Constant.Texts.state_accepted {
                
                completion(currDriver)
                break
            }
        }
        completion(nil)
    }
   
    ///Get edit driver list
    func getEditDrivers(drivers: [MyDriversModel]?) -> [DriverToRent] {
        var editList:[DriverToRent] = []
        drivers?.forEach({ driver in
            if driver.isSelected {
                editList.append(DriverToRent(id: driver.driver?.id ?? "",
                                           name: driver.driver?.name ?? "",
                                           surname: driver.driver?.surname ?? "",
                                           drivingLicenseNumber: driver.driver?.drivingLicenseNumber ?? ""))
            }
        })
        return editList
    }
    

   
    
    
    ///Is edited additional driversn to reservation
    func isEdietedDriverList(oldDrivers: [DriverToRent],
                             editedDrivers: [DriverToRent]) -> Bool {
        
        return editedDrivers.count != oldDrivers.count
    }
    
    ///Count total price of selected drivers
    func countTotalPrice(additionalDrivers: [MyDriversModel]?, price: Double) -> Double {
        
        var total = 0.0
        additionalDrivers?.forEach({ driver in
            if driver.isSelected {
                total += price
            }
        })
        return total
    }
    
}
