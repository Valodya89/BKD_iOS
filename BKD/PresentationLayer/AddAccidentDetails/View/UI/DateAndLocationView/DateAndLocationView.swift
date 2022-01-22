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
    
    var date: Date?
    var time: Date?
    var location:String?
    
    //MARK: -- Lifecycle
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
        mDateTxtFl.setPlaceholder(string: Constant.Texts.selectDate, font: font_placeholder!, color: color_search_placeholder!)
        mTimeTxtFl.setPlaceholder(string: Constant.Texts.selectTime, font: font_placeholder!, color: color_search_placeholder!)
        mLocationTxtFl.setPlaceholder(string: Constant.Texts.accidentAddress, font: font_placeholder!, color: color_search_placeholder!)
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
        mDateBtn.layer.borderColor = color_navigationBar!.cgColor
        date = datePicker.date
        mDateTxtFl.isHidden = true
        mDayBtn.isHidden = false
        mMonthBtn.isHidden = false
        mDayBtn?.setTitle(String(datePicker.date.getDay()), for: .normal)
        mMonthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)

    }
    
    
     ///Update time information
    func updateTime(datePicker: UIDatePicker) {
        mTimeBtn.layer.borderColor = color_navigationBar!.cgColor
        time = datePicker.date
        mTimeTxtFl.text = String(datePicker.date.getTime())
    }
    
    ///Are filled all fields
    func checkAllFieldsAreFilled() -> Bool {
        var areFilled =  true
        if date == nil  {
            mDateBtn.layer.borderColor = color_error!.cgColor
            areFilled = false
          }
        if time == nil {
            mTimeBtn.layer.borderColor = color_error!.cgColor
            areFilled = false
        }
        if location == nil ||  location?.count == 0 {
            mLocationV.layer.borderColor = color_error!.cgColor
            areFilled = false
          }
        return areFilled
    }
    
    //MARK: -- Actios
    
    @IBAction func date(_ sender: UIButton) {
        dateAndLocationState = .date
        mDateTxtFl.becomeFirstResponder()
    }
    
    @IBAction func time(_ sender: UIButton) {
        dateAndLocationState = .time
        mDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mLocationTxtFl {
            mLocationV.layer.borderColor = color_navigationBar!.cgColor
        }
        return true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mLocationTxtFl {
            location = textField.text
        }
        mLocationTxtFl.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mLocationTxtFl {
            let fullText = textField.text! + string
            if fullText.count > 0 {
                location = textField.text
            }
        }
        return true
    }
    
}
