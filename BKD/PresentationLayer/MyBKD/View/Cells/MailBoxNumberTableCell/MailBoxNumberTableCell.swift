//
//  MailBoxNumberTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

class MailBoxNumberTableCell: UITableViewCell {
    
    static let identifier = "MailBoxNumberTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlet
    @IBOutlet weak var mFildNameLb: UILabel!
    @IBOutlet weak var mTxtFl: TextField!
    @IBOutlet weak var mCheckBoxBtn: UIButton!
    @IBOutlet weak var mEditLineV: UIView!
    @IBOutlet weak var mDeleteBtn: UIButton!
    @IBOutlet weak var mIDondLiveInBuildingLb: UILabel!
    
    private var isChecked: Bool = true
    public var isEdit: Bool = false
    var didChangeMailbox:((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mTxtFl.tintColor = color_navigationBar!
    }

    ///Set cell information
    func setCellInfo(item: MainDriverModel, index: Int) {
        mCheckBoxBtn.isEnabled = isEdit
        mTxtFl.isEnabled = isEdit
        mFildNameLb.text = item.fieldName
        mTxtFl.text = item.fieldValue
        if item.fieldValue == "" || item.fieldValue == nil {
            isChecked = true
            mCheckBoxBtn.setImage(img_check_box, for: .normal)
        }
    }
    
 //MARK: -- Actions
    @IBAction func deleteField(_ sender: UIButton) {
        mTxtFl.text = nil
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        if sender.image(for: .normal) == img_check_box {
            isChecked = false
            sender.setImage(img_uncheck_box, for: .normal)
            didChangeMailbox?(mTxtFl.text ?? "")
        } else {
            isChecked = true
            sender.setImage(img_check_box, for: .normal)
            didChangeMailbox?("")
        }
    }
}


extension MailBoxNumberTableCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.count == 0 {
            mEditLineV.backgroundColor = color_error!
            return true
        }
        textField.resignFirstResponder()
        mDeleteBtn.isHidden = isEdit
        mEditLineV.isHidden = isEdit
        didChangeMailbox?(isChecked ? "" : textField.text ?? "")
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.becomeFirstResponder()
        mDeleteBtn.isHidden = !isEdit
        mEditLineV.isHidden = !isEdit
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
