//
//  PhonbeNumberTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-01-22.
//

import UIKit
import PhoneNumberKit
import SwiftMaskTextfield


protocol PhonbeNumberTableCellDelegate: AnyObject {
    func editPhoneNumber(index: Int,
                         code: String,
                         phone: String)
    func willOpenPhoneCodesView()
    func didPressVerify(phone: String, code: String)
}
class PhonbeNumberTableCell: UITableViewCell {
    static let identifier = "PhonbeNumberTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    
    @IBOutlet weak var mVerifyBtn: UIButton!
    @IBOutlet weak var mVerifiedV: UIView!
    @IBOutlet weak var mTxtFl: SwiftMaskTextfield!
    @IBOutlet weak var mDeleteBtn: UIButton!
    @IBOutlet weak var mFieldNameLb: UILabel!
    @IBOutlet weak var mEditLineV: UIView!
    @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mCodeBtn: UIButton!
    
    public var isEdit: Bool = false
    public var isEditedPhone: Bool = false
    public var item: MainDriverModel?
    weak var delegate: PhonbeNumberTableCellDelegate?
    lazy var personalInfoViewModel = MyPersonalInformationViewModel()
    
    public var selectedCountry: PhoneCode?
    let phoneNumberKit = PhoneNumberKit()
    var validFormPattern: Int = 0
    var phoneNumber: String? {
        get {
            return "\(selectedCountry?.code ?? "NULL") \(mTxtFl.text ?? "NULL")".replacingOccurrences(of: "_", with: "").replacingOccurrences(of: " ", with: "")
        } set {
            guard let newValue = newValue else {return}
            guard !newValue.isEmpty else {
                mTxtFl.text = ""
                return
            }
            
            if (newValue.isNumber() == false)  {
                mTxtFl.text = String(newValue.dropLast())
                
            }
            

            guard let _ = try? phoneNumberKit.parse(newValue, ignoreType: true) else { return }
            
        }
    }
    
    var isValid: Bool {
        return mTxtFl.text?.count == validFormPattern
    }
    
    //MARK: -- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mVerifyBtn.layer.cornerRadius = 8
        mVerifyBtn.setBorder(color: color_menu!, width: 1)
    }

    override func prepareForReuse() {
        mFieldNameLb.text = nil
        mTxtFl.text = nil
        mVerifiedV.isHidden = true
        mVerifyBtn.isHidden = true
        mEditLineV.isHidden = true
        mDeleteBtn.isHidden = true
        mTxtFl.tintColor = color_navigationBar!
    }
    
    ///Set cell information
    func setCellInfo(index: Int) {
        guard let item = item else {return}
        mDeleteBtn.tag = index
        mVerifyBtn.tag = index
        mTxtFl.tag = index
       // mVerifiedV.isHidden = isEditedPhone
        mTxtFl.tintColor = color_navigationBar!
        mTxtFl.isEnabled = isEdit
        mCodeBtn.isUserInteractionEnabled = isEdit
        mDropDownImgV.isHidden = !isEdit
        mFieldNameLb.text = item.fieldName
        
        mCodeBtn.setTitle(item.phoneCode ?? "", for: .normal)
        self.layoutIfNeeded()
        mTxtFl.text = item.fieldValue ?? ""

        if mTxtFl.text?.count == 0 {
            mTxtFl.becomeFirstResponder()
        }
        
    }
    
    
    
  //MARK: -- Actions
    
    @IBAction func code(_ sender: UIButton) {
        delegate?.willOpenPhoneCodesView()
    }
    
    @IBAction func deleteField(_ sender: UIButton) {
        mTxtFl.text = nil
    }
    
    @IBAction func verify(_ sender: UIButton) {
        delegate?.didPressVerify(phone: mTxtFl.text ?? "", code: mCodeBtn.title(for: .normal) ?? "")
    }
    
}


extension PhonbeNumberTableCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.count == validFormPattern {
            textField.resignFirstResponder()
        } else {
            mEditLineV.backgroundColor = color_error!
        }
        
        mDeleteBtn.isHidden = isEdit
        mEditLineV.isHidden = isEdit
        
        return true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        mVerifiedV.isHidden = isEdit
        mDeleteBtn.isHidden = !isEdit
        mEditLineV.isHidden = !isEdit
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let fullText = textField.text! + string
        phoneNumber = fullText
        let isComplete = fullText.count <= validFormPattern
        if isComplete {
        delegate?.editPhoneNumber(index: mTxtFl.tag,
                                  code: selectedCountry?.code ?? "",
                                  phone: fullText)
        }
        return isComplete
    }
    
}
