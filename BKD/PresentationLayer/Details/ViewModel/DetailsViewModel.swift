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
        searchModel.returnTime = searchModel.pickUpTime!.addHours(getOptionFromString(item: optionsArr[optionIndex]))
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
        didResult(validator.checkReservationTime(time:time))
    }
    
    /// Check if reserve will  be acteve
    func isReserveActive(searchModel:SearchModel, didResult: @escaping (Bool) -> ())  {
        didResult(validator.checkReserve(searchModel: searchModel))
    }
    
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
    
    func getNoWorkingTimeTotalPrice(searchModel: SearchModel, timePrice:Double) -> Double {
        var total: Double = 0.0
        if !validator.checkReservationTime(time:searchModel.pickUpTime) {
            total += timePrice
        }
        if !validator.checkReservationTime(time:searchModel.returnTime) {
            total += timePrice
        }
        return total
    }
    
   
}
