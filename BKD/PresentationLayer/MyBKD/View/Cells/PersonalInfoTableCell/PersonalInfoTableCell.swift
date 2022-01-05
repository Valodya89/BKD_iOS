//
//  PersonalInfoTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//



import UIKit
import SwiftUI

protocol PersonalInfoTableCellDelegate: AnyObject {
    
    func willOpenPicker(textFl: UITextField, isExpiryDate: Bool)
    func willOpenCountryPicker(textFl: TextField)
    func willOpenCityView()
    func didPressVerify()
}


class PersonalInfoTableCell: UITableViewCell {
    static let identifier = "PersonalInfoTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var mVerifyBtn: UIButton!
    @IBOutlet weak var mVerifiedV: UIView!
    @IBOutlet weak var mTxtFl: TextField!
    @IBOutlet weak var mDeleteBtn: UIButton!
    @IBOutlet weak var mFieldNameLb: UILabel!
    @IBOutlet weak var mEditLineV: UIView!
    
    public var isEdit: Bool = false
    public var item: MainDriverModel?
    weak var delegate: PersonalInfoTableCellDelegate?
    lazy var personalInfoViewModel = MyPersonalInformationViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mVerifyBtn.layer.cornerRadius = 8
        mVerifyBtn.setBorder(color: color_menu!, width: 1)
        
    }

    override func prepareForReuse() {
        mFieldNameLb.text = nil
        mTxtFl.text = nil
        mVerifiedV.isHidden = true
        mEditLineV.isHidden = true
        mDeleteBtn.isHidden = true
        mTxtFl.tintColor = color_navigationBar!
    }
    
    ///Set cell information
    func setCellInfo(index: Int) {
        guard let item = item else {return}
        mTxtFl.tintColor = color_navigationBar!
        mTxtFl.isEnabled = isEdit
        mTxtFl.tag = index
        mDeleteBtn.tag = index
        mDeleteBtn.addTarget(self, action: #selector(deleteFiled(sender:)), for: .touchUpInside)
        
        mFieldNameLb.text = item.fieldName

        if item.fieldName == Constant.Texts.phoneNumber {
            //If verified
            mVerifiedV.isHidden = false
        }
        
        //set date filed
        if item.isDate {
            mTxtFl.text = personalInfoViewModel.getDate(dateValue: item.fieldValue ?? "")
        } else {
            //set country filed
            if item.fieldName == Constant.Texts.country {
                mTxtFl.text =  personalInfoViewModel.getCountryName(id: item.fieldValue ?? "")
            } else {
                mTxtFl.text = item.fieldValue
            }
        }
    }
    
    ///Handler delete
    @objc func deleteFiled(sender: UIButton) {
        mTxtFl.text = nil
    }
    
    ///Open picker date
    func openPickerView(textFl: TextField) {
        if item?.fieldName == Constant.Texts.dateOfBirth ||
            item?.fieldName == Constant.Texts.issueDrivingLic {
            textFl.tintColor = .clear
            delegate?.willOpenPicker(textFl: textFl, isExpiryDate: false)
        } else if item?.fieldName == Constant.Texts.expiryDateIdCard ||
                    item?.fieldName == Constant.Texts.expiryDrivingLic {
            textFl.tintColor = .clear
            delegate?.willOpenPicker(textFl: textFl, isExpiryDate: true)

        }
    }
}


extension PersonalInfoTableCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.count == 0 {
            mEditLineV.backgroundColor = color_error!
            return true
        }
        textField.resignFirstResponder()
        mDeleteBtn.isHidden = isEdit
        mEditLineV.isHidden = isEdit
        if mFieldNameLb.text == Constant.Texts.phoneNumber { //phone number
            if item?.fieldValue != textField.text {
                mVerifyBtn.isHidden = false
            } else {
                mVerifiedV.isHidden = !isEdit
            }
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if mFieldNameLb.text == Constant.Texts.phoneNumber {
            
            delegate?.didPressVerify()
            mVerifiedV.isHidden = isEdit
        } else if  mFieldNameLb.text == Constant.Texts.country {
            
            delegate?.willOpenCountryPicker(textFl: textField as! TextField)
        } else if mFieldNameLb.text == Constant.Texts.city {
            
            textField.resignFirstResponder()
            delegate?.willOpenCityView()
        } else {
            
            mDeleteBtn.isHidden = !isEdit
            mEditLineV.isHidden = !isEdit
            textField.becomeFirstResponder()
        }
        openPickerView(textFl: textField as! TextField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text,
//              let textRange = Range(range, in: text) else {
//            return true
//        }
        let text = textField.text ?? ""
        let textRange = Range(range, in: text)
        let updatingString = text.replacingCharacters(in: textRange!, with: string)
        if updatingString.count > 0 {
            mEditLineV.backgroundColor = color_driving_license!
        }
        return true
    } 
}
