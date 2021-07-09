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

}

protocol UserFillFieldTableViewCellDelegate: AnyObject {
    func didPressStart()
    func didReturnTxtField(txt: String?)
    func didBeginEdithingTxtField(txtFl: UITextField)
    func willOpenPicker(textFl: UITextField, viewType: ViewType)
}

class UserFillFieldTableViewCell: UITableViewCell {
    static let identifier = "UserFillFieldTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var mStartBtn: UIButton!
    @IBOutlet weak var mTextLb: UILabelPadding!
    @IBOutlet weak var mTextFl: TextField!
    @IBOutlet weak var mTextFlWidth: NSLayoutConstraint!
    @IBOutlet weak var mBorderV: UIView!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mDropDownPlaceholderLb: UILabelPadding!
    var placeholder: String?
    var viewType = ViewType(rawValue: "txtFl")
    
    weak var delegate: UserFillFieldTableViewCellDelegate?
//    var didPressStart: (() -> Void)?
//    var didReturnTxtField: ((String?) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    override func prepareForReuse() {
        mTextFl.text = ""
        mTextLb.text = ""
        mDropDownPlaceholderLb.text = ""
        placeholder = ""
        mTextFl.isHidden = false
        mStartBtn.isHidden = true
        mBorderV.isHidden = true
        mTextLb.isHidden = true
        mDropDownImgV.isHidden = true
        mDropDownPlaceholderLb.isHidden = true
        mTextFl.textColor = color_navigationBar!
        mTextFl.inputAccessoryView = nil
        mTextFl.inputView = nil
        // mTextFl.isUserInteractionEnabled = true
        mTextFl.backgroundColor = .clear
        mBorderV.setBackgroundColorToCAShapeLayer(color: .clear)
        mBorderV.bringSubviewToFront(mTextFl)
        mBorderV.bringSubviewToFront(mDropDownImgV)
        mTextLb.backgroundColor = color_dark_register
        mTextLb.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 8.0)
        mTextLb.textColor = .white
        mDropDownImgV.image = img_dropDown_light
        mDropDownPlaceholderLb.backgroundColor = .clear
        mTextFl.keyboardType = .default

    }
    
    
    func setUpView() {
        // mStartBtn.layer.cornerRadius = 36
        
        mStartBtn.roundCornersWithBorder(corners: [ .allCorners], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
        
        mBorderV.roundCornersWithBorder(corners: [ .topLeft, .topRight, .bottomRight ], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        
        mTextLb.backgroundColor = color_dark_register
        mTextLb.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 8.0)
        mTextFl.text = nil
        mTextFl.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellInfo(item: RegistrationBotModel) {
        placeholder = item.userRegisterInfo?.placeholder
        viewType = ViewType(rawValue: placeholder ?? "")
        
        if item.viewDescription == "button" {
            mStartBtn.isHidden = false
            mBorderV.isHidden = true
            mTextLb.isHidden = true
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
              // viewType = ViewType(rawValue: (item.userRegisterInfo?.placeholder)!)
            }
            
            
            if placeholder == "Country" || placeholder == "City" {
                mDropDownPlaceholderLb.text = placeholder
                mDropDownImgV.isHidden = false
                
            }
            
            
        }
    }
    
    private func pressStart() {
        mStartBtn.setTitleColor(color_selected_start, for: .normal)
        mStartBtn.isUserInteractionEnabled = false
        mStartBtn.backgroundColor = color_dark_register!
        mStartBtn.layer.cornerRadius = 10
//        mStartBtn.setBackgroundColorToCAShapeLayer(color: color_navigationBar!)
    }
    
    private func textFiledFilled(txt: String) {

        mTextLb.text = txt
        mTextLb.isHidden = false
        mBorderV.isHidden = true
       
        if placeholder == "Country" || placeholder == "City" {
            mDropDownImgV.isHidden = false
            mDropDownImgV.setTintColor(color: .white)
            mBorderV.bringSubviewToFront(mDropDownImgV)
            mTextLb.bringSubviewToFront(mDropDownImgV)
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        pressStart()
        //        sender.setGradientWithCornerRadius(cornerRadius: 36, startColor: color_reserve_inactive_start!, endColor: color_reserve_inactive_end!)
       // didPressStart?()
        delegate?.didPressStart()
        
    }
    
    
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension UserFillFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            delegate?.didReturnTxtField(txt: textField.text)
            textFiledFilled(txt: textField.text!)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if placeholder == "Country" || placeholder == "City" {
            mDropDownPlaceholderLb.isHidden = false
            delegate?.willOpenPicker(textFl: textField, viewType: viewType!)
        }else {
            delegate?.didBeginEdithingTxtField(txtFl: textField)
            if ((placeholder?.contains("number")) == true) {
                textField.keyboardType = .numbersAndPunctuation
            }
                
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
    
//    private  func getWidth(text: String) -> CGFloat {
//
//        let txtField = UITextField(frame: .zero)
//        txtField.text = text
//        txtField.sizeToFit()
//        return txtField.frame.size.width
//    }
}
