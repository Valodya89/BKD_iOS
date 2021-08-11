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
    
    /// Check if  search fiels edited
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
    

    /// Check if reservetion more than month
    func  isReservetionMoreThanMonth(pickUpDate: Date?,
                                     returnDate: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationMonth(pickupDate: pickUpDate, returnDate: returnDate))
    }
    
    /// Check if reservetion during working hours
    func  isReservetionInWorkingHours(time: Date?, workingTimes: WorkingTimes,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationTime(time: time, workingTimes:workingTimes))
    }
    
     
    /// Check if reservetion more than half hour
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
   
    
    /// Get Tail lift info
    func getTailLiftList(carModel: CarsModel) -> [TailLiftModel] {
  
        var tailLiftModel: [TailLiftModel] = []
        
        tailLiftModel.append(TailLiftModel(value: "\(carModel.liftingCapacityTailLift) \(Constant.Texts.kg)", title: Constant.Texts.tailLiftCapacity))
        tailLiftModel.append(TailLiftModel(value: "\(carModel.tailLiftLength) \(Constant.Texts.cm)", title: Constant.Texts.tailLiftLength))
        tailLiftModel.append(TailLiftModel(value: "\(carModel.heightOfLoadingFloor) \(Constant.Texts.cm)", title: Constant.Texts.loadingFloorHeight))
        
        return tailLiftModel
        
    }
    
    /// Get detail info
    func getDetail(carModel: CarsModel) -> [DetailsModel] {
        
        var detailsModel: [DetailsModel] = []
        detailsModel.append(DetailsModel(image: #imageLiteral(resourceName: "1"), title: String(format: "%.0f", carModel.seats)))
        if let diesel = carModel.fuel {
            detailsModel.append(DetailsModel(image: #imageLiteral(resourceName: "1"), title: String(diesel)))
        }
        if let transmission = carModel.transmission {
            detailsModel.append(DetailsModel(image: #imageLiteral(resourceName: "1"), title: String(transmission)))
        }
        detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "4"), title: String(carModel.motor)))
        if carModel.euroNorm > 0 {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "5"), title: String(format: "%.0f", carModel.euroNorm)))
        }
        if let exterior = carModel.exterior {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "6"), title: exterior.getExterior()))
        }
        detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "7"), title: "\(carModel.withBetweenWheels) \(Constant.Texts.m)"))
        if carModel.airConditioning {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "8"), title: Constant.Texts.conditioning))
        }
        if carModel.gpsnavigator {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "9"), title: Constant.Texts.gps))
        }
        if carModel.towbar {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "10"), title: Constant.Texts.towBar))
        }
        if carModel.sideDoor {
            detailsModel.append(DetailsModel (image: #imageLiteral(resourceName: "11"), title: Constant.Texts.slideDoor))
        }
            
        return detailsModel
        
    }
    
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


