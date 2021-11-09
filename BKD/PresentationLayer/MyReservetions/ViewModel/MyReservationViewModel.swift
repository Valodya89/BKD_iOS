//
//  MyReservationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-11-21.
//

import UIKit

class MyReservationViewModel: NSObject {
    
    
    ///Get car´s reservations
    func getReservations( completion: @escaping (Rent?) -> Void) {

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getRents)) { (result) in
            
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
