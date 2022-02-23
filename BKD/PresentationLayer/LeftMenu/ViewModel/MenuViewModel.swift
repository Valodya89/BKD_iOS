//
//  MenuViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-01-22.
//

import Foundation

final class MenuViewModel {
    
    
    ///Get language list
    func getLanguages(completion: @escaping ([Language]?) -> Void) {
        SessionNetwork().request(with: URLBuilder(from: AuthAPI.getLanguage)) { (result) in

            switch result {
            case .success(let data):
                guard let language = BkdConverter<BaseResponseModel<[Language]>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                completion(language.content!)
            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    
//    ///Update language
//    func updateLanguages(id: String, completion: @escaping (Language?) -> Void) {
//        SessionNetwork().request(with: URLBuilder(from: AuthAPI.updateLanguage(id: id))) { (result) in
//
//            switch result {
//            case .success(let data):
//                guard let language = BkdConverter<BaseResponseModel<Language>>.parseJson(data: data as Any) else {
//                    print("error")
//                    completion(nil)
//                    return
//                }
//                completion(language.content!)
//            case .failure(let error):
//                print(error.description)
//                completion(nil)
//                break
//            }
//        }
//    }
}
