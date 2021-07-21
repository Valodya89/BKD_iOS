//
//  SignInViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-07-21.
//

import UIKit

class SignInViewModel: UIView {
    let validator = Validator()

    
    ///Checking is all fields are filled
    func areFieldsFilled(firtStr: String?, secondStr: String?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.areFieldsFilled(firstStr: firtStr, secondStr: secondStr))
    }
    
    ///sign in
    func signIn(username: String, password: String, completion: @escaping (SignUpStatus) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getToken(username: username, password: password))) { (result) in
            
            switch result {
            case .success(let data):
                guard let signIn = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(SignUpStatus(rawValue: "error")!)

                    return
                }
                print(signIn.message as Any)
                completion(SignUpStatus(rawValue: signIn.message)!)
            case .failure(let error):
                print(error.description)
                completion(SignUpStatus(rawValue: "error")!)
                break
            }
        }
    }

}
