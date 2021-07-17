//
//  MainViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

class MainViewModel: NSObject {
   // static let shared = MainViewModel()
    var searchModel = SearchModel()
    let validator = Validator()
    
    override init() {}
    
    func  isFieldsEdited(pickUpDate: Date?,
                         returnDate: Date?,
                         pickUpTime: Date?,
                         returnTime: Date?,
                         pickUpLocation: String?,
                         returnLocation: String?,
                         category: Int?,
                         oldPickUpDate: Date?,
                         oldReturnDate: Date?,
                         oldPickUpTime: Date?,
                         oldReturnTime: Date?,
                         oldPickUpLocation: String?,
                         oldReturnLocation: String?,
                         oldCategory: Int?,
                         didResult: @escaping (Bool) -> ()) {
        
       let searchModel = SearchModel (pickUpDate: pickUpDate,
                                      returnDate: returnDate,
                                      pickUpTime: pickUpTime,
                                      returnTime: returnTime,
                                      pickUpLocation: pickUpLocation,
                                      returnLocation: returnLocation,
                                      category: category )
        let oldSearchModel = SearchModel (pickUpDate: oldPickUpDate,
                                          returnDate: oldReturnDate,
                                          pickUpTime: oldPickUpTime,
                                          returnTime: returnTime,
                                          pickUpLocation: oldPickUpLocation,
                                          returnLocation: oldReturnLocation,
                                          category: oldCategory)
        didResult(validator.searchDatasHasBeenEdited(searchParams: searchModel, oldSearchParam: oldSearchModel))
    }

    func  isReservetionMoreThanMonth(pickUpDate: Date?,
                                     returnDate: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationMonth(pickupDate: pickUpDate, returnDate: returnDate))
    }
    
    func  isReservetionInWorkingHours(time: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationTime(time: time))
    }
    
    
    func  isReservetionMoreHalfHour(pickUpDate: Date,
                                    returnDate: Date,
                                    pickUpTime:Date,
                                    returnTime: Date,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationReturnTime(pickUpDate: pickUpDate,
                                                       returnDate: returnDate,
                                                       pickUpTime: pickUpTime,
                                                       returnTime: returnTime))
    }
   
    
//    func getCars(completion: @escaping ([CarsModel]?) -> Void) {
//        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAvailableTimeList)) { (result) in
//
//            switch result {
//            case .success(let data):
//
//                guard let carsList = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
//                    print("error")
//                    return
//                }
//                print(carsList.content)
//
//                completion(carsList.content)
//            case .failure(let error):
//                print(error.description)
//
//                break
//            }
//        }
//    }
    
    
    /// get cars list by car type
    func getCarsByTypes(fieldName: String,
                        fieldValue:String,
                        operation: String,
                        completion: @escaping ([CarsModel]) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarsByType(fieldName: fieldName,
                                                                                        fieldValue: fieldValue,
                                                                                        searchOperation: operation))) { (result) in
            
            switch result {
            case .success(let data):
                guard let carList = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(carList.content as Any)
                completion(carList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    
    /// get car types
    func getCarTypes(completion: @escaping ([CarTypes]) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarTypes)) { (result) in
            
            switch result {
            case .success(let data):
                guard let carTypeList = BkdConverter<BaseResponseModel<[CarTypes]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(carTypeList.content as Any)
                completion(carTypeList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    
    /// Get parking list
    func getParking(completion: @escaping ([Parking]?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getParking)) { (result) in
            
            switch result {
            case .success(let data):
                guard let parkingList = BkdConverter<BaseResponseModel<[Parking]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(parkingList.content as Any)
                completion(parkingList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
}


