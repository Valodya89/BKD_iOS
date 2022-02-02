//
//  UIDatePicker.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-02-22.
//

import UIKit


extension UIDatePicker {
    
    func configDatePicker() {

        if #available(iOS 14.0, *) {
        self.preferredDatePickerStyle = .wheels
        }
        self.datePickerMode = .date
        self.minimumDate =  Date()
        self.maximumDate =  Date().addMonths(12)
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.locale = Locale(identifier: "en")
    }
}
