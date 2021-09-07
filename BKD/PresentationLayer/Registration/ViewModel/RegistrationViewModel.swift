//
//  RegistrationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-07-21.
//

import UIKit
struct EmptyModel: Decodable {
}
enum SignUpStatus: String, CaseIterable {
    case accountExist = "ACCOUNTS_user_already_exists"
    case accountNoSuchUser = "ACCOUNTS_no_such_user"
    case wrongVerifvCode = "ACCOUNTS_wrong_verification_code"
    case success = "SUCCESS"
    case error = "error"
    
}

class RegistrationViewModel: NSObject {
    let validator = Validator()

    
    ///Checking is all fields are filled
    func areFieldsFilled(email: String?,
                      password: String?,
                  confirmpassword: String?,
                        didResult: @escaping (Bool) -> ()) {
        didResult(validator.areFieldsFilled(email: email, password: password, confirmpassword: confirmpassword))
            
    }
    
    /// Get phone format for tetxtFiled placeholder
    func getPhonePlaceholder(format: String) -> String {
//        let str = format.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        
         let placeholder = format.replacingOccurrences(of: "#", with: "-", options: .literal, range: nil)
        return placeholder
         
    }
    
    
    ///sign up
    func signUp(username: String, password: String, completion: @escaping (SignUpStatus) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.signUp(username: username, password: password))) { (result) in
            
            switch result {
            case .success(let data):
                guard let signUp = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(signUp.message as Any)
                completion(SignUpStatus(rawValue: signUp.message)!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    
}


