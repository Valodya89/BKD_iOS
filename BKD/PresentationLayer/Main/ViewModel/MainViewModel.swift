//
//  MainViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

class MainViewModel: NSObject {
    static let shared = MainViewModel()
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
}
