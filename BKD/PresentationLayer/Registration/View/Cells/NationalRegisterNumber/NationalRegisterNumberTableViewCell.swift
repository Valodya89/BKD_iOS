//
//  NationalRegisterNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit
import PhoneNumberKit
import SwiftMaskTextfield


protocol NationalRegisterNumberTableViewCellDelegate: AnyObject {
    func didPressOtherCountryNational(isClicked: Bool)
    func didReturnTxt(txt: String?)
    func willOpenPicker(textFl: UITextField)
}

class NationalRegisterNumberTableViewCell: UITableViewCell {
    
    static let identifier = "NationalRegisterNumberTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet weak var mOtherCountryBtn: UIButton!
    @IBOutlet weak var mCountryBckV: UIView!
    @IBOutlet weak var mTextFl: SwiftMaskTextfield!
    @IBOutlet weak var mCountryTxtFl: TextField!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mCountryLb: UILabelPadding!
    
    var selectedCountry: Country?
    let phoneNumberKit = PhoneNumberKit()
    var validFormPattern: Int = 0
    var phoneNumber: String? {
        get {
            return "\(selectedCountry?.code ?? "NULL") \(mTextFl.text ?? "NULL")".replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        } set {
            guard let newValue = newValue else {
                return
            }
            guard !newValue.isEmpty else {
                mTextFl.text = ""
                return
            }
            
            if (newValue.isNumber() == false)  {
                mTextFl.text = String(newValue.dropLast())
                
            }

            guard let phoneNumber = try? phoneNumberKit.parse(newValue, ignoreType: true) else { return }
//            mCodeLb.text = "+" + String(phoneNumber.countryCode)
//            mPhoneNumberTxtFl.text = String(phoneNumber.nationalNumber)
        }
    }
    
    var isValid: Bool {
        return mTextFl.text?.count == validFormPattern
    }
    
    weak var delegate: NationalRegisterNumberTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    func  setUpView() {
        mOtherCountryBtn.titleLabel?.textAlignment = .center
        mTextFl.roundCornersWithBorder(corners: [.topLeft, .topRight, .bottomRight ], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        mOtherCountryBtn.roundCornersWithBorder(corners: [.allCorners ], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
        mCountryBckV.roundCornersWithBorder(corners: [.topLeft, .topRight, .bottomRight ], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        mDropDownImgV.setTintColor(color: color_dark_register!)
        mCountryTxtFl.setPlaceholder(string: Constant.Texts.country, font: font_bot_placeholder!, color: color_email!)
        mCountryTxtFl.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
    }
    
    override func prepareForReuse() {
        mDropDownImgV.setTintColor(color: color_dark_register!)
        mOtherCountryBtn.backgroundColor = .clear
        mOtherCountryBtn.layer.cornerRadius = 10
        mOtherCountryBtn.setTitleColor(color_dark_register!, for: .normal)
        mTextFl.inputView = nil
        mTextFl.inputAccessoryView = nil
        mCountryLb.text = Constant.Texts.country
        mCountryLb.textColor = color_email!
        mCountryLb.font = font_register_placeholder
        mCountryTxtFl.isHidden = false
        mCountryBckV.isHidden = true
        mCountryBckV.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        mOtherCountryBtn.setTitleColor(color_navigationBar!, for: .normal)
        
    }
    
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel) {
        let placehoder  = RegistrationViewModel().getPhonePlaceholder(format: (selectedCountry?.nationalDocumentMask!)!)
        mTextFl.setPlaceholder(string: placehoder, font: font_chat_placeholder!, color: color_email!)
        
        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
        } else if ((item.userRegisterInfo?.isOtherNational) != nil) && item.userRegisterInfo?.isOtherNational == true {
            
            otherCountryPressed()
            if let country = item.userRegisterInfo?.nationalString  {
                countryChoosen(country: country)
            }
        }
            
    }
    
    func textFiledFilled(txt: String) {
        mTextFl.text = txt
        mTextFl.textColor = .white
        self.isUserInteractionEnabled = false
        mTextFl.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
    }
    
    func countryChoosen(country: String) {
        DispatchQueue.main.async { [self] in
            mCountryLb.isHidden = false
            mCountryBckV.backgroundColor = color_dark_register!
            mCountryLb.text = country
            mDropDownImgV.setTintColor(color: .white)
            mCountryLb.textColor = .white
            mCountryLb.font = font_alert_cancel
            mCountryTxtFl.setPlaceholder(string: "", font: font_bot_placeholder!, color: color_email!)
            mCountryTxtFl.text = ""
            mCountryBckV.bringSubviewToFront(mDropDownImgV)
        }
    }
    
    /// other country national register button pressed
    private func otherCountryPressed() {
        mCountryBckV.isHidden = false
        mOtherCountryBtn.setTitleColor(color_selected_start, for: .normal)
        mOtherCountryBtn.backgroundColor = color_dark_register!
        mOtherCountryBtn.layer.cornerRadius = 10
    }
    

    
    @IBAction func otherCountry(_ sender: UIButton) {
            delegate?.didPressOtherCountryNational(isClicked: mCountryBckV.isHidden)
    }
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension NationalRegisterNumberTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mCountryTxtFl {
            mCountryLb.isHidden = false
            delegate?.willOpenPicker(textFl: textField)
        }else {
            textField.becomeFirstResponder()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count == validFormPattern {
            delegate?.didReturnTxt(txt: textField.text)
            textFiledFilled(txt: textField.text!)
        } else {
            
//            mCodeLb.textColor = color_email!
//            mCodeLb.font = font_chat_placeholder!
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

//    //@IBOutlet weak var mBorderV: UIView!
//    @IBOutlet weak var mOtherCountryBtn: UIButton!
//    @IBOutlet weak var mCountryBckV: UIView!
//    @IBOutlet weak var mTextFl: TextField!
//    @IBOutlet weak var mCountryTxtFl: TextField!
//    @IBOutlet weak var mDropDownImgV: UIImageView!
//    @IBOutlet weak var mCountryLb: UILabelPadding!
////    @IBOutlet weak var mStackVHeight: NSLayoutConstraint!
//
//
//    weak var delegate: NationalRegisterNumberTableViewCellDelegate?
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func draw(_ rect: CGRect) {
//        setUpView()
//    }
//
//    func setUpView()  {
//        mTextFl.roundCornersWithBorder(corners: [.topLeft, .topRight, .bottomRight], radius: 8, borderColor: color_navigationBar!, borderWidth: 1)
//
//        mOtherCountryBtn.roundCornersWithBorder(corners: [.allCorners], radius: 36, borderColor: color_navigationBar!, borderWidth: 1)
//
//        mCountryBckV.roundCornersWithBorder(corners: [.topLeft, .topRight, .bottomRight], radius: 8, borderColor: color_navigationBar!, borderWidth: 1)
//
//        mOtherCountryBtn.titleLabel?.textAlignment = .center
//        mCountryTxtFl.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
//        mDropDownImgV.setTintColor(color: color_alert_txt!)
//
//
//    }
//
//    override func prepareForReuse() {
//        setUpView()
//        self.isUserInteractionEnabled = true
//        mCountryBckV.isHidden = true
//        mCountryTxtFl.isHidden = false
//      //  mCountryTxtFl.textColor = color_email!
//       // mCountryTxtFl.font = font_bot_placeholder
//       // mCountryTxtFl.text = Constant.Texts.country
////        mCountryLb.textColor = color_email!
////        mCountryLb.font = font_bot_placeholder
////        mCountryLb.text = Constant.Texts.country
//        mOtherCountryBtn.backgroundColor = .clear
//        mOtherCountryBtn.setTitleColor(color_navigationBar!, for: .normal)
//
//       // mCountryTxtFl.backgroundColor = .clear
//
//    }
//
//
//    /// Set cell info
//    func  setCellInfo(item: RegistrationBotModel) {
//        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
//                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
//        } else if ((item.userRegisterInfo?.isOtherNational) != nil) && item.userRegisterInfo?.isOtherNational == true {
//            otherCountryPressed()
//            if let country = item.userRegisterInfo?.nationalString  {
//                countryChoosen(country: country)
//
//            }
//        }
//
//    }
//
//    func textFiledFilled(txt: String) {
//
//        //change backround color
//        mTextFl.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
//        mTextFl.setBorderColorToCAShapeLayer(color: color_dark_register!)
//        self.isUserInteractionEnabled = false
//    }
//
//    func countryChoosen(country: String) {
//        DispatchQueue.main.async {
//            self.mCountryTxtFl.text = country
//            self.mCountryTxtFl.textColor = .white
//            self.mCountryTxtFl.font = font_alert_cancel
//
//            self.mCountryLb.text = country
//            self.mCountryLb.textColor = .white
//            self.mCountryLb.font = font_alert_cancel
//
//            self.mCountryBckV.removeCAShapeLayer()
//            self.mCountryBckV.backgroundColor = color_dark_register!
//
//            self.mCountryTxtFl.backgroundColor = color_dark_register!
//            self.mDropDownImgV.setTintColor(color: .white)
//        }
//
//
//    }
//
//    /// other country national register button pressed
//    private func otherCountryPressed() {
//        //change backround color
//        mDropDownImgV.setTintColor(color: .white)
//
//        mOtherCountryBtn.removeCAShapeLayer()
//        mOtherCountryBtn.backgroundColor = color_dark_register
//        mOtherCountryBtn.setTitleColor(color_selected_start!, for: .normal)
//
//        mCountryBckV.isHidden = false
//    }
//
//
//
//    @IBAction func otherCountry(_ sender: UIButton) {
//            delegate?.didPressOtherCountryNational(isClicked: mCountryBckV.isHidden)
//    }
//    @IBAction func country(_ sender: UIButton) {
//
//        delegate?.willOpenPicker(textFl: mCountryTxtFl)
//    }
//}
//
//
////MARK: UITextFieldDelegate
////MARK: ---------------------------
//extension NationalRegisterNumberTableViewCell: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        if textField.text?.count ?? 0 > 0 {
//
//            delegate?.didReturnTxt(txt: textField.text)
//            textFiledFilled(txt: textField.text!)
//        }
//        return false
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == mCountryTxtFl {
//            delegate?.willOpenPicker(textFl: mCountryTxtFl)
//        }
//        textField.becomeFirstResponder()
//    }
//
//
//}



