//
//  DateAndLocationView.swift
//  DateAndLocationView
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit
import SwiftUI

enum DateAndLocationState {
    case date
    case time
    case location
}

protocol DateAndLocationViewDelegate: AnyObject {
    func willOpenPicker (textFl: UITextField, dateAndLocationState: DateAndLocationState)
    
    func openMap()
    
}

class DateAndLocationView: UIView, UITextFieldDelegate {
    
    //MARK: --Outlets
    
    @IBOutlet weak var mDateAndLocationLb: UILabel!
    
    ///Date
    @IBOutlet weak var mDateBtn: UIButton!
    @IBOutlet weak var mDayBtn: UIButton!
    @IBOutlet weak var mMonthBtn: UIButton!
    @IBOutlet weak var mDateTxtFl: TextField!
    @IBOutlet weak var mCalendarImgV: UIImageView!

    ///Time
    @IBOutlet weak var mTimeBtn: UIButton!
    @IBOutlet weak var mTimeTxtFl: TextField!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    
    ///Location
    @IBOutlet weak var mLocationV: UIView!
    @IBOutlet weak var mMapBtn: UIButton!
    @IBOutlet weak var mLocationTxtFl: TextField!
    
   //MARK: -- Variables
    weak var delegate: DateAndLocationViewDelegate?
    var dateAndLocationState: DateAndLocationState?
    
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        configureDelegate()
    }

    func setupView() {
        //Set border
        
        mDateBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mTimeBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mLocationV.setBorder(color: color_navigationBar!, width: 1.0)
        
        //Set placeholder
        mDateTxtFl.setPlaceholder(string: Constant.Texts.selectDate, font: font_placeholder!, color: color_choose_date!)
        mTimeTxtFl.setPlaceholder(string: Constant.Texts.selectTime, font: font_placeholder!, color: color_choose_date!)
        mLocationTxtFl.setPlaceholder(string: Constant.Texts.accidentAddress, font: font_placeholder!, color: color_choose_date!)
        mMapBtn.setTitle("", for: .normal)
        
    }
    
    
    ///Configure delegates
    func configureDelegate() {
        mLocationTxtFl.delegate = self
        mDateTxtFl.delegate = self
        mTimeTxtFl.delegate = self
    }
    
    
    ///Update date information
    func updateDateInfo(datePicker: UIDatePicker)  {
        mDateTxtFl.isHidden = true
        mDayBtn.isHidden = false
        mMonthBtn.isHidden = false
        mDayBtn?.setTitle(String(datePicker.date.getDay()), for: .normal)
        mMonthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)

    }
    
    
     ///Update time information
    func updateTime(datePicker: UIDatePicker) {
        print (datePicker.date)

        mTimeTxtFl.text = String(datePicker.date.getTime())
    }
    
    
    
    //MARK: -- Actios
    
    @IBAction func date(_ sender: UIButton) {
        dateAndLocationState = .date
        mDateTxtFl.becomeFirstResponder()
    }
    
    @IBAction func time(_ sender: UIButton) {
        dateAndLocationState = .time
        mTimeTxtFl.becomeFirstResponder()
    }
    
    @IBAction func map(_ sender: UIButton) {
        delegate?.openMap()
    }
    
    
    //MARK: -- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mLocationTxtFl {
            dateAndLocationState = .location
        } else {
            delegate?.willOpenPicker(textFl: textField, dateAndLocationState: dateAndLocationState!)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mLocationTxtFl.resignFirstResponder()
        return true
    }
}
