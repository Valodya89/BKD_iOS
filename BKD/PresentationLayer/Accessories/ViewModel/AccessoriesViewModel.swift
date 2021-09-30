//
//  AccessoriesViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-06-21.
//

import UIKit

class AccessoriesViewModel: NSObject {
    
    func getTotalAccesories(accessoryPrice: Double,
                              totalPrice: Double,
                              isIncrease: Bool,
                              didResult: @escaping (String) -> ()) {
        var value: Double = 0.0
        if isIncrease {
            value = totalPrice + accessoryPrice
        } else {
            value = totalPrice - accessoryPrice
        }
       // let newValue = String(value).replacingOccurrences(of: ".", with: ",")

        didResult(String(value))
    }
    
    /// get accessories  list
     func getAccessories(carID: String, completion: @escaping ([Accessories]?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAccessories(carID: carID))) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let accessories = BkdConverter<BaseResponseModel<[Accessories]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                completion(accessories.content)
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
}
