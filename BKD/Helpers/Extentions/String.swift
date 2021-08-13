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
}

