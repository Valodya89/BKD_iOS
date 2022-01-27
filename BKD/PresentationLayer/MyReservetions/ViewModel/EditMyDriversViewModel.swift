//
//  EditMyDriversViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-01-22.
//

import Foundation

final class EditMyDriversViewModel {
    
    ///Get edit rent drivers  list
    func getDriversEditList(rent: Rent?, drivers: [MyDriversModel]) -> (additionalDrivers: [MyDriversModel]?, totalPrice: Double) {
        
        guard let rentDrivers = rent?.additionalDrivers else {return (nil, 0.0)}
        var additionalDrivers:[MyDriversModel] = []
        var totalPrice = 0.0
        
        drivers.forEach { driver in
            if rentDrivers.count > 0 {
                
                let rentDriver = rentDrivers.filter { $0.id == driver.driver?.id ?? ""}.first
                
                if rentDriver == nil {
                    additionalDrivers.append(driver)
                } else {
                    totalPrice += driverPrice
                    let driverEdit = MyDriversModel(fullname: driver.fullname,
                                                    licenciNumber: driver.licenciNumber,
                                                    price: driverPrice, isSelected: true,
                                                    isWaitingForAdmin: false,
                                                    totalPrice: 0.0,
                                                    driver: driver.driver)
                    additionalDrivers.append(driverEdit)
                }
                
        } else {
            
            additionalDrivers = drivers
        }
    }
        return (additionalDrivers, totalPrice)
    }
    
    
    ///Edit reservation driver
    func editReservationDrivers(isSelected: Bool,
                                editDriver: MyDriversModel,
                                editReservationDrivers: [DriverToRent], completion: @escaping (([DriverToRent]) -> Void)) {
        var editList = editReservationDrivers
        if isSelected {
            editList.append(DriverToRent(id: editDriver.driver?.id ?? "",
                                       name: editDriver.driver?.name,
                                       surname: editDriver.driver?.surname,
                                       drivingLicenseNumber: editDriver.licenciNumber))
            completion(editList)
        } else {
            for i in 0 ..< editList.count  {
                if (editDriver.driver?.id ?? "") == editList[i].id {
                    editList.remove(at: i)
                    completion(editList)
                    return
                }
            }
        }
        completion(editList)
    }
    
    
    ///Is enabled cell
    func isEnabledCell(editedDrivers: [DriverToRent]?, currItem: MyDriversModel) -> Bool {
        let item = editedDrivers?.filter({$0.id == currItem.driver?.id}).first
        guard item != nil else {return true}
        return false
    }
    
    
}
