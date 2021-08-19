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
    
   
    
    ///Get month and week as string
    func getMonthAndWeek(lng: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: lng) as Locale
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: self)
        formatter.dateFormat = "E"
        let day = formatter.string(from: self)
        return month + " " + day
    }
    
    ///Get month as string
    func getMonth(lng: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: lng) as Locale
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: self)
        return month
    }
    
    ///Get year as string
    func getYear() -> String {
        let forrmater = DateFormatter()
        forrmater.dateFormat = "YYYY"
        return forrmater.string(from: self)
    }
    
    ///Get hour as string
    func getHour() -> String {
        let forrmater = DateFormatter()
        forrmater.dateFormat = "HH:mm"
        forrmater.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return forrmater.string(from: self)
    }
    
    ///Get components month
    func getComponentsMonth(fromDate: Date?, toDate: Date?) -> Bool {
        guard let fromDate = fromDate, let toDate = toDate else {
            return false
        }
        let components = Calendar.current.dateComponents([.month], from: fromDate, to: toDate)
        return components.month! > 0 ?  true : false
    }
    
    
    /// Format date
    func getDateByFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
        dateFormatter.dateFormat = "d MMM, YYYY"
        return dateFormatter.string(from: self)
    }
   
    ///Get Format date as string
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    
    ///Check if time in range
    func dateIsInRange(startTime: Date, endTime: Date) -> Bool {
        let now = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let hourStart = calendar.component(.hour, from: startTime)
        let minuteStart = calendar.component(.minute, from: startTime)
        let hourEnd = calendar.component(.hour, from: endTime)
        let minuteEnd = calendar.component(.minute, from: endTime)
        
        let nowDateValue = now as Date
        let todayAtSevenAM = calendar.date(bySettingHour: hourStart, minute: minuteStart, second: 0, of: nowDateValue, options: [])
        let todayAtTenPM = calendar.date(bySettingHour: hourEnd, minute: minuteEnd, second: 0, of: nowDateValue, options: [])
        
        if self >= todayAtSevenAM! &&
            self <= todayAtTenPM!
        {
            print ("date is in range")
            return true
        } else {
            print ("date is out range")
            return false
        }
    }
    
    ///Get additional days
    func  addDays(_ day: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = day // For removing one day (yesterday): -1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate!
    }
    
    ///Get additional hours
     func addHours(_ hours: Int) -> Date {
           var comps = DateComponents()
        comps.hour = hours
           let calendar = Calendar.current
           let result = calendar.date(byAdding: comps, to: self)
        return result!
       }
    
    ///Get additional weeks
    func addWeeks(_ weeks: Int) -> Date {
          var comps = DateComponents()
        comps.day = 7 * weeks
          let calendar = Calendar.current
          let result = calendar.date(byAdding: comps, to: self)
        return result!
      }
    
    ///Get additional months
    func addMonths(_ months: Int) -> Date {
          var comps = DateComponents()
        comps.month = months
          let calendar = Calendar.current
          let result = calendar.date(byAdding: comps, to: self)
        return result!
      }
    
    
    
    ///Compare two Dates with ignore time
    func isSameDates(date: Date?) -> Bool {
        guard let _ = date  else { return true }
        let order = Calendar.current.compare(self, to: date!, toGranularity: .hour)

        switch order {
        case .orderedSame:
            return true
        default :
            return false
        }
    }
    
    
    
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
            calendar.dateComponents([component], from: self, to: date).value(for: component)
        }

        func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
            let days1 = calendar.component(component, from: self)
            let days2 = calendar.component(component, from: date)
            return days1 - days2
        }

    /// Chaeck if dates same
        func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
            distance(from: date, only: component) == 0
        }
        
    
    ///Compare two hours
    func isSameHours(hour: Date?) -> Bool {
        guard let _ = hour  else { return true }
        let order = Calendar.current.compare(self, to: hour!, toGranularity: .day)

        switch order {
        case .orderedSame:
            return true
        default :
            return false
        }
    }
    
    /// is date between two dates
    func isBetween(start: Date,  end: Date) -> Bool {
            return (min(start, end) ... max(start, end)).contains(self)
        }

}
