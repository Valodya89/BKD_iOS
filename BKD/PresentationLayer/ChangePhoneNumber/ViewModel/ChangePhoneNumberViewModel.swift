//
//  ChangePhoneNumberViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-11-21.
//

import Foundation
import SwiftUI

final class ChangePhoneNumberViewModel {
    
    private var keychainManager = KeychainManager()

    ///Get phone number
    func getPhoneNumber() -> String? {
       return keychainManager.getPhoneNumber()
    }
    
    ///Get phone code
    func getPhoneCode() -> PhoneCode? {
        let phoneCodeId = keychainManager.getPhoneCodeId()
        let phoneCodesList = ApplicationSettings.shared.phoneCodes
        var phoneCode: PhoneCode?
        phoneCodesList?.forEach({ element in
            if element.id == phoneCodeId {
                phoneCode = element
                
            }
        })
       return phoneCode
    }
    
    
    ///Send Phone verify code sms
    func sendCodeSms(phoneCode: String,
                     phoneNumber: String,
                     completion: @escaping (PhoneVerify?, String?) -> Void) {
        
        var number = phoneNumber.replacingOccurrences(of: " ", with: "")
        number = number.replacingOccurrences(of: "-", with: "")
        number = number.replacingOccurrences(of: "_", with: "")

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.sendCodeSms(phoneCode: phoneCode, phoneNumber: number))) { (result) in
            
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
