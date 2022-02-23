//
//  MainViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

final class MainViewModel: NSObject {
    var searchModel = SearchModel()
    let validator = Validator()
    
    var isOnline: Bool {
        return true
        guard let settings = ApplicationSettings.shared.settings else { return false }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let start = dateFormatter.date(from: settings.workStart) else { return false }
        guard let end = dateFormatter.date(from: settings.workEnd) else { return false }
        guard let current = dateFormatter.date(from: dateFormatter.string(from: Date())) else { return false }
        return (start...end).contains(current)
    }
    
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
    func  isReservetionInWorkingHours(time: Date?, settings: Settings,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationTime(time: time, settings:settings))
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
    
    ///Check if reservation more then 90 days
    func  isReservetionMore90Days(search: SearchModel) -> Bool {
       return validator.checkReservation90Days(search: search)
    }
    
    ///Chack if car is active now
    func isCarActiveNow(reservation: Reservation?) -> Bool {

        guard let _ = reservation else {return true}
        
        let now = Double(Date().timeIntervalSince1970)
        for (_, value) in reservation!.innerArray {
            let start = value.start
            let end = value.end
            let isActive = !(now >= start &&  now <= end)
            if !isActive {
                return isActive
            }
        }
        return true
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
            detailsModel.append(DetailsModel(image: #imageLiteral(resourceName: "2"), title: String(diesel)))
        }
        if let transmission = carModel.transmission {
            detailsModel.append(DetailsModel(image: #imageLiteral(resourceName: "3"), title: String(transmission)))
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
        if carModel.GPSNavigator {
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
    func getCarsByTypes( fieldValue:String,
                        completion: @escaping ([CarsModel]) -> Void) {
        let criteria = ["fieldName": "type",
                        "fieldValue": fieldValue,
                        "searchOperation" : SearchOperation.equals.rawValue ] as [String : Any]
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarsByType(criteria: criteria))) { (result) in
            
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
    
    ///Get images of car´s type
    func getTypeImages(carTypes: [CarTypes], completion: @escaping ([UIImage])-> Void) {
    
        var imagesArr:[UIImage] = []
        let dispatchGroup = DispatchGroup()
        for i in 0 ..< carTypes.count{
            guard let image = carTypes[i].image, let imageURL = image.getURL() else { return }
            dispatchGroup.enter()
            
            UIImage.loadFrom(url: imageURL) { (image) in
                guard let _ = image else {return}
                imagesArr.append(image!)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completion(imagesArr)
               print("Finished all requests.")
           }) 
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
    
    ///Get current reservation date
    func getRentDate(date: Date?, withTime: Date?) -> Date? {
        guard let date = date, let time = withTime else {
            return nil
        }
       return Date().combineDate(date: date, withTime: time)
    }
    
    
    ///Get search model
    func getSearchModel(search: SearchModel,
                        searchHeaderV: SearchHeaderView?) -> SearchModel {
        
        var searchModel = SearchModel()
        searchModel = search
        searchModel.pickUpDate = searchHeaderV?.pickUpDate
        searchModel.returnDate = searchHeaderV?.returnDate
        searchModel.pickUpTime = searchHeaderV?.pickUpTime
        searchModel.returnTime = searchHeaderV?.returnTime
        searchModel.pickUpLocationId = searchHeaderV?.pickUpLocationId
        searchModel.returnLocationId = searchHeaderV?.returnLocationId
        searchModel.pickUpLocation = searchHeaderV?.pickUpLocation
        searchModel.returnLocation = searchHeaderV?.returnLocation
        
        return searchModel
    }
    
    
    func isRefreshToken() {
        let keychainManager = KeychainManager()
        if keychainManager.isTokenExpired() {
            
            let refreshToken = keychainManager.getRefreshToken() ?? ""
            SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.getAuthRefreshToken(refreshToken: refreshToken))) { result in
                switch result {
                case .success(let data):
                    guard let tokenResponse = BkdConverter<TokenResponse>.parseJson(data: data as Any) else {
                        print("tokenResponse return  -----")
                        return }
                    keychainManager.parse(from: tokenResponse)
                    print("tokenResponse -----", tokenResponse)

                case .failure(let error):
                    //completion(.failure(error))

                print("tokenResponse error  -----", error) 
                }
            }
        }
    }
    
}


