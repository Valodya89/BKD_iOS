//
//  SearchHeaderViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

class SearchHeaderViewModel: NSObject {
    //static let shared = MainViewModel()
    var searchDateModel = SearchDateModel()

    let validator = Validator()
    
    override init() {}
    
    //MARK: VALIDATIONS
    //MARK: -----------------------
    func  isFieldsFilled(pickUpDay: String?,
                         returnDay: String?,
                         pickUpTime: String?,
                         returnTime: String?,
                         pickUpLocation: String?,
                         returnLocation: String?,
                         didResult: @escaping ([ValidationType]) -> ()) {
       let searchDateModel = SearchDateModel (pickUpDay: pickUpDay,
                                           returnDay: returnDay,
                                           pickUpTime: pickUpTime,
                                           returnTime: returnTime,
                                           pickUpLocation: pickUpLocation,
                                           returnLocation: returnLocation)
        didResult(validator.checkSearchDatas(searchDateModel: searchDateModel))
    }
    
    func getCustomLocationTotalPrice(searchV: SearchHeaderView) -> Double {
        var total: Double = 0.0
        if LocationPickUp.pickUpCustomLocation == searchV.locationPickUp {
            total += customLocationPrice
         }
         if LocationReturn.returnCustomLocation == searchV.locationReturn {
            total += customLocationPrice
          }
        return total
    }
    
    
    /// get avalable time list
    func getAvalableTimeList(completion: @escaping ([String]?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAvailableTimeList)) { (result) in
            
            switch result {
            case .success(let data):
                guard let timesList = BkdConverter<BaseResponseModel<[TimeModel]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
            
                }
                
                print(timesList.content)

                completion(self.getTimeList(model: timesList.content!))
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    
    private func getTimeList(model: [TimeModel]) -> [String]? {

        var timeList:[String]? = []
        for item in model {
            timeList?.append(item.time)
        }
        return timeList
    }
    
    
//    func  timeToDate(model: [TimeModel]?) -> [Date]? {
//        guard let model = model else { return nil}
//        var timeList:[Date]?
//        for item in model {
//            let t:String = item.time
//            timeList?.append(t.stringToDate())
//        }
//        return timeList
//    }
    
    
    
}
