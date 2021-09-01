//
//  CalendarTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

protocol CalendarTableViewCellDelegate: AnyObject {
    func willOpenPicker(textFl: UITextField, isExpireDate: Bool)
    func updateData(viewType: ViewType, calendarData: String)
}
class CalendarTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "CalendarTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK: Outlets
    @IBOutlet weak var mCalendarBckgV: UIView!
    @IBOutlet weak var mCalendarImgV: UIImageView!
    @IBOutlet weak var mDayLb: UILabel!
    @IBOutlet weak var mMonthLb: UILabel!
    @IBOutlet weak var mYearLb: UILabel!
    @IBOutlet weak var mDaySeparatorV: UIView!
    @IBOutlet weak var mMonthSeparatorV: UIView!
    @IBOutlet weak var mStackV: UIStackView!
    @IBOutlet weak var mCalendarTxtFl: UITextField!
    
    var isExpireDate = false
    private var viewType:ViewType = .dateOfBirth
    weak var delegate: CalendarTableViewCellDelegate?
    
    private var viewDescription: String? {
        didSet {
            if viewDescription == Constant.Texts.dateOfBirth {
                viewType = .dateOfBirth
            } else if viewDescription == Constant.Texts.expityDate {
                viewType = .expityDate
            } else if  viewDescription == Constant.Texts.issueDateDrivingLicense {
                viewType = .issueDateDrivingLicense
            } else if viewDescription == Constant.Texts.expityDateDrivingLicense {
                viewType = .expityDateDrivingLicense
            }
                 
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        mCalendarTxtFl.delegate = self
        mCalendarBckgV.roundCornersWithBorder(corners: [.bottomRight, .topLeft, .topRight], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
    }
    
    override func prepareForReuse() {
        mCalendarBckgV.setBackgroundColorToCAShapeLayer(color: .clear)
        mCalendarBckgV.roundCornersWithBorder(corners: [.bottomRight, .topLeft, .topRight], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        mCalendarImgV.setTintColor(color: color_dark_register!)
        mDayLb.text = Constant.Texts.Day
        mMonthLb.text = Constant.Texts.Month
        mYearLb.text = Constant.Texts.year
        mDayLb.font = font_bot_placeholder
        mMonthLb.font = font_bot_placeholder
        mYearLb.font = font_bot_placeholder
        mDayLb.textColor = color_email!
        mMonthLb.textColor = color_email!
        mYearLb.textColor = color_email!
        mCalendarBckgV.isUserInteractionEnabled = true
        mCalendarBckgV.bringSubviewToFront(mCalendarTxtFl)
        mCalendarTxtFl.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  setCellInfo(item: RegistrationBotModel) {
        if let date = item.userRegisterInfo?.date {
            viewDescription = item.viewDescription
           // mDayLb.text = String(date.get(.day))
            mDayLb.text = String(date.getDay())
            mMonthLb.text = date.getMonth(lng: "en")
            mYearLb.text = String(date.getYear())
            filedsFilled(date: date)
        }
    }
    
    private func filedsFilled(date: Date) {
        mCalendarBckgV.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
//        mCalendarBckgV.setBorderColorToCAShapeLayer(color: color_dark_register!)

        mDayLb.textColor = .white
        mMonthLb.textColor = .white
        mYearLb.textColor = .white
        mDayLb.font = font_alert_cancel
        mMonthLb.font = font_alert_cancel
        mYearLb.font = font_alert_cancel
        mCalendarImgV.setTintColor(color: .white)
        mCalendarBckgV.isUserInteractionEnabled = false
        mCalendarBckgV.bringSubviewToFront(mStackV)
        mCalendarBckgV.bringSubviewToFront(mCalendarImgV)
         
        delegate?.updateData(viewType: viewType, calendarData: "\( mDayLb.text!)-\( date.get(.month))-\(mYearLb.text!)")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.willOpenPicker(textFl: textField, isExpireDate: isExpireDate)
    }

    
}
