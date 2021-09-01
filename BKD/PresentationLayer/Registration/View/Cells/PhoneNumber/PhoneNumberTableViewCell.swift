//
//  PhoneNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit
import PhoneNumberKit
import SwiftMaskTextfield


protocol PhoneNumberTableViewCellDelegate: AnyObject {
    func didPressCountryCode()
    func didReturnTxtField(text: String, code:String)
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
    @IBOutlet weak var mPhoneNumberTxtFl: SwiftMaskTextfield!
    
    
    var selectedCountry: PhoneCode?
    let phoneNumberKit = PhoneNumberKit()
    var validFormPattern: Int = 0
    var phoneNumber: String? {
        get {
            return "\(selectedCountry?.code ?? "NULL") \(mPhoneNumberTxtFl.text ?? "NULL")".replacingOccurrences(of: "_", with: "").replacingOccurrences(of: " ", with: "")
        } set {
            guard let newValue = newValue else {
                return
            }
            guard !newValue.isEmpty else {
                mPhoneNumberTxtFl.text = ""
                return
            }
            
            if (newValue.isNumber() == false)  {
                mPhoneNumberTxtFl.text = String(newValue.dropLast())
                
            }
            
            

            guard let phoneNumber = try? phoneNumberKit.parse(newValue, ignoreType: true) else { return }
//            mCodeLb.text = "+" + String(phoneNumber.countryCode)
//            mPhoneNumberTxtFl.text = String(phoneNumber.nationalNumber)
        }
    }
    
    
    var isValid: Bool {
        return mPhoneNumberTxtFl.text?.count == validFormPattern
    }
    

    weak var delegate: PhoneNumberTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForReuse() {
            
        }
    func setUpView(){
        mPhoneNumberBckgV.roundCornersWithBorder(corners: [.bottomRight, .topLeft, .topRight], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
    }
 

/// Set Cell Info
    func setCellInfo(item: RegistrationBotModel) {
        let placehoder  = RegistrationViewModel().getPhonePlaceholder(format: (selectedCountry?.mask!)!)
        
        mCodeLb.text = selectedCountry?.code
        mFlagImgV.image = selectedCountry?.imageFlag
        if ((item.userRegisterInfo?.string) != nil) && item.userRegisterInfo?.isFilled == true {
            textFiledFilled(txt: (item.userRegisterInfo?.string)!)
        } else {
            mPhoneNumberTxtFl.setPlaceholder(string: placehoder, font: font_search_title!, color: color_email!)
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
        mDropDownImgV.setTintColor(color: .white)
    }

    
    @IBAction func countryCode(_ sender: UIButton) {
        delegate?.didPressCountryCode()
    }
    
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension PhoneNumberTableViewCell: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mCodeLb.textColor = color_alert_txt!
        mCodeLb.font = font_alert_cancel
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//        return true
        textField.resignFirstResponder()
        if textField.text?.count == validFormPattern {
            
            delegate?.didReturnTxtField(text: textField.text!, code: mCodeLb.text!)
            textFiledFilled(txt: textField.text!)
        } else {
            
            mCodeLb.textColor = color_email!
            mCodeLb.font = font_chat_placeholder!
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let fullText = textField.text! + string
        phoneNumber = fullText
        return fullText.count <= validFormPattern

    }
}
