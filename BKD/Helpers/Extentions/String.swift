//
//  String.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-07-21.
//

import UIKit

extension String {
    
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:self)!
        print(date)
        return date
    }
}
