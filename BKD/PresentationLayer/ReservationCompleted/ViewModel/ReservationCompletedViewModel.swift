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
    func payLater(completion: @escaping (PayLaterStatus, ReservationCompleted?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.payLater)) { (result) in
                
                switch result {
                case .success(let data):
                    guard let result = BkdConverter<BaseResponseModel<ReservationCompleted>>.parseJson(data: data as Any) else {
                        print("error")
                        completion(.error, nil)
                        return
                    }
                    print(result.message as Any)
                    completion(PayLaterStatus(rawValue: result.message)!, result.content)

                case .failure(let error):
                    print(error.description)
                    completion(.error, nil)
                    
                    break
                }
            }
        }

    ///get free  reservatuon massage
    func getFreeReservationMessage(payLaterCount: Double) -> String {
//        if payLaterCount == 1 {
//            return String(format: Constant.Texts.payAlert, "is", payLaterCount, Constant.Texts.cancellation )
//        } else if payLaterCount > 1 {
//            return String(format: Constant.Texts.payAlert, "are", payLaterCount, Constant.Texts.cancellations )
//        }
        return String(format: Constant.Texts.payAlert, payLaterCount )
        return ""
    }
    
    
}







/*
"timestamp": "2021-11-30T17:40:11.690+00:00",
    "statusCode": 403,
    "status": "FORBIDDEN",
    "message": "ACCOUNTS_pay_later_count_limit",
    "path": "/api/driver/pay-later",
    "content": null
 
 
 
 
 
 "content": {
        "id": "61a6286b5dd2c53e330a65eb",
        "payLaterCount": 1,
        "state": "AGREEMENT_ACCEPTED",
        "type": "MAIN",
        "userId": "61a6286b5dd2c53e330a65eb",
        "name": "test",
        "surname": "Test",
        "phoneNumber": "+37494 63-32-68",
        "dateOfBirth": "2021-01-30T00:11:00.000+00:00",
        "street": "test",
        "house": "84",
        "mailBox": "",
        "countryId": "60e30c6e89bf4b6b024559a1",
        "zip": "33",
        "city": "Gyumri",
        "nationalRegisterNumber": "ap4545445",
        "identityExpirationDate": "2021-01-30T00:11:00.000+00:00",
        "identityFront": {
            "id": "14122AFE1F760709174A3F2B166B05AB6481255D6FCE1FD0CD08846B36D956F946803BEC30FF661B2BC96794998A9109",
            "node": "dev-node1"
        },
        "identityBack": {
            "id": "14122AFE1F760709174A3F2B166B05AB6481255D6FCE1FD0CD08846B36D956F91477FD24D0A050035416335F8B3A76ED",
            "node": "dev-node1"
        },
        "drivingLicenseIssueDate": "2021-11-30T00:00:00.000+00:00",
        "drivingLicenseExpirationDate": "2023-11-30T00:00:00.000+00:00",
        "drivingLicenseNumber": "54455",
        "drivingLicenseFront": {
            "id": "14122AFE1F760709174A3F2B166B05AB6481255D6FCE1FD0CD08846B36D956F9D481B66FFABDF2C43C0A62A30E61CA89",
            "node": "dev-node1"
        },
        "drivingLicenseBack": {
            "id": "14122AFE1F760709174A3F2B166B05AB6481255D6FCE1FD0CD08846B36D956F9F80A3DA21656BE549D6734429B6E074F",
            "node": "dev-node1"
        },
        "drivingLicenseSelfie": {
            "id": "14122AFE1F760709174A3F2B166B05AB6481255D6FCE1FD0CD08846B36D956F9BFC503621C68A88B2A296FA165C605B3",
            "node": "dev-node1"
        },
        "agreementApplied": true,
        "agreementAppliedAt": 1638284230874
    }
}
*/


