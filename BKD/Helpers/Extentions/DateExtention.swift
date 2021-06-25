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
    
    
    func getHour() -> String {
        let forrmater = DateFormatter()
        forrmater.dateFormat = "HH:mm"
        return forrmater.string(from: self)
        
    }
    func getDateByFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
        dateFormatter.dateFormat = "d MMM, YYYY"
        return dateFormatter.string(from: self)
    }
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    func stringToDateTime(time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:time)!
        return date
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
    
    func  addDays(_ day: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = day // For removing one day (yesterday): -1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate!
    }
    
     func addHours(_ hours: Int) -> Date {
           var comps = DateComponents()
        comps.hour = hours
           let calendar = Calendar.current
           let result = calendar.date(byAdding: comps, to: self)
        return result!
       }
    
    func addWeeks(_ weeks: Int) -> Date {
          var comps = DateComponents()
        comps.day = 7 * weeks
          let calendar = Calendar.current
          let result = calendar.date(byAdding: comps, to: self)
        return result!
      }
    
    func addMonths(_ months: Int) -> Date {
          var comps = DateComponents()
        comps.month = months
          let calendar = Calendar.current
          let result = calendar.date(byAdding: comps, to: self)
        return result!
      }

}
