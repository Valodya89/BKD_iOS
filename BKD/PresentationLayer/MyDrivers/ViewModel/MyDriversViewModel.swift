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
        allDrivers.forEach { currDriver in
            if currDriver.state != Constant.Texts.state_agree && currDriver.state != Constant.Texts.state_accepted && currDriver.state != Constant.Texts.state_created  {
                
                completion(currDriver)
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
    
    ///Get edit rent drivers  list
    func getDriversEditList(rent: Rent?, drivers: [MainDriver]) -> (additionalDrivers: [MyDriversModel]?, totalPrice: Double) {
        
        guard let rentDrivers = rent?.additionalDrivers else {return (nil, 0.0)}
        var additionalDrivers:[MyDriversModel] = []
        var totalPrice = 0.0
        
        drivers.forEach { driver in
            if rentDrivers.count > 0 {
            rentDrivers.forEach { rentDrivers in
                
                if driver.id == rentDrivers.id {
                        totalPrice += driverPrice
                    let driverEdit = MyDriversModel(fullname: driver.getFullname(),
                                                    licenciNumber: driver.drivingLicenseNumber ?? "",
                                                    price: driverPrice, isSelected: true,
                                                    isWaitingForAdmin: false,
                                                    totalPrice: 0.0,
                                                    driver: driver)
                    additionalDrivers.append(driverEdit)
                } else {
                    
                    if driver.state == Constant.Texts.state_agree {
                        let myDriverModel = MyDriversModel(fullname: driver.getFullname(),
                                            licenciNumber: driver.drivingLicenseNumber ?? "",
                                            price: 0.0,
                                            isWaitingForAdmin: true,
                                            driver: driver)
                        additionalDrivers.append(myDriverModel)
                    } else if driver.state == Constant.Texts.state_accepted {
                        let myDriverModel = MyDriversModel(fullname: driver.getFullname(),
                                          licenciNumber: driver.drivingLicenseNumber ?? "",
                                           price: 0.0,
                                           isWaitingForAdmin: false,
                                           driver: driver)
                        additionalDrivers.append(myDriverModel)
                    }
                    
                }
            }
        } else {
            
            additionalDrivers = setActiveDriverList(allDrivers: drivers)
            
        }
        }
        return (additionalDrivers, totalPrice)
    }
    
    
    ///Edit reservation driver
    func editReservationDrivers(isSelected: Bool,
                                editDriver: MyDriversModel,
                                editReservationDrivers: [DriverToRent]) -> [DriverToRent] {
        var editList = editReservationDrivers
        if isSelected {
            editList.append(DriverToRent(id: editDriver.driver?.id ?? "",
                                       name: editDriver.driver?.name,
                                       surname: editDriver.driver?.surname,
                                       drivingLicenseNumber: editDriver.licenciNumber))
            return editList
        } else {
            for i in 0 ..< editList.count  {
                if (editDriver.driver?.id ?? "") == editList[i].id {
                    editList.remove(at: i)
                    return editList
                }
            }
        }
        return editList
    }
    
    
    ///Is edited additional driversn to reservation
    func isEdietedDriverList(isSelected: Bool,
                             oldDrivers: [DriverToRent],
                             editedDriver: MyDriversModel,
                             editedDrivers: [DriverToRent]) -> Bool {
        if isSelected {
            guard let _ = oldDrivers.filter({$0.id == (editedDriver.driver?.id ?? "")}).first else {
                return true
            }
            return false
        } else {
            if editedDrivers.count != oldDrivers.count {
                return true
            } else {
                
            }
            
            return false
        }
    }
    
}
