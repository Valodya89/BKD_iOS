//
//  DetailsViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-06-21.
//

import UIKit
import SwiftUI

class DetailsViewModel: NSObject {
    
    let validator = Validator()
    var settings: Settings?
    var currTariffState: TariffState?
    var differenceInTimes: Double = 0
    var differenceInMinutes: Double = 0
    var differenceInDays: Double = 0
    
    
    
    ///Update search info depend on tariff
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
            searchModel.pickUpTime = nil
            searchModel.returnTime = nil
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
   
    ///Get tariff index
    func getTariffIndex(tariff: TariffState) -> Int {
        switch tariff {
        case .hourly: return 0
        case .daily: return 1
        case .weekly: return 2
        case .monthly: return 3
        default: return 4
        }
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
        settings = ApplicationSettings.shared.settings
        guard let _ = settings else { return }
        didResult(validator.checkReservationTime(time:time, settings: settings!))
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
        guard let _ = settings else { return 0.0 }
        
        if !validator.checkReservationTime(time:searchModel.pickUpTime, settings: settings!) {
            total += timePrice
        }
        if !validator.checkReservationTime(time:searchModel.returnTime, settings: settings!) {
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
            return TariffSlideModel(type: option.type,
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
    
    
    ///Update Hourly tariff slide list
    func updateTariffSlideList(tariffSlideList: [TariffSlideModel]?,
                               optionIndex: Int,
                               options: [TariffSlideModel]?,
                               tariff: TariffState) ->  [TariffSlideModel]? {
        var newTariffSlideList = tariffSlideList
        
        for i in 0 ..< tariffSlideList!.count {
            if tariffSlideList![i].options != nil {
                
                for j in 0 ..< tariffSlideList![i].options!.count {
                    
                    let option = tariffSlideList![i].options![j]
                    if option.isSelected == true {
                        newTariffSlideList![i].options![j].isSelected = false
                        newTariffSlideList![i].segmentIndex = nil
                    }
                    if options != nil {
                        if option.name == options![optionIndex].name  {
                            newTariffSlideList![i].options![j].isSelected = true
                            newTariffSlideList![i].segmentIndex = optionIndex
                        }
                    }
                }
            } else { //when is flexible
                if tariffSlideList![i].isSelected == true {
                    newTariffSlideList![i].isSelected = false
                    newTariffSlideList![i].segmentIndex = nil
                } else if tariff == .flexible {
                    newTariffSlideList![i].isSelected = true
                    newTariffSlideList![i].segmentIndex = optionIndex
                }
            }
        }
        return newTariffSlideList
    }
    
    ///Get current tarif deppend on selected times and dates
    func getCurrentTariff(search: SearchModel,
                          vehicleModel: VehicleModel,
                          tariffSlideList: [TariffSlideModel]?,
                          completion: @escaping ([TariffSlideModel]?, TariffState) -> Void) {
        
        
        let newResult = updateTariffList(search: search,
                             vehicleModel: vehicleModel,
                             tariffSlideList: tariffSlideList)
        completion(newResult, currTariffState ?? .hourly)
        
        
//        let hourPickup = search.pickUpTime!.getTimeByCompanent(compatent: .hour)
//        let minutPickup = search.pickUpTime!.getTimeByCompanent(compatent: .minute)
//        let hourReturn = search.returnTime!.getTimeByCompanent(compatent: .hour)
//        let minutReturn = search.returnTime!.getTimeByCompanent(compatent: .minute)
//        let time = (hourPickup: hourPickup, hourReturn: hourReturn, minutPickup: minutPickup, minutReturn: minutReturn)
//
//        let hourlyTariffList = getHourlyTariffList(search: search,
//                                                   tariffSlideList: tariffSlideList,
//                                                   time: time)
//        if hourlyTariffList == nil {
//            let dailyTariffList = getDailyTariffList(search: search,
//                                                     vehicleModel: vehicleModel,
//                                                     tariffSlideList: tariffSlideList,
//                                                     time: time)
//            return completion(dailyTariffList, currTariffState ?? .hourly)
//        }
//        return completion(hourlyTariffList, .hourly)
    }
    
    
    
    
    
    
    ///Update tariff list depend on search params
    func updateTariffList(search: SearchModel,
              vehicleModel: VehicleModel,
              tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        let hours = Date().getHoursFromDates(start: search.pickUpDate!,
                                             end: search.returnDate!,
                                             startTime: search.pickUpTime!,
                                             endTime: search.returnTime!)
        differenceInTimes = hours
        
        if hours > 0 && hours < 24 {
            newSlideList = getHourlyTariffList(search: search,
                                                   tariffSlideList: tariffSlideList)
            if newSlideList != nil {
                return newSlideList
            }
            return getDailyTariffList(search: search,
                                      vehicleModel: vehicleModel,
                                      tariffSlideList: tariffSlideList)
        } else {
            return getDailyTariffList(search: search,
                                      vehicleModel: vehicleModel,
                                      tariffSlideList: tariffSlideList)
        }
    }
    
    
    ///Count custom tariff for hourly
    func getHourlyTariffList(search: SearchModel,
                             tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        
        for j in 0 ..< tariffSlideList!.count {
            if tariffSlideList![j].type == Constant.Texts.hourly {
                let hourlyTariff = tariffSlideList![j]
                
                for i in 0 ..< hourlyTariff.tariff!.count {
                    let tariff = hourlyTariff.tariff![i]
                    
                    if (differenceInTimes <= tariff.duration ) {
                        newSlideList?[j].options![i].isSelected = true
                        newSlideList?[j].segmentIndex = i
                        currTariffState = .hourly
                        return newSlideList
                    }
                }
            }
        }
        return nil
    }

    
    
    ///Count custom tariff for daily
    func getDailyTariffList(search: SearchModel,
                            vehicleModel: VehicleModel,
                            tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        differenceInDays = Date().getDaysFromDates(start: search.pickUpDate!,
                                           end: search.returnDate!,
                                           hours: differenceInTimes)
//        var months = Double(search.returnDate!.distance(from: search.pickUpDate!, only: .month))
//        months = 12 + months
//
//        //Count days
//        var days = differenceInTimes / 24
//        if differenceInTimes <= 24 {
//            differenceInDays = 1
//        } else {
//            differenceInDays = ceil(differenceInTimes / 24)
//        }
//        days = differenceInDays
//        if months >= 1 && months < 12 {
//            days = differenceInDays + 300
//        }
        
        for j in 0 ..< tariffSlideList!.count {
            if tariffSlideList![j].type == Constant.Texts.daily {
                let dailyTariff = tariffSlideList![j]
                
                for i in 0 ..< dailyTariff.tariff!.count {
                    
                    let tariff = dailyTariff.tariff![i]
                    if differenceInDays == tariff.duration {
                        
                        newSlideList?[j].options![i].isSelected = true
                        newSlideList?[j].segmentIndex = i
                        currTariffState = .daily
                        return newSlideList
                    }
                }
            }
        }
        if differenceInDays < 7 { //count flexible tariff
            return getFlexibleTariffList(search: search,
                                         vehicleModel: vehicleModel,
                                         tariffSlideList: tariffSlideList)
        } else {//count weekly tariff
            return getWeeklyTariffList(search: search,
                                       vehicleModel: vehicleModel,
                                       tariffSlideList: tariffSlideList)
        }
    }
    
    
//    ///Count custom tariff for hourly
//    func getHourlyTariffList(search: SearchModel,
//                             tariffSlideList: [TariffSlideModel]?,
//                             time: (hourPickup: Int,
//                                    hourReturn: Int,
//                                    minutPickup: Int,
//                                    minutReturn: Int)) -> [TariffSlideModel]? {
//
//        var newSlideList = tariffSlideList
//        let nextDay = search.pickUpDate?.addDays(1)
//        if ((search.returnDate?.isSameDates(date: search.pickUpDate)) == true ||
//            (search.returnDate?.isSameDates(date: nextDay)) == true) {
//
//            var hours = Double(time.hourReturn - time.hourPickup)
//            let minuts = Double(time.minutReturn - time.minutPickup)
//            //If days are diferent but tariff is hourly
//            if (search.returnDate?.isSameDates(date: nextDay)) == true {
//                let hour = 24 + hours
//
//                if hour < 24 && minuts <= 0 {
//                    hours = hour
//                } else if hour < 24 && minuts > 0 {
//                    hours = hour + 1
//                } else {
//                    differenceInTimes = hours
//                    differenceInMinutes = minuts
//                    return nil
//                }
//            }
//            differenceInTimes = hours
//            differenceInMinutes = minuts
//
//            for j in 0 ..< tariffSlideList!.count {
//                if tariffSlideList![j].type == Constant.Texts.hourly {
//                    let hourlyTariff = tariffSlideList![j]
//
//                    for i in 0 ..< hourlyTariff.tariff!.count {
//
//                        let tariff = hourlyTariff.tariff![i]
//
//                        if (hours <= tariff.duration &&
//                            minuts <= 0) ||
//                            (hours < tariff.duration &&
//                             minuts > 0) ||
//                            ((search.returnDate?.isSameDates(date: nextDay)) == true && hours == tariff.duration && minuts > 0) {
//
//                            newSlideList?[j].options![i].isSelected = true
//                            newSlideList?[j].segmentIndex = i
//                            return newSlideList
//
//                        } else if hours <= tariff.duration && minuts > 0 {
//
//                            if i + 1 < hourlyTariff.tariff!.count {
//                                newSlideList?[j].options![i + 1].isSelected = true
//                                newSlideList?[j].segmentIndex = i + 1
//                                return newSlideList
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
//    ///Count custom tariff for daily
//    func getDailyTariffList(search: SearchModel,
//                            vehicleModel: VehicleModel,
//                            tariffSlideList: [TariffSlideModel]?,
//                            time: (hourPickup: Int,
//                                   hourReturn: Int,
//                                   minutPickup: Int,
//                                   minutReturn: Int)) -> [TariffSlideModel]? {
//
//        var newSlideList = tariffSlideList
//        var days = Double(search.returnDate!.distance(from: search.pickUpDate!, only: .day))
//        var months = Double(search.returnDate!.distance(from: search.pickUpDate!, only: .month))
//        var years = Double(search.returnDate!.distance(from: search.pickUpDate!, only: .year))
//        // let currentMonthDays = Double(search.pickUpDate?.daysInMonth() ?? 0)
//
//        /// when return date is in nex month
//        if months < 0 {
//            months = 12 + months
//        }
//        if months >= 1 {
//            days = (monthDays * months)  + days
//        }
//        ///When return date is on next year
//        if years > 0 && months == 0 {
//            days = ((12 * years) * monthDays) + days
//        }
//
//        if differenceInTimes == 0 {
//            differenceInTimes = Double(time.hourReturn - time.hourPickup)
//            differenceInMinutes = Double(time.minutReturn - time.minutPickup)
//        }
//        //When days are same
//        if ((search.returnDate?.isSameDates(date: search.pickUpDate)) == true)  {
//            days = 1
//        } else if  ( differenceInTimes > 0 || differenceInMinutes > 0)  { //When on the day added time
//            days += 1
//        }
//        differenceInDays = days
//        for j in 0 ..< tariffSlideList!.count {
//            if tariffSlideList![j].type == Constant.Texts.daily {
//                let dailyTariff = tariffSlideList![j]
//
//                for i in 0 ..< dailyTariff.tariff!.count {
//
//                    let tariff = dailyTariff.tariff![i]
//                    if days == tariff.duration {
//
//                        newSlideList?[j].options![i].isSelected = true
//                        newSlideList?[j].segmentIndex = i
//                        currTariffState = .daily
//                        return newSlideList
//
//                    }
//                }
//            }
//        }
//        if days < 7 { //count flexible tariff
//            return getFlexibleTariffList(search: search,
//                                         vehicleModel: vehicleModel,
//                                         tariffSlideList: tariffSlideList)
//        } else {//count weekly tariff
//            return getWeeklyTariffList(search: search,
//                                       vehicleModel: vehicleModel,
//                                       tariffSlideList: tariffSlideList)
//        }
//    }
    
    ///Count custom tariff for weekly
    func getWeeklyTariffList(search: SearchModel,
                             vehicleModel: VehicleModel,
                             tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        let weeks = differenceInDays / 7
        
        for j in 0 ..< tariffSlideList!.count {
            
            if tariffSlideList![j].type == Constant.Texts.weekly {
                let weeklyTariff = tariffSlideList![j]
                
                for i in 0 ..< weeklyTariff.tariff!.count {
                    
                    let tariff = weeklyTariff.tariff![i]
                    if (weeks == tariff.duration) {
                        
                        newSlideList?[j].options![i].isSelected = true
                        newSlideList?[j].segmentIndex = i
                        currTariffState = .weekly
                        return newSlideList
                    }
                }
            }
        }
        
        //current month days count
        let currentMonthDays = Double(search.pickUpDate?.daysInMonth() ?? 0)
        if differenceInDays < monthDays {
            return getFlexibleTariffList(search: search,
                                         vehicleModel: vehicleModel,
                                         tariffSlideList: tariffSlideList)
        } else if differenceInDays >= monthDays || differenceInDays == currentMonthDays {
            return getMonthlyTariffList(search: search,
                                        vehicleModel: vehicleModel,
                                        tariffSlideList: tariffSlideList)
        }
        return nil
    }
    
    ///Count custom tariff for monthly
    func getMonthlyTariffList(search: SearchModel,
                              vehicleModel: VehicleModel,
                              tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        //current month days count
        let currentMonthDays = Double(search.pickUpDate?.daysInMonth() ?? 0)
        var months = differenceInDays / monthDays
        
        if differenceInDays == currentMonthDays { // first monte count depend of month days
            months = 1
        }
        
        for j in 0 ..< tariffSlideList!.count {
            if tariffSlideList![j].type == Constant.Texts.monthly {
                let monthlyTariff = tariffSlideList![j]
                
                for i in 0 ..< monthlyTariff.tariff!.count {
                    
                    let tariff = monthlyTariff.tariff![i]
                    if months == tariff.duration {
                        
                        newSlideList?[j].options![i].isSelected = true
                        newSlideList?[j].segmentIndex = i
                        currTariffState = .monthly
                        return newSlideList
                    }
                }
            }
        }
        //count flexible tariff
        return getFlexibleTariffList(search: search,
                                     vehicleModel: vehicleModel,
                                     tariffSlideList: tariffSlideList)
    }
    
    ///Count custom tariff for flexible
    func getFlexibleTariffList(search: SearchModel,
                               vehicleModel: VehicleModel,
                               tariffSlideList: [TariffSlideModel]?) -> [TariffSlideModel]? {
        
        var newSlideList = tariffSlideList
        
        for j in 0 ..< tariffSlideList!.count {
            if tariffSlideList![j].type == Constant.Texts.flexible {
                
                let flexibleTariff = tariffSlideList![j]
                let price = differenceInDays * vehicleModel.priceForFlexible
                var specialPrice:Double?
                if flexibleTariff.discountPercent ?? 0 > 0 {
                    specialPrice = price - (price * (flexibleTariff.discountPercent!/100))
                }
                newSlideList?[j].value = String(price)
                newSlideList?[j].specialValue = String(specialPrice ?? 0.0)
                newSlideList?[j].isSelected = true
                currTariffState = .flexible
                return newSlideList
            }
        }
        return tariffSlideList
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
