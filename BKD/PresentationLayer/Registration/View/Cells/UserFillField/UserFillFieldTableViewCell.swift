//
//  UserFillFieldTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

enum ViewType: String, CaseIterable {
    case button = "button"
    case city = "City"
    case country = "Country"
    case phone = "phone"
    case textFl = "txtFl"
    case nationalRegister = "national register"
    
    case name = "name"
    case surname = "surname"
    case dateOfBirth = "dateOfBirth"
    case street = "street"
    case house = "house"
    case mailBox = "mailBox"
    case countryId = "countryId"
    case zip = "zip"
    //case city = "city"
    case nationalRegisterNumber = "nationalRegisterNumber"
    case drivingLicenseNumber = "drivingLicenseNumber"
   
    
    case expiryDate = "Expiry date"
    case expiryDateDrivingLicense = "Expiry date of the Driving license"
    case issueDateDrivingLicense = "Issue date of the Driving license"
    
}
//
//"name": "Valodya",
//  "surname": "Galstyan",
//  "phoneNumber": "+37441099906",
//  "dateOfBirth": "15-37-2021",
//  "street": "some street",
//  "house": "11",
//  "mailBox": "374",
//  "countryId": "60e30c6e89bf4b6b024559a1",
//  "zip": "4sdf42ds4f",
//  "city": "Yerevan",
//  "nationalRegisterNumber": "1245454534"



protocol UserFillFieldTableViewCellDelegate: AnyObject {
    func didPressStart()
    func didReturnTxtField(txt: String?, index: Int)
    func didBeginEdithingTxtField(txtFl: UITextField)
    func willOpenPicker(textFl: UITextField, viewType: ViewType)
    func willOpenAutocompleteViewControlle()
    func updateUserData(dataType: ViewType, data: String)
}

class UserFillFieldTableViewCell: UITableViewCell {
    static let identifier = "UserFillFieldTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var mStartBtn: UIButton!
   // @IBOutlet weak var mTextLb: UILabelPadding!
    @IBOutlet weak var mTextFl: TextField!
    @IBOutlet weak var mBorderV: UIView!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mDropDownPlaceholderLb: UILabelPadding!
    
    var viewType = ViewType(rawValue: Constant.Texts.txtFl)
    weak var delegate: UserFillFieldTableViewCellDelegate?

    var placeholder: String? {
        
        didSet {
            if placeholder == Constant.Texts.name {
                viewType = .name
            } else if placeholder == Constant.Texts.surname {
                viewType = .surname
            } else if placeholder == Constant.Texts.streetName {
                viewType = .street
            } else if placeholder == Constant.Texts.houseNumber {
                viewType = .house
            } else if placeholder == Constant.Texts.mailboxNumber {
                viewType = .mailBox
            } else if placeholder == Constant.Texts.country {
                viewType = .country
            } else if placeholder == Constant.Texts.zipNumber {
                viewType = .zip
            } else if placeholder == Constant.Texts.city {
                viewType = .city
            } else if placeholder == Constant.Texts.drivingLicenseNumber {
                viewType = .drivingLicenseNumber
            }
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    override func prepareForReuse() {
        mTextFl.text = ""
       // mTextLb.text = ""
        mDropDownPlaceholderLb.text = ""
        mDropDownImgV.setTintColor(color: color_alert_txt!)

        placeholder = ""
        mTextFl.isHidden = false
        mStartBtn.isHidden = true
        mBorderV.isHidden = true
       // mTextLb.isHidden = true
        mDropDownImgV.isHidden = true
        mDropDownPlaceholderLb.isHidden = true
        mTextFl.inputAccessoryView = nil
        mTextFl.inputView = nil
        mTextFl.keyboardType = .default
        mTextFl.textColor = color_alert_txt!
        mTextFl.backgroundColor = .clear
        mTextFl.tintColor = color_navigationBar!
        
        mDropDownPlaceholderLb.backgroundColor = .clear
        mBorderV.setBackgroundColorToCAShapeLayer(color: .clear)
        mBorderV.bringSubviewToFront(mTextFl)
        mBorderV.bringSubviewToFront(mDropDownImgV)
     //  mTextLb.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 8.0)
        mDropDownImgV.image = img_dropDown_light
       
    }
    
    
    func setUpView() {
        mStartBtn.layer.cornerRadius = mStartBtn.frame.height/2
        mStartBtn.setBorder(color: color_navigationBar!, width: 1.0)
        mBorderV.roundCornersWithBorder(corners: [ .topLeft, .topRight, .bottomRight ], radius: 8.0, borderColor: color_navigationBar!, borderWidth: 1)
        
       // mTextLb.backgroundColor = color_navigationBar!
       // mTextLb.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 8.0)
        mTextFl.text = nil
        mTextFl.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    /// Set cell info
    func setCellInfo(item: RegistrationBotModel, index: Int) {
        mTextFl.tag = index
        placeholder = item.userRegisterInfo?.placeholder
        if item.viewDescription == Constant.Texts.button {
            mStartBtn.isHidden = false
            mBorderV.isHidden = true
            if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
                pressStart()
            }
        } else {
            mBorderV.isHidden = false
            mStartBtn.isHidden = true
            if ((item.userRegisterInfo?.string) != nil) && item.userRegisterInfo?.isFilled == true {
                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
            } else {
                mTextFl.setPlaceholder(string: item.userRegisterInfo?.placeholder ?? "", font: font_bot_placeholder!, color: color_email!)
            }
            
            if placeholder == Constant.Texts.country {
                mDropDownImgV.isHidden = false
            }
        }
    }
    
    ///Press Start button
    private func pressStart() {
        mStartBtn.setTitleColor(color_selected_start, for: .normal)
        mStartBtn.isUserInteractionEnabled = false
        mStartBtn.backgroundColor = color_navigationBar!
        mStartBtn.layer.borderWidth = 0
    }
    
    ///Fill text filed data
    private func textFiledFilled(txt: String) {
        mTextFl.text = txt
        mTextFl.backgroundColor = color_navigationBar
        if placeholder == Constant.Texts.country {
            mDropDownImgV.isHidden = false
            mDropDownImgV.setTintColor(color: .white)
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
        mTextFl.textColor = .white

    }
    
    @IBAction func start(_ sender: UIButton) {
        pressStart()
        delegate?.didPressStart()
    }
     
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension UserFillFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            textField.tintColor = .white

            delegate?.didReturnTxtField(txt: textField.text, index:textField.tag)
            
            delegate?.updateUserData(dataType: viewType!, data:  textField.text!)

            textFiledFilled(txt: textField.text!)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if placeholder == Constant.Texts.country {
            textField.becomeFirstResponder()

            delegate?.willOpenPicker(textFl: textField, viewType: viewType!)
            textField.tintColor = .clear
        } else if placeholder == Constant.Texts.city {
            delegate?.willOpenAutocompleteViewControlle()
        } else {
            textField.becomeFirstResponder()
            delegate?.didBeginEdithingTxtField(txtFl: textField)
            if ((placeholder?.contains("number")) == true) {
                textField.keyboardType = .numbersAndPunctuation
            }
        }
        
    }

}

    

