//
//  NationalRegisterNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit


protocol NationalRegisterNumberTableViewCellDelegate: AnyObject {
    func didPressOtherCountryNational()
    func didReturnTxt(txt: String?)
    func willOpenPicker(textFl: UITextField, viewType: ViewType)
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
    @IBOutlet weak var mStackVHeight: NSLayoutConstraint!
    
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
        mCountryBckV.roundCornersWithBorder(corners: [.topLeft, .topLeft, .bottomRight ], radius: 8.0, borderColor: color_dark_register!, borderWidth: 1)
        
    }
    
    override func prepareForReuse() {
        mOtherCountryBtn.backgroundColor = .clear
        mOtherCountryBtn.layer.cornerRadius = 10
        self.isUserInteractionEnabled = true
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel) {
        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
            if ((item.userRegisterInfo?.isOtherNational) != nil) && item.userRegisterInfo?.isOtherNational == true {
                otherCountryPressed()
            } else {
                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
            }
        }
            
    }
    
    func textFiledFilled(txt: String) {
        mTextFl.text = txt
        mTextFl.textColor = .white
        self.isUserInteractionEnabled = false
        mTextFl.setBackgroundColorToCAShapeLayer(color: color_dark_register!)
    }
    
    /// other country nationalidad pressed
    private func otherCountryPressed() {
        mCountryBckV.isHidden = false
        mStackVHeight.constant = 176
        self.layoutIfNeeded()
        self.setNeedsLayout()
        mOtherCountryBtn.setTitleColor(color_selected_start, for: .normal)
        mOtherCountryBtn.isUserInteractionEnabled = false
        mOtherCountryBtn.backgroundColor = color_dark_register!
        mOtherCountryBtn.layer.cornerRadius = 10
//        mStartBtn.setBackgroundColorToCAShapeLayer(color: color_navigationBar!)
    }
    

    
    @IBAction func otherCountry(_ sender: UIButton) {
        otherCountryPressed()
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
           // mDropDownPlaceholderLb.isHidden = false
           // delegate?.willOpenPicker(textFl: textField, viewType: viewType!)
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
