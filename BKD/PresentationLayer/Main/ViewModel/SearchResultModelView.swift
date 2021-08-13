//
//  SearchResultModelView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit



class SearchResultModelView: NSObject {
    var searchResultModelView = SearchResultModelView()
    
    
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
