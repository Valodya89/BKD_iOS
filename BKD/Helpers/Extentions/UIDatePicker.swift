//
//  UIDatePicker.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-02-22.
//

import UIKit


extension UIDatePicker {
    
    func configDatePicker(search: SearchModel, pickerState: DatePicker) {

        if #available(iOS 14.0, *) {
        self.preferredDatePickerStyle = .wheels
        }
        self.datePickerMode = .date
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.locale = Locale(identifier: "en")
        self.maximumDate =  Date().addMonths(12)
       if pickerState == .returnDate && search.pickUpDate != nil {
            self.minimumDate = search.pickUpDate
        } else {
            self.minimumDate =  Date()
        }

    }
}
