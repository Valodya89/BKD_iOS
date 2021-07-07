//
//  UserFillFieldTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

protocol UserFillFieldTableViewCellDelegate: AnyObject {
    func didPressStart()
    func didReturnTxtField(txt: String?)
    func willOpenPicker(textFl: UITextField, isCountry: Bool)
}

class UserFillFieldTableViewCell: UITableViewCell {
    static let identifier = "UserFillFieldTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var mStartBtn: UIButton!
    @IBOutlet weak var mTextFl: TextField!
    @IBOutlet weak var mTextFlWidth: NSLayoutConstraint!
    @IBOutlet weak var mBorderV: UIView!
    
    var placeholder: String?
    weak var delegate: UserFillFieldTableViewCellDelegate?
//    var didPressStart: (() -> Void)?
//    var didReturnTxtField: ((String?) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        // mStartBtn.layer.cornerRadius = 36
        
        mStartBtn.roundCornersWithBorder(corners: [ .allCorners], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
        
        mBorderV.roundCornersWithBorder(corners: [ .topLeft, .topRight, .bottomRight ], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        mTextFl.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellInfo(item: RegistrationBotModel) {
        
        if item.viewDescription == "button" {
            mStartBtn.isHidden = false
            mBorderV.isHidden = true
            if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
                pressStart()
            }
        } else {
            mBorderV.isHidden = false
            mStartBtn.isHidden = true
            if ((item.userRegisterInfo?.string) != nil) && item.userRegisterInfo?.isFilled == true {
                //mTextFl.text = item.userRegisterInfo?.string
                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
            } else {
                mTextFl.setPlaceholder(string: item.userRegisterInfo?.placeholder ?? "", font: font_bot_placeholder!, color: color_email!)
                placeholder = item.userRegisterInfo?.placeholder
            }
            
        }
    }
    
    private func pressStart() {
        mStartBtn.setTitleColor(color_selected_start, for: .normal)
        mStartBtn.isUserInteractionEnabled = false
        mStartBtn.setBackgroundColorToCAShapeLayer(color: color_navigationBar!)
    }
    
    private func textFiledFilled(txt: String) {
        mTextFl.text = txt
        mTextFl.textColor = .white
        mTextFl.isUserInteractionEnabled = false
        mBorderV.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
        mBorderV.bringSubviewToFront(mTextFl)

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
           // didReturnTxtField?(textField.text)
            delegate?.didReturnTxtField(txt: textField.text)
            textFiledFilled(txt: textField.text!)
            //textField.isUserInteractionEnabled = false
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if placeholder == "Country" {
            delegate?.willOpenPicker(textFl: textField, isCountry: true)
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
    
//    private  func getWidth(text: String) -> CGFloat {
//
//        let txtField = UITextField(frame: .zero)
//        txtField.text = text
//        txtField.sizeToFit()
//        return txtField.frame.size.width
//    }
}
