//
//  MyAccountsDriversViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-12-21.
//

import UIKit

final class MyAccountsDriversViewModel {
    
    ///Get active drivers list
    func getActiveDrivers(drivers: [MainDriver]) -> [MainDriver] {
        var activeDriver: [MainDriver] = []
        for driver in drivers {
            if driver.state == Constant.Texts.state_agree || driver.state == Constant.Texts.state_accepted {
                activeDriver.append(driver)
            }
        }
        return activeDriver
    }
    
    
    ///Get main driver
    func deleteDriver(id: String,
                      completion: @escaping (SignUpStatus) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.deleteDriver(id: id))) { (result) in

            switch result {
            case .success(let data):
                guard let response = BkdConverter<EmptyModel>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.error)
                    return
                }
                print(response)
                completion(.success)
            case .failure(let error):
                print(error.description)
                completion(.error)
                break
            }
        }
    }
}
