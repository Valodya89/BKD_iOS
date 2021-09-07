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
    
    func updateSearchInfo(tariff: Tariff,
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
   
}




