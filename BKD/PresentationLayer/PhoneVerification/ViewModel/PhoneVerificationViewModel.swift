//
//  PhoneVerificationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-11-21.
//

import Foundation

final class PhoneVerificationViewModel {
    
    
    ///Send phone number verification
    func verifyPhoneNumber(phoneCode: String, number: String,
                           code: String, completion: @escaping (PhoneVerify?, String?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.verifyPhoneCode(phoneCode: phoneCode, phoneNumber: number, code: code))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<PhoneVerify>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.content as Any)
                completion(result.content, nil)

            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
        }
    }
        
}
