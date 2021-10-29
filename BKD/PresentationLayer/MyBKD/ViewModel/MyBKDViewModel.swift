//
//  MyBKDViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit

final class MyBKDViewModel: NSObject {
    private let keychainManager = KeychainManager()
    private let network = SessionNetwork()

    var isUserSignIn: Bool {
        return keychainManager.isUserLoggedIn()
    }
    
    func logout() {
        keychainManager.removeData()
    }
    
    ///Get main driver
    func getMainDriver(completion: @escaping (MainDriver?) -> Void) {
        network.request(with: URLBuilder(from: AuthAPI.getMainDriver)) { (result) in

            switch result {
            case .success(let data):
                guard let mainDriver = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                completion(mainDriver.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
}
