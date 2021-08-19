//
//  SearchResultModelView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit



class SearchResultModelView: NSObject {    
    
        /// Get filtering cars list
        func getExteriorSizes(completion: @escaping ([Exterior]) -> Void) {
            
            SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getExteriorSize)) { (result) in
    
                switch result {
                case .success(let data):
                    guard let exteriorList = BkdConverter<BaseResponseModel<[Exterior]>>.parseJson(data: data as Any) else {
                        print("error")
                        return
                    }
                    print(exteriorList.content as Any)
                    completion(exteriorList.content!)
                case .failure(let error):
                    print(error.description)
                    break
                }
            }
        }
    
    ///Chack if car is available for rent
    func isCarAvailable(start:Date?,
                        end:Date?,
                        rentStart:Date?,
                        rendEnd:Date?) -> Bool {
        guard let _ = start, let _ = end, let _ = rentStart,let _ = rendEnd   else {
            return true
        }
        let startResult = rentStart!.isBetween(start: start!, end: end!)
        let endResult = rendEnd!.isBetween(start: start!, end: end!)
        let result = startResult || endResult
        return !result
    }
    
//    /// Get filtering cars list
//    func getFilterCars(fieldName: String,
//                        fieldValue:String,
//                        operation: String,
//                        completion: @escaping ([CarsModel]) -> Void) {
//        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarsByType(fieldName: fieldName,
//                                                                                        fieldValue: fieldValue,
//                                                                                        searchOperation: operation))) { (result) in
//            
//            switch result {
//            case .success(let data):
//                guard let carList = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
//                    print("error")
//                    return
//                }
//                print(carList.content as Any)
//                completion(carList.content!)
//            case .failure(let error):
//                print(error.description)
//                break
//            }
//        }
//    }
    
    
}
