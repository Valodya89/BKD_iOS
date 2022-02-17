//
//  PersonalInfoTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//



import UIKit
import SwiftUI

protocol PersonalInfoTableCellDelegate: AnyObject {
    
    func editFiled(index: Int, value: String)
    func willOpenPicker(textFl: UITextField, isExpiryDate: Bool)
    func willOpenCountryPicker(textFl: TextField)
    func willOpenCityView()
    func willOpenPhoneCodesView()
   // func didPressVerify(phone: String, code: String)
}


class PersonalInfoTableCell: UITableViewCell {
    static let identifier = "PersonalInfoTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
   //MARK: -- Outlets
    @IBOutlet weak var mTxtFl: TextField!
    @IBOutlet weak var mDeleteBtn: UIButton!
    @IBOutlet weak var mFieldNameLb: UILabel!
    @IBOutlet weak var mEditLineV: UIView!
    
   //MARK: -- Variables
    public var isEdit: Bool = false
    public var item: MainDriverModel?
    weak var delegate: PersonalInfoTableCellDelegate?
    lazy var personalInfoViewModel = MyPersonalInformationViewModel()
    
    //MARK: -- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        mFieldNameLb.text = nil
        mTxtFl.text = nil
        mEditLineV.isHidden = true
        mDeleteBtn.isHidden = true
        mTxtFl.tintColor = color_navigationBar!
    }
    
    ///Set cell information
    func setCellInfo(index: Int) {
        guard let item = item else {return}
        
        mDeleteBtn.tag = index
        mDeleteBtn.addTarget(self, action: #selector(deleteFiled(sender:)), for: .touchUpInside)
        
        mTxtFl.tintColor = color_navigationBar!
        mTxtFl.isEnabled = isEdit
        mTxtFl.tag = index
        mFieldNameLb.text = item.fieldName
        let isEmptyField = item.fieldValue!.count > 0
        mEditLineV.isHidden = isEmptyField
        mEditLineV.backgroundColor = (isEmptyField) ? color_driving_license! : color_error!
        
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
        delegate?.editFiled(index: mTxtFl.tag, value: "")
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
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if  mFieldNameLb.text == Constant.Texts.country {
            
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

        let text = textField.text ?? ""
        let textRange = Range(range, in: text)
        let updatingString = text.replacingCharacters(in: textRange!, with: string)
    
        if updatingString.count > 0 {
            mEditLineV.backgroundColor = color_driving_license!
        }
        
        delegate?.editFiled(index: textField.tag, value: updatingString)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.tag)
       // delegate?.reloadFiled()
    }
}
