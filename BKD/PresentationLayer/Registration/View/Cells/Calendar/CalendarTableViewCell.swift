//
//  CalendarTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

protocol CalendarTableViewCellDelegate: AnyObject {
    func willOpenPicker(textFl: UITextField, isCalendar: Bool)
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
    
    weak var delegate: CalendarTableViewCellDelegate?

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
        mDayLb.text = Constant.Texts.day
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
        if item.userRegisterInfo?.date != nil {
           filedsFilled()
            mDayLb.text = String((item.userRegisterInfo?.date)!.get(.day))
            mMonthLb.text = (item.userRegisterInfo?.date)!.getMonth(lng: "en")
            mYearLb.text = String((item.userRegisterInfo?.date)!.getYear())
        }
    }
    
    private func filedsFilled() {
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
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.willOpenPicker(textFl: textField, isCalendar: true)
    }
    
}
