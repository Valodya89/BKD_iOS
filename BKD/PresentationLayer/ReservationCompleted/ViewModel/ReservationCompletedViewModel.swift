//
//  ReservationCompletedViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-11-21.
//

import Foundation

enum PayLaterStatus: String, CaseIterable {
    case countLimited = "ACCOUNTS_pay_later_count_limit"
    case success = "SUCCESS"
    case error = "error"
    
}

final class ReservationCompletedViewModel {
    
    ///Pay later
    func payLater(completion: @escaping (PayLaterStatus) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.payLater)) { (result) in
                
                switch result {
                case .success(let data):
                    guard let result = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                        print("error")
                        return
                    }
                    print(result.message as Any)
                    completion(PayLaterStatus(rawValue: result.message)!)

                case .failure(let error):
                    print(error.description)
                   // completion(nil, error.description)
                    
                    break
                }
            }
        }
        
    
}

/*
"timestamp": "2021-11-30T17:40:11.690+00:00",
    "statusCode": 403,
    "status": "FORBIDDEN",
    "message": "ACCOUNTS_pay_later_count_limit",
    "path": "/api/driver/pay-later",
    "content": null
*/
