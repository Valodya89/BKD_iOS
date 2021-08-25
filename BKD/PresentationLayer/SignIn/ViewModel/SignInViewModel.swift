//
//  SignInViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-07-21.
//

import UIKit

final class SignInViewModel {
    private let validator = Validator()
    private let network = SessionNetwork()
    private let keychainManager = KeychainManager()
    
    ///Checking is all fields are filled
    func areFieldsFilled(firtStr: String?, secondStr: String?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.areFieldsFilled(firstStr: firtStr, secondStr: secondStr))
    }
    
    ///sign in
    func signIn(username: String, password: String, completion: @escaping (SignUpStatus) -> Void) {
        network.request(with: URLBuilder(from: AuthAPI.getToken(username: username, password: password))) { (result) in

            switch result {
            case .success(let data):
                guard let tokenResponse = BkdConverter<TokenResponse>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.error)
                    return
                }
                print(tokenResponse)
                self.keychainManager.parse(from: tokenResponse)
                completion(.success)
            case .failure(let error):
                print(error.description)
                completion(.error)
                break
            }
        }
    }
    
    ///send email for restore password
    func forgotPassword(username: String, action: String, completion: @escaping (SignUpStatus) -> Void) {
        network.request(with: URLBuilder.init(from: AuthAPI.forgotPassword(username: username, action: action))) { (result) in
            
            switch result {
            case .success(let data):
                guard let forgotPassword = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(SignUpStatus(rawValue: "error")!)

                    return
                }
                print(forgotPassword.message as Any)
                completion(SignUpStatus(rawValue: forgotPassword.message)!)
            case .failure(let error):
                print(error.description)
                completion(SignUpStatus(rawValue: "error")!)
                break
            }
        }
    }
    
    ///send change password request
    func changePassword(username: String, password: String, code: String, completion: @escaping (SignUpStatus) -> Void) {
        network.request(with: URLBuilder.init(from: AuthAPI.recoverPassword(username: username, password: password, code: code))) { (result) in
            
            switch result {
            case .success(let data):
                guard let changePassword = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(SignUpStatus(rawValue: "error")!)

                    return
                }
                print(changePassword.message as Any)
                completion(SignUpStatus(rawValue: changePassword.message)!)
            case .failure(let error):
                print(error.description)
                completion(SignUpStatus(rawValue: "error")!)
                break
            }
        }
    }

}
