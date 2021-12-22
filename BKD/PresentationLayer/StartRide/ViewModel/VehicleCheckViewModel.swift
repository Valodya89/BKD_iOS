//
//  VehicleCheckViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-12-21.
//

import UIKit


final class VehicleCheckViewModel {
    
    ///Send Defect to datebase
    func addDefect(image: UIImage,
                      id: String,
                   state: String,
                   description: String,
                     completion: @escaping (Rent?, String?) -> Void)  {
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addDefect(image: resizeImg, id: id, state: state, description: description))) { result in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<Rent>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
            
        }
    }
    
    
    ///Send Defect to datebase
    func defectCheck(id: String,
                     completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.checkDefect(id: id))) { result in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<Rent>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
            
        }
    }
}
