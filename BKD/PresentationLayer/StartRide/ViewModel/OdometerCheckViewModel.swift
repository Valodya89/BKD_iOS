//
//  OdometerCheckViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-12-21.
//

import UIKit

final class OdomoeterCheckViewModel {
    
    ///Add odometer
    func addOdometer(image: UIImage,
                      id: String,
                   value: String,
                     completion: @escaping (Rent?, String?) -> Void)  {
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addOdometer(image: resizeImg, id: id, value: value))) { result in
            
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
        
    ///Check Odometer
    func checkOdometer(id: String,
                     completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.checkOdometer(id: id))) { result in
            
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
    
    ///Start Ride
    func startRide(id: String,
                completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.start(id: id))) { result in
            
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
