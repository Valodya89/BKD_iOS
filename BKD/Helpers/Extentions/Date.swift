//
//  Date.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-05-21.
//

import UIKit

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getMonthAndWeek(lng: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: lng) as Locale
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: self)
        formatter.dateFormat = "E"
        let day = formatter.string(from: self)
        return month + " " + day
    }
    func getComponentsMonth(fromDate: Date?, toDate: Date?) -> Bool {
        guard let fromDate = fromDate, let toDate = toDate else {
            return false
        }
        let components = Calendar.current.dateComponents([.month], from: fromDate, to: toDate)
        return components.month! > 0 ?  true : false
    }
    
//    func dateIsInsideRange(fromTime: Date?, toTime: Date?) -> Bool {
//        guard let fromTime = fromTime, let toTime = toTime else {
//            return false
//        }
//        let start = self.stringToDateTime(time: Constant.Texts.startWorkingHour)
//        let end = self.stringToDateTime(time: Constant.Texts.endWorkingHour)
//
//       // let now = Date()
//       // let soon = Date().addingTimeInterval(5000)
//      //  let later = Date().addingTimeInterval(10000)
//        let range = start...end
//        if range.contains(fromTime) {
//            print("The date is inside the range")
//        } else {
//            print("The date is outside the range")
//        }
//
//        if range.contains(toTime) {
//            print("The date is inside the range")
//        } else {
//            print("The date is outside the range")
//        }
//        return true
//    }
    
    func getHour() -> String {
        let forrmater = DateFormatter()
        forrmater.dateFormat = "HH:mm"
        return forrmater.string(from: self)

    }
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
       return dateFormatter.string(from: self)
    }
    func stringToDateTime(time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current

       // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:time)!
        return date
    }
func dateIsInsideRange(fromTime: Date?, toTime: Date?) -> Bool {
    guard let fromTime = fromTime, let toTime = toTime  else {
        return true
    }
    if dateIsInRange(time: fromTime) && dateIsInRange(time: toTime) {
        return true
    }
    return false
}
    func dateIsInRange(time: Date?) -> Bool {
        let now = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

            let nowDateValue = now as Date
            let todayAtSevenAM = calendar.date(bySettingHour: 7, minute: 30, second: 0, of: nowDateValue, options: [])
            let todayAtTenPM = calendar.date(bySettingHour: 18, minute: 30, second: 0, of: nowDateValue, options: [])

        if time! >= todayAtSevenAM! &&
            time! <= todayAtTenPM!
            {
            print ("date is in range")
            return true
        } else {
            print ("date is out range")
            return false
        }
    }
    
}
