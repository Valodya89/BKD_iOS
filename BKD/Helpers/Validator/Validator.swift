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
    case times
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
        if searchParams.category != oldSearchParam.category {
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
        if searchDateModel.pickUpTime == "" ||  searchDateModel.returnTime == "" {
            result.append(.times)
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
    
    ///check if will active reserve
    func checkReserve(searchModel: SearchModel) -> Bool{
        
        guard let _ = searchModel.pickUpDate,
              let _ = searchModel.returnDate,
              let _ = searchModel.pickUpTime,
              let _ = searchModel.returnTime,
              let _ = searchModel.pickUpLocation,
              let _ = searchModel.returnLocation else {
            return false
        }
        return true
}

/// if Reservation date more than one month
func checkReservationMonth(pickupDate: Date?, returnDate: Date?) -> Bool {
    return Date().getComponentsMonth(fromDate: pickupDate, toDate: returnDate)
}


/// if the booking time during working hours
func checkReservationTime(time: Date?, settings: Settings) -> Bool {
    guard let _ = time else { return false}
    
    let startTimeDate = settings.workStart.stringToDate()
    let endTimeDate = settings.workEnd.stringToDate()

    print(startTimeDate.getString())
    print(endTimeDate.getString())

    return time!.dateIsInRange(startTime: startTimeDate,
                                endTime: endTimeDate)
}
    
/// if the booking duration more than half an hour
func checkReservationReturnTime(pickUpDate: Date,
                                returnDate: Date,
                                pickUpTime:Date,
                                returnTime: Date) -> Bool {
    if pickUpDate.hasSame(Calendar.Component.day, as: returnDate) &&  pickUpDate.hasSame(Calendar.Component.month, as: returnDate) && pickUpDate.hasSame(Calendar.Component.year, as: returnDate) {
        
//    }
//    if pickUpDate.isSameDates(date: returnDate) {
        let diff = Int(returnTime.timeIntervalSince1970 - pickUpTime.timeIntervalSince1970)
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return (minutes >= 29 || hours > 0 )
    }
    return true
}
    
    
    ///Check if reservation more then 90 days
    func checkReservation90Days(search: SearchModel) -> Bool {
        
        guard let pickUpDate = search.pickUpDate,
              let returnDate = search.returnDate,
              let pickupTime = search.pickUpTime,
              let returnTime = search.returnTime else {
                  return false
              }
        let hours = Date().getHoursFromDates(start: pickUpDate,
                                             end: returnDate,
                                             startTime: pickupTime,
                                             endTime: returnTime)
        let days = Date().getDaysFromDates(start: pickUpDate,
                                           end: returnDate,
                                           hours: hours)
        return days > 90
    }

//MARK: -- Custom location checking
    
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
   
    ///Is valid  email address
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //MARK: SIGNIN  CHECKING
    //MARK: ------------------------
    func areFieldsFilled(firstStr: String?, secondStr: String?) -> Bool {
        if firstStr!.count > 0 && secondStr!.count > 0 {
            return true
        }
        return false
    }
    
    //MARK: REGRISTRATION  CHECKING
    //MARK: ------------------------
    func areFieldsFilled(email: String?,
                         password: String?,
                         confirmpassword: String?) -> Bool {
        if email?.count ?? 0 > 0 &&
            password?.count ?? 0 > 0 &&
            confirmpassword?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}
