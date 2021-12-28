//
//  StopRideViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-12-21.
//

import Foundation
import UIKit

final class StopRideViewModel {
    
    ///Add defects to finish
    func addDefectToFinish(image: UIImage,
                      id: String,
                     completion: @escaping (Rent?, String?) -> Void)  {
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addDefectToFinish(image: resizeImg, id: id, description: ""))) { result in
            
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
    
    
    ///Check Defect to finish
    func defectCheckToFinish(id: String,
                     completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.checkDefectToFinish(id: id))) { result in
            
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
    
    
    ///Add odometer to finish
    func addOdometerToFinish(image: UIImage,
                             id: String,
                             description: String,
                     completion: @escaping (Rent?, String?) -> Void)  {
        
        let resizeImg = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.addOdometerToFinish(image: resizeImg, id: id, description: description))) { result in
            
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
    
    ///Check stop ride Odometer
    func checkOdometerToFinish(id: String,
                     completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.checkOdometerToFinish(id: id))) { result in
            
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
    
    ///Finish Ride
    func finishRide(id: String,
                completion: @escaping (Rent?, String?) -> Void)  {

        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.finish(id: id))) { result in
            
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
