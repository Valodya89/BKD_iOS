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
                         oldPickUpDate: Date?,
                         oldReturnDate: Date?,
                         oldPickUpTime: Date?,
                         oldReturnTime: Date?,
                         oldPickUpLocation: String?,
                         oldReturnLocation: String?,
                         didResult: @escaping (Bool) -> ()) {
        
       let searchModel = SearchModel (pickUpDate: pickUpDate,
                                      returnDate: returnDate,
                                      pickUpTime: pickUpTime,
                                      returnTime: returnTime,
                                      pickUpLocation: pickUpLocation,
                                      returnLocation: returnLocation)
        let oldSearchModel = SearchModel (pickUpDate: oldPickUpDate,
                                          returnDate: oldReturnDate,
                                          pickUpTime: oldPickUpTime,
                                          returnTime: returnTime,
                                          pickUpLocation: oldPickUpLocation,
                                          returnLocation: oldReturnLocation)
        didResult(validator.searchDatasHasBeenEdited(searchParams: searchModel, oldSearchParam: oldSearchModel))
    }

    func  isReservetionMoreThanMonth(pickUpDate: Date?,
                                     returnDate: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationMonth(pickupDate: pickUpDate, returnDate: returnDate))
    }
    
    func  isReservetionInWorkingHours(pickUpTime: Date?,
                                     returnTime: Date?,
                                     didResult: @escaping (Bool) -> ()) {
        didResult(validator.checkReservationTimes(pickupTime: pickUpTime, returntime: returnTime))
    }
}
