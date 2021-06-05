//
//  Validator.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-05-21.
//

import Foundation
import CoreLocation

//for failure and success results
enum Alert {
    case success
    case failure
    case error
}

//for success or failure of validation with alert message
enum Valid {
    case success
    case failure(Alert, AlertMessages)
}
enum ValidationType {
    //Search
    case date
    case time
    case pickUplocation
    case returnlocation
    case success
    
}

enum AlertMessages: String {
    case inValidSearchDatas = "Select dates and locations to check availability"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}



class Validator: NSObject {
    
    //MARK: MAIN PAGE  CHECKING
    //MARK: ------------------------
    ///check if any fields has been edited
    func searchDatasHasBeenEdited(searchParams: SearchModel, oldSearchParam: SearchModel) -> Bool  {
        if searchParams.pickUpDate?.getString() != oldSearchParam.pickUpDate?.getString() {
            return true
        }
        if searchParams.returnDate?.getString() != oldSearchParam.returnDate?.getString() {
            return true
        }
        if searchParams.pickUpTime?.getHour() != oldSearchParam.pickUpTime?.getHour() {
            return true
        }
        if searchParams.returnTime?.getHour() != oldSearchParam.returnTime?.getHour() {
            return true
        }
        if searchParams.pickUpLocation != oldSearchParam.pickUpLocation {
            return true
        }
        if searchParams.returnLocation != oldSearchParam.returnLocation {
            return true
        }
        return false
        
    }
    
    ///check if all fields filled
    func checkSearchDatas(searchDateModel: SearchDateModel) -> [ValidationType]{
        var result = [ValidationType]()
        
        if searchDateModel.pickUpDay == nil  || searchDateModel.returnDay == nil {
            result.append(.date)
        }
        if searchDateModel.pickUpTime == Constant.Texts.pickUpTime ||  searchDateModel.returnTime == Constant.Texts.returnTime {
            result.append(.time)
        }
        if searchDateModel.pickUpLocation == Constant.Texts.pickUpLocation  {
            result.append(.pickUplocation)
        }
        if searchDateModel.returnLocation == Constant.Texts.returnLocation  {
            result.append(.returnlocation)
        }
        if result.count == 0 {
            result.append(.success)
        }
        return result
    }
    
    /// if Reservation date more than one month
    func checkReservationMonth(pickupDate: Date?, returnDate: Date?) -> Bool {        
        return Date().getComponentsMonth(fromDate: pickupDate, toDate: returnDate)
    }
    
    /// if the booking time during working hours
    func checkReservationTimes(pickupTime: Date?, returntime: Date?) -> Bool {
        
        return Date().dateIsInsideRange(fromTime: pickupTime, toTime: returntime)
    }
    
    //MARK: CUSTOM LOCATION PAGE  CHECKING
    //MARK: ------------------------
    
    ///if new marker position in Inactive Coordinate
    func checkMarkerInInactiveCoordinate(fromCoordinate: CLLocationCoordinate2D,
                                         toCoordinate:CLLocationCoordinate2D,
                                         radius: Double) -> Bool {
        
        if calculateDistance(fromCord2D: fromCoordinate, toCord2D: toCoordinate) > radius {
            print("YOU ARE OUT OF circle")
            return false
        } else {
            print("YOU ARE IN circle")
            return true
        }
        
    }
    func calculateDistance(fromCord2D: CLLocationCoordinate2D, toCord2D: CLLocationCoordinate2D) -> Double {
        
        let fromCoordinate = CLLocation(latitude: fromCord2D.latitude, longitude: fromCord2D.longitude)
        let toCoordinate = CLLocation(latitude: toCord2D.latitude, longitude:  toCord2D.longitude)
        let distanceInMeters = fromCoordinate.distance(from: toCoordinate)
        return distanceInMeters
    }
    
    //MARK: CHAT PAGE  CHECKING
    //MARK: ------------------------
    
    ///Is filled in email address
    func isFilledInEmail(email: String) -> Bool {
        return true
        
    }
    
}
