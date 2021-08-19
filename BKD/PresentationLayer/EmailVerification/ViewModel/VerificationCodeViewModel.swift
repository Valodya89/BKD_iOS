//
//  VerificationCodeViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit

class VerificationCodeViewModel: NSObject {

    ///Put verification code
    func putVerification(username: String, code: String, completion: @escaping (SignUpStatus) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.verifyAccounts(username: username, code: code))) { (result) in
            
            switch result {
            case .success(let data):
                guard let verification = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(SignUpStatus(rawValue: "error")!)
                    return
                }
                if verification.message != "SUCCESS" {
                    completion(SignUpStatus(rawValue: "error")!)
                } else {
                    print(verification.message as Any)
                    completion(SignUpStatus(rawValue: verification.message)!)
                }
               
            case .failure(let error):
                print(error.description)
                completion(SignUpStatus(rawValue: "error")!)
                break
            }
        }
    }
    
    
    ///Resend verification code to  user email
    func resendVerificationCode(username: String, completion: @escaping (SignUpStatus) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.resendCode(username: username))) { (result) in
            
            switch result {
            case .success(let data):
                guard let resendCode = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(SignUpStatus(rawValue: "error")!)
                    return
                }
                print(resendCode.message as Any)
                completion(SignUpStatus(rawValue: resendCode.message)!)
            case .failure(let error):
                print(error.description)
                completion(SignUpStatus(rawValue: "error")!)
                break
            }
        }
    }
    
   
}
