//
//  String.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-07-21.
//

import UIKit

extension String {
    
    func isNumber() -> Bool {
        return Int(self) != nil || Double(self) != nil
        }
    
    
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.defaultDate = Date()

        let date = dateFormatter.date(from:self)!
        print(date)
        return date
    }
    
    func stringToDateWithoutTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self)!
        return date
    }
    
    ///Is contain only latters
//    func containsOnlyLetters() -> Bool {
//       for chr in self {
//          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
//             return false
//          }
//       }
//       return true
//    }
    
    
    
    ///Is  number
    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }

}


extension Character {
    ///Is character
    var isCharacter: Bool {
        
        if (!(self >= "a" && self <= "z") && !(self >= "A" && self <= "Z") ) {
            return false
        }
        return true
    }
}
