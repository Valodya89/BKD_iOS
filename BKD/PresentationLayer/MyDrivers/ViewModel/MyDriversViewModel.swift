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
    func getMyDrivers(completion: @escaping ([MainDriver]?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAdditionalDrivers)) { (result) in
            
            switch result {
            case .success(let data):
                guard let myDriver = BkdConverter<BaseResponseModel<[MainDriver]>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(myDriver.message as Any)
                completion(myDriver.content)
            case .failure(let error):
                print(error.description)
                completion(nil)

                break
            }
        }
    }
    
   
    ///Set additional driver list
    func setActiveDriverList(allDrivers: [MainDriver])-> [MyDriversModel] {
        var  myDriverList: [MyDriversModel] = []
        allDrivers.forEach { driver in
            if driver.state == Constant.Texts.state_agree {
                let myDriverModel = MyDriversModel(fullname: driver.name! + " " + driver.surname!,
                                                   licenciNumber: "XX",
                                                   price: 0.0,
                                                   isWaitingForAdmin: true,
                                                   driver: driver)
                myDriverList.append(myDriverModel)
            } else if driver.state == Constant.Texts.state_accepted {
                let myDriverModel = MyDriversModel(fullname: driver.name! + " " + driver.surname!,
                                                   licenciNumber: "XX",
                                                   price: 0.0,
                                                   isWaitingForAdmin: false,
                                                   driver: driver)
                myDriverList.append(myDriverModel)
            }
        }
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
}
