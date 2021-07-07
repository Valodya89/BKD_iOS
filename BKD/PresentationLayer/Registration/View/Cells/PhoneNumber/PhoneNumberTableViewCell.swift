//
//  PhoneNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

protocol PhoneNumberTableViewCellDelegate: AnyObject {
    func didPressCountryCode()
    func didReturnTxtField(text: String?)
}

class PhoneNumberTableViewCell: UITableViewCell {
    
    static let identifier = "PhoneNumberTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    //MARK: Outlets
    @IBOutlet weak var mFlagImgV: UIImageView!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mCountryCodeBtn: UIButton!
    @IBOutlet weak var mPhoneNumberBckgV: UIView!
    @IBOutlet weak var mCodeLb: UILabel!
    @IBOutlet weak var mPhoneNumberTxtFl: TextField!
    
    
    weak var delegate: PhoneNumberTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView(){
        mPhoneNumberBckgV.roundCornersWithBorder(corners: [.bottomRight, .topLeft, .topRight], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellInfo(item: RegistrationBotModel) {
        //depend on current language
        let placehoder  = "-- -- --"
        let code = "+32 3"
        mCodeLb.text = code
        if ((item.userRegisterInfo?.string) != nil) && item.userRegisterInfo?.isFilled == true {
            textFiledFilled(txt: (item.userRegisterInfo?.string)!)
        } else {
            mPhoneNumberTxtFl.setPlaceholder(string: placehoder, font: font_chat_placeholder!, color: color_email!)
        }
    }
    
    private func textFiledFilled(txt: String) {
        mPhoneNumberBckgV.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
        mPhoneNumberTxtFl.text = txt
        mPhoneNumberTxtFl.textColor = .white
        mCodeLb.textColor = .white
        mDropDownImgV.setTintColor(color: .white)
        mPhoneNumberBckgV.isUserInteractionEnabled = false
        mPhoneNumberBckgV.bringSubviewToFront(mCodeLb)
        mPhoneNumberBckgV.bringSubviewToFront(mPhoneNumberTxtFl)
        mPhoneNumberBckgV.bringSubviewToFront(mFlagImgV)
        mPhoneNumberBckgV.bringSubviewToFront(mDropDownImgV)
    }

    
    @IBAction func countryCode(_ sender: UIButton) {
        delegate?.didPressCountryCode()
    }
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension PhoneNumberTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            delegate?.didReturnTxtField(text: textField.text)
            textFiledFilled(txt: textField.text!)
        } else {
            mCodeLb.textColor = color_email!
            mCodeLb.font = font_chat_placeholder!
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mCodeLb.textColor = color_alert_txt!
        mCodeLb.font = font_alert_cancel
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let width = getWidth(text: textField.text!)
//        if  mTextFlWidth.constant < width && width <= 270 {
//            mTextFlWidth.constant = width
//            self.layoutIfNeeded()
//        }
        return true
    }
    
//    private  func getWidth(text: String) -> CGFloat {
//
//        let txtField = UITextField(frame: .zero)
//        txtField.text = text
//        txtField.sizeToFit()
//        return txtField.frame.size.width
//    }
}
