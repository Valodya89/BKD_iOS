//
//  DetailsViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit

class DetailsViewModel: NSObject {
 //static let shared = DetailsViewModel()
    
    let validator = Validator()
    var workingTimes: WorkingTimes?
    
    func updateSearchInfo(tariff: TariffState,
                          search: Search,
                       optionIndex: Int,
                       currSearchModel: SearchModel) -> SearchModel {
        
        var searchModel = SearchModel()
        searchModel = currSearchModel
        switch tariff {
            case .hourly:
                searchModel = updateHourlyTariff(search: search,
                                   optionIndex: optionIndex,
                                   searchModel: searchModel)
               
                break
            case .daily:
                searchModel = updateDailyTariff(search: search,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .weekly:
                searchModel = updateWeeklyTariff(search: search,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .monthly:
                searchModel = updateMonthlyTariff(search: search,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .flexible:
               // optionsArr = tariffOptionsArr[4]
                break
            
        }
        return searchModel
    }
    
    ///return tariff option value
    func getOptionFromString(item: String) -> Int {
        let option = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let intVal = Int(option) {
               return intVal
            }
        return 0
    }
   
    ///Update hourly tariff
   private func updateHourlyTariff(search: Search,
                             optionIndex: Int,
                             searchModel: SearchModel) -> SearchModel {
    
    var searchModel = searchModel
    let optionsArr:[String] = tariffOptionsArr[0]
    if search == .date {
        searchModel.returnDate = searchModel.pickUpDate
        if let _ = searchModel.pickUpTime {
            searchModel.returnDate = searchModel.pickUpDate!.addHours(getOptionFromString(item: optionsArr[optionIndex]))
        }
    } else {
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime!.addHours(getOptionFromString(item: optionsArr[optionIndex]))
        }
        if let pickUpDate = searchModel.pickUpDate {
            searchModel.returnDate = pickUpDate.addHours(getOptionFromString(item: optionsArr[optionIndex]))
            }
        }
        return searchModel
   }
   
    ///Update daily tariff
    private func updateDailyTariff(search: Search,
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[String] = tariffOptionsArr[1]
        searchModel.returnDate = searchModel.pickUpDate?.addDays(getOptionFromString(item: optionsArr[optionIndex]))
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime
        }
        return searchModel
    }
    
    ///Update weekly tariff
    private func updateWeeklyTariff(search: Search,
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[String] = tariffOptionsArr[2]
        searchModel.returnDate = searchModel.pickUpDate?.addWeeks(getOptionFromString(item: optionsArr[optionIndex]))
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime
        }
        return searchModel
    }
    
    ///Update monthly tariff
    private func updateMonthlyTariff(search: Search,
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[String] = tariffOptionsArr[3]
        searchModel.returnDate = searchModel.pickUpDate?.addMonths(getOptionFromString(item: optionsArr[optionIndex]))
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime
        }
        return searchModel
    }
    
    
    /// Check if reserve time in working hours
    func isReservetionInWorkingHours(time: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        workingTimes = ApplicationSettings.shared.workingTimes
        guard let _ = workingTimes else { return }
        didResult(validator.checkReservationTime(time:time, workingTimes: workingTimes!))
    }
    
    /// Check if reserve will  be acteve
    func isReserveActive(searchModel:SearchModel, didResult: @escaping (Bool) -> ())  {
        didResult(validator.checkReserve(searchModel: searchModel))
    }
    
    ///Total price of custom location
    func getCustomLocationTotalPrice(searchV: SearchView) -> Double {
        var total: Double = 0.0
        if LocationPickUp.pickUpCustomLocation == searchV.locationPickUp {
            total += customLocationPrice
         }
         if LocationReturn.returnCustomLocation == searchV.locationReturn {
            total += customLocationPrice
          }
        return total
    }
    
    ///Total cost of reservations outside working hours
    func getNoWorkingTimeTotalPrice(searchModel: SearchModel, timePrice:Double) -> Double {
        var total: Double = 0.0
        guard let _ = workingTimes else { return 0.0 }
        
        if !validator.checkReservationTime(time:searchModel.pickUpTime, workingTimes: workingTimes!) {
            total += timePrice
        }
        if !validator.checkReservationTime(time:searchModel.returnTime, workingTimes: workingTimes!) {
            total += timePrice
        }
        return total
    }
    
    ///Get all car images
    func getCarImageList(item: VehicleModel, completion: @escaping ([UIImage]?)-> Void){
        
        var imagesList:[UIImage] = []
        if let img = item.vehicleImg {
            imagesList.append(img)
        }
        guard let images = item.images else {
            completion(imagesList)
            return
        }
        
        let dispatchGroup = DispatchGroup()

        images.forEach { (carImage) in
            guard let url = carImage.getURL() else {return}
            dispatchGroup.enter()
            UIImage.loadFrom(url: url) { image in
                guard let image = image else { return}
                imagesList.append(image)
                dispatchGroup.leave()

            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completion(imagesList)
           })
        
    }
    
    
    /// get tariff list
     func getTariff(completion: @escaping ([Tariff]?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getTariff)) {  (result) in
            
            switch result {
            case .success(let data):
                guard let tariff = BkdConverter<BaseResponseModel<[Tariff]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                completion(tariff.content)
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    

    ///Change tariff list for using
    func changeTariffListForUse(tariffs:[Tariff], carValue: Double) -> [TariffSlideModel]? {
        var tariffSlideList:[TariffSlideModel] = []
        ///Hourly
        let hourlyModel = getTariffSlideModel(type: Constant.Keys.hourly,
                                              tariffs: tariffs,
                                              carValue: carValue,
                                              tariffKey: Constant.Texts.hourly,
                                              bckgColor: color_hourly!,
                                              typeColor: .white)
        if hourlyModel != nil {
                tariffSlideList.append(hourlyModel!)
        }
        
        ///Dayli
        let dailyModel = getTariffSlideModel(type: Constant.Keys.daily,
                                             tariffs: tariffs,
                                             carValue: carValue,
                                             tariffKey: Constant.Texts.daily,
                                             bckgColor: color_days!,
                                             typeColor: color_main!)
        if dailyModel != nil {
            tariffSlideList.append(dailyModel!)
        }
        
        ///Weekly
        let weeklyModel = getTariffSlideModel(type: Constant.Keys.weekly,
                                             tariffs: tariffs,
                                             carValue: carValue,
                                             tariffKey: Constant.Texts.weekly,
                                             bckgColor: color_weeks!,
                                              typeColor: .white)
        if weeklyModel != nil {
            tariffSlideList.append(weeklyModel!)
        }
        
        ///Monthly
        let monthlyModel = getTariffSlideModel(type: Constant.Keys.monthly,
                                             tariffs: tariffs,
                                             carValue: carValue,
                                             tariffKey: Constant.Texts.monthly,
                                             bckgColor: color_monthly!,
                                             typeColor: color_main!)
        if monthlyModel != nil {
            tariffSlideList.append(monthlyModel!)
        }
        
        ///Flexible
        if let model = tariffs.first(where: { $0.type == Constant.Keys.flexible }) {
            
            var flexibleModel = TariffSlideModel (type: Constant.Texts.flexible, bckgColor: color_flexible, typeColor: .white)
            flexibleModel.options = nil
            flexibleModel.value = String(carValue)
            flexibleModel.fuelConsumption = model.fuelCompensation
            tariffSlideList.append(flexibleModel)
        }
       
        return tariffSlideList
    }
    
    
    ///Get tariffs by type
    func getTariffByType(type: String, tariffKey: String, tariffs:[Tariff]) -> [String : [Tariff]]? {
        var tariffList:[Tariff] = []
       
        tariffs.forEach { tariff in
            if tariff.type == type &&  tariff.active == true {
                tariffList.append(tariff)
            }
        }
        tariffList = tariffList.sorted(by: { $0.duration < $1.duration })
        if tariffList.count > 0 {
            
            let tariffsByType:[String : [Tariff]] = [tariffKey : tariffList]
           return tariffsByType
        }
        return nil
    }
    
    ///Get tariffSlide modell
    func getTariffSlideModel(type: String,
                             tariffs:[Tariff],
                             carValue: Double,
                             tariffKey: String,
                             bckgColor: UIColor,
                             typeColor: UIColor) -> TariffSlideModel? {

        let tariffSorted = getTariffByType(type: type,
                                           tariffKey: tariffKey,
                                           tariffs: tariffs)
        if let tariffSorted = tariffSorted {
            var tariffModel = TariffSlideModel (type: tariffKey, bckgColor: bckgColor,typeColor: typeColor)
            var options: [TariffSlideModel] = []
            let tariffArr:[Tariff] = tariffSorted[tariffKey]!
            
            tariffArr.forEach{ tariff in
                
                let price = tariff.duration * carValue
                let option = TariffSlideModel(type: tariffKey, name: tariff.name, bckgColor: bckgColor,typeColor: typeColor, value: String(price - ((price * tariff.percentage)/100)) )
                options.append(option)
            }
            tariffModel.options = options
            tariffModel.tariff = tariffSorted[tariffKey]
            return tariffModel
        }
        return nil
    }
    
   
}




