//
//  DetailsViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit

class DetailsViewModel: NSObject {
    
    let validator = Validator()
    var workingTimes: WorkingTimes?
    
    func updateSearchInfo(tariffSlideList:[TariffSlideModel],
                          tariff: TariffState,
                          search: Search,
                       optionIndex: Int,
                       currSearchModel: SearchModel) -> SearchModel {
        
        var searchModel = SearchModel()
        searchModel = currSearchModel
        switch tariff {
            case .hourly:
                searchModel = updateHourlyTariff(tariffSlideList:tariffSlideList,
                                                 search: search,
                                   optionIndex: optionIndex,
                                   searchModel: searchModel)
               
                break
            case .daily:
                searchModel = updateDailyTariff(tariffSlideList:tariffSlideList,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .weekly:
                searchModel = updateWeeklyTariff(tariffSlideList:tariffSlideList,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .monthly:
                searchModel = updateMonthlyTariff(tariffSlideList:tariffSlideList,
                                                optionIndex: optionIndex,
                                                searchModel: searchModel)
                break
            case .flexible:
            searchModel = SearchModel()
                break
            
        }
        return searchModel
    }
    
    
    //Update serach info for flexible tariff
    func updateSearchInfoForFlexible(search: Search,
                       currSearchModel: SearchModel) -> SearchModel {
        
        var searchModel = SearchModel()
        searchModel = currSearchModel
        if checkIfNeedToAddADay(searchModel: searchModel) {
            searchModel.returnDate = searchModel.pickUpDate!.addDays(1)
        }
        
//        if let pickUpTime = searchModel.pickUpTime,
//           let returnTime = searchModel.returnTime {
            
//            if ((searchModel.returnDate?.isSameDates(date: searchModel.pickUpDate)) == true) {
//                let hourPickup = pickUpTime.getTimeByCompanent(compatent: .hour)
//                let minutPickup = pickUpTime.getTimeByCompanent(compatent: .minute)
//                let hourReturn = returnTime.getTimeByCompanent(compatent: .hour)
//                let minutReturn = returnTime.getTimeByCompanent(compatent: .minute)
//
//                if (hourPickup > hourReturn) || (hourPickup == hourReturn && minutPickup >= minutReturn)
//                     {
//                    searchModel.returnDate = searchModel.pickUpDate!.addDays(1)
//                }
//            }
//        }
        return searchModel
    }
        
    
    ///Check if need to add a day depend on time
    func checkIfNeedToAddADay(searchModel: SearchModel) -> Bool {
        if let pickUpTime = searchModel.pickUpTime,
           let returnTime = searchModel.returnTime {
            
            if ((searchModel.returnDate?.isSameDates(date: searchModel.pickUpDate)) == true) {
                let hourPickup = pickUpTime.getTimeByCompanent(compatent: .hour)
                let minutPickup = pickUpTime.getTimeByCompanent(compatent: .minute)
                let hourReturn = returnTime.getTimeByCompanent(compatent: .hour)
                let minutReturn = returnTime.getTimeByCompanent(compatent: .minute)
                
                if (hourPickup > hourReturn) || (hourPickup == hourReturn && minutPickup >= minutReturn)
                     {
                   return true
                }
            }
        }
        return false
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
    private func updateHourlyTariff(tariffSlideList:[TariffSlideModel],
                                    search: Search,
                             optionIndex: Int,
                             searchModel: SearchModel) -> SearchModel {
    
    var searchModel = searchModel
        let optionsArr:[Tariff] = tariffSlideList[0].tariff ?? []
    if search == .date {
        searchModel.returnDate = searchModel.pickUpDate
        if let _ = searchModel.pickUpTime, let _ = searchModel.pickUpDate   {
            searchModel.returnDate = searchModel.pickUpDate!.addHours(Int(optionsArr[optionIndex].duration))
        }
    } else {
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime!.addHours(Int(optionsArr[optionIndex].duration))
        }
        if let pickUpDate = searchModel.pickUpDate {
            searchModel.returnDate = pickUpDate.addHours(Int(optionsArr[optionIndex].duration))
            }
        }
        return searchModel
   }
   
    ///Update daily tariff
    private func updateDailyTariff(tariffSlideList:[TariffSlideModel],
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[Tariff] = tariffSlideList[1].tariff ?? []
        searchModel.returnDate = searchModel.pickUpDate?.addDays( Int(optionsArr[optionIndex].duration))
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime
        }
        return searchModel
    }
    
    ///Update weekly tariff
    private func updateWeeklyTariff(tariffSlideList:[TariffSlideModel],
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[Tariff] = tariffSlideList[2].tariff ?? []
        searchModel.returnDate = searchModel.pickUpDate?.addWeeks(Int(optionsArr[optionIndex].duration))
        if let _ = searchModel.pickUpTime {
            searchModel.returnTime = searchModel.pickUpTime
        }
        return searchModel
    }
    
    ///Update monthly tariff
    private func updateMonthlyTariff(tariffSlideList:[TariffSlideModel],
                              optionIndex: Int,
                              searchModel: SearchModel) -> SearchModel {
        var searchModel = searchModel
        let optionsArr:[Tariff] = tariffSlideList[3].tariff ?? []
        searchModel.returnDate = searchModel.pickUpDate?.addMonths(Int(optionsArr[optionIndex].duration))
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
    
    
    
    
    
    /// Set no working hours price
    func setNoWorkingHoursPrice(search: SearchModel, price: Double) {
        
        let pickupTime = search.pickUpTime?.getHour()
        let returnTime = search.returnTime?.getHour()

        isReservetionInWorkingHours(time: pickupTime?.stringToDate()) { (result) in
            PriceManager.shared.pickUpNoWorkingTimePrice = !result ? price : nil
        }
        isReservetionInWorkingHours(time: returnTime?.stringToDate()) { (result) in
            PriceManager.shared.returnNoWorkingTimePrice = !result ? price : nil
        }
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
    func changeTariffListForUse(tariffs:[Tariff],
                                vehicleModel: VehicleModel) -> [TariffSlideModel]? {
        var tariffSlideList:[TariffSlideModel] = []
        ///Hourly
        let hourlyModel = getTariffSlideModel(type: Constant.Keys.hourly,
                                              tariffs: tariffs,
                                              vehicleModel: vehicleModel,
                                              price: vehicleModel.priceHour,
                                              tariffKey: Constant.Texts.hourly,
                                              bckgColor: color_hourly!,
                                              typeColor: .white)
        if hourlyModel != nil {
            tariffSlideList.append(hourlyModel!)
        }
        
        ///Dayli
        let dailyModel = getTariffSlideModel(type: Constant.Keys.daily,
                                             tariffs: tariffs,
                                             vehicleModel: vehicleModel,
                                             price: vehicleModel.priceDay,
                                             tariffKey: Constant.Texts.daily,
                                             bckgColor: color_days!,
                                             typeColor: color_main!)
        if dailyModel != nil {
            tariffSlideList.append(dailyModel!)
        }
        
        ///Weekly
        let weeklyModel = getTariffSlideModel(type: Constant.Keys.weekly,
                                             tariffs: tariffs,
                                              vehicleModel: vehicleModel,
                                              price: vehicleModel.priceWeek,
                                             tariffKey: Constant.Texts.weekly,
                                             bckgColor: color_weeks!,
                                              typeColor: .white)
        if weeklyModel != nil {
            tariffSlideList.append(weeklyModel!)
        }
        
        ///Monthly
        let monthlyModel = getTariffSlideModel(type: Constant.Keys.monthly,
                                             tariffs: tariffs,
                                               vehicleModel: vehicleModel,
                                               price: vehicleModel.priceMonth,
                                             tariffKey: Constant.Texts.monthly,
                                             bckgColor: color_monthly!,
                                             typeColor: color_main!)
        if monthlyModel != nil {
            tariffSlideList.append(monthlyModel!)
        }
        
        ///Flexible
        if let _ = tariffs.first(where: { $0.type == Constant.Keys.flexible }) {
            
            var flexibleModel = TariffSlideModel (type: Constant.Texts.flexible, bckgColor: color_flexible, typeColor: .white)
            flexibleModel.options = nil
            var price = vehicleModel.priceForFlexible
            flexibleModel.value = String(price)
            if vehicleModel.hasDiscount {
                price = price - (price * (vehicleModel.discountPercents/100))
                flexibleModel.discountPercent = vehicleModel.discountPercents

            }
            flexibleModel.specialValue = String(price)

            tariffSlideList.append(flexibleModel)
        }
       
        return tariffSlideList
    }
    
    
    ///Get tariffs by type
    func getTariffByType(type: String, tariffKey: String, tariffs:[Tariff]) -> [String : [Tariff]]? {
        var tariffList:[Tariff] = []
       var i = 0
        tariffs.forEach { tariff in
            if tariff.type == type &&  tariff.active == true {
                if i < 6 {
                tariffList.append(tariff)
                }
                i += 1
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
                             tariffs: [Tariff],
                             vehicleModel: VehicleModel,
                             price: Double?,
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
                
                var value = tariff.duration * (price ?? 0.0)
                if tariff.percentage > 0.0 {
                    value = value - (value * (tariff.percentage/100))
                }
//                var specialPrice:Double = 0.0
//                if price?.hasSpecialPrice == true {
//                    specialPrice = value - (value * (price!.specialPrice/100))
//                }
                var discounPrice: Double = 0.0
                if vehicleModel.hasDiscount {
                    discounPrice = value - (value * (vehicleModel.discountPercents/100))
                }
                
                let option = TariffSlideModel(type: tariffKey, name: tariff.name, bckgColor: bckgColor,typeColor: typeColor, value: String(format: "%.2f", value), specialValue: String(format: "%.2f", discounPrice), discountPercent: vehicleModel.hasDiscount ? vehicleModel.discountPercents : nil)
               
                options.append(option)
            }
            tariffModel.options = options
            tariffModel.tariff = tariffSorted[tariffKey]
            return tariffModel
        }
        return nil
    }
    
    
    //Get time string of flexible tariff
    func getTimeOfFlexible(time: String) -> String {
        
        let timeArr = time.split(separator: "-")
        var newTime:String = String(timeArr[timeArr.count - 1])
        newTime = newTime.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return newTime
    }
    
    //Get Start flexible time list
    func getStartFlexibleTimes(flexibleTimes: [FlexibleTimes]?) -> [String]? {
        var flexibleStartTimes:[String]? = []
        
        flexibleTimes?.forEach({ flexibleTime in
            if flexibleTime.active {
                if flexibleTime.type == Constant.Keys.start && flexibleTime.start != nil  {
                    flexibleStartTimes?.append(flexibleTime.start!)
                    
                } else if flexibleTime.type == Constant.Keys.start_interval &&
                    flexibleTime.start != nil &&
                    flexibleTime.end != nil {
                    flexibleStartTimes?.append(flexibleTime.start! + "-" + flexibleTime.end!)
                }
            }
        })
        return flexibleStartTimes
    }
    
    //Get End flexible time list
    func getEndFlexibleTimes(flexibleTimes: [FlexibleTimes]?) -> [String]? {
        var flexibleStartTimes:[String]? = []
        
        flexibleTimes?.forEach({ flexibleTime in
            if flexibleTime.active {
                if flexibleTime.type == Constant.Keys.end && flexibleTime.end != nil  {
                    flexibleStartTimes?.append(flexibleTime.end!)
                    
                } else if flexibleTime.type == Constant.Keys.end_interval &&
                    flexibleTime.start != nil &&
                    flexibleTime.end != nil {
                    flexibleStartTimes?.append(flexibleTime.start! + "-" + flexibleTime.end!)
                }
            }
        })
        return flexibleStartTimes
    }
    
    
    ///Get flexible price
    func getFlexiblePrice(search: SearchModel,
                          option: TariffSlideModel,
                          vehicle: VehicleModel,
                          isSelected: Bool) -> TariffSlideModel? {
        
        if search.pickUpDate != nil && search.returnDate != nil {
            
            let pickupDay = Double(search.pickUpDate!.getDay())!
            let returnDay = Double(search.returnDate!.getDay())!
            var daysCount = ((returnDay - pickupDay) <= 0 ) ? 1 : (returnDay - pickupDay)
            
            
            if returnDay - pickupDay > 0 {
                if  search.pickUpTime!.millisecondsSince1970 < search.returnTime!.millisecondsSince1970  && (search.returnTime!.millisecondsSince1970 - search.pickUpTime!.millisecondsSince1970) > 250000  {
                    daysCount += 1
                }
            }
                       
            let price = daysCount * vehicle.priceForFlexible
            var specialPrice:Double?
            if option.discountPercent ?? 0 > 0 {
                 specialPrice = price - (price * (option.discountPercent!/100))
            }
            return
            TariffSlideModel(type: option.type,
                             name: option.name,
                             bckgColor: option.bckgColor,
                             typeColor: option.typeColor,
                             value: String(price),
                             specialValue: String(specialPrice ?? 0.0),
                             discountPercent: option.discountPercent,
                             flexibleStaringPrice: vehicle.priceForFlexible,
                             fuelConsumption: option.fuelConsumption,
                             isOpenOptions: option.isOpenOptions,
                             isItOption: option.isItOption,
                             isSelected: isSelected,
                             options: option.options,
                             tariff: option.tariff)
        }
        return option
    }
    
   
}


//"content": {
//        "id": "6189d8bc3a0352528762d090",
//        "userId": "60febc56266f574fec954af2",
//        "startDate": 1636395213876,
//        "endDate": 1636395213876,
//        "accessories": [
//            {
//                "id": "61506ec81464ab42a0e2f31e",
//                "count": 1
//            }
//        ],
//        "pickupLocation": {
//            "type": "CUSTOM",
//            "customLocation": {
//                "name": "Masivi city",
//                "longitude": 45.5,
//                "latitude": 47.8
//            },
//            "parking": null
//        },
//        "returnLocation": {
//            "type": "CUSTOM",
//            "customLocation": {
//                "name": "Masivi city",
//                "longitude": 45.5,
//                "latitude": 47.8
//            },
//            "parking": null
//        },
//        "carDetails": {
//            "id": "61815f3296b3233b4995c625",
//            "registrationNumber": null,
//            "logo": {
//                "id": "14122AFE1F760709174A3F2B166B05AB51B1D7286ECAC4678C5B2F485A99F02605F320DD234F89BAAFC16476569668ED",
//                "node": "dev-node1"
//            },
//            "model": "M3",
//            "type": null
//        },
//        "driver": {
//            "id": "60febc56266f574fec954af2",
//            "name": "Valodya",
//            "surname": "Galstyan",
//            "drivingLicenseNumber": null
//        },
//        "additionalDrivers": []
//    }
//}
//
