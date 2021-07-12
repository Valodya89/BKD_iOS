//
//  NationalRegisterNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit


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
    @IBOutlet weak var mTextFl: TextField!
    @IBOutlet weak var mCountryTxtFl: TextField!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mCountryLb: UILabelPadding!
//    @IBOutlet weak var mStackVHeight: NSLayoutConstraint!
    
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
        
    }
    
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            delegate?.didReturnTxt(txt: textField.text)
            textFiledFilled(txt: textField.text!)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mCountryTxtFl {
            mCountryLb.isHidden = false
            delegate?.willOpenPicker(textFl: textField)
        }else {
            textField.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let width = getWidth(text: textField.text!)
//        if  mTextFlWidth.constant < width && width <= 270 {
//            mTextFlWidth.constant = width
//            self.layoutIfNeeded()
//        }
        return true
    }
    
}
