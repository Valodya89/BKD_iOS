//
//  MailBoxNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

protocol MailBoxNumberTableViewCellDelegate: AnyObject {
    func didReturn(text: String?, noMailBox:Bool, index: Int)
}

class MailBoxNumberTableViewCell: UITableViewCell {
    static let identifier = "MailBoxNumberTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mCheckBoxTitleLb: UILabel!
    @IBOutlet weak var mCheehckBoxBtn: UIButton!
    @IBOutlet weak var mMAilBoxNumberTxtFl: TextField!
    
    weak var delegate: MailBoxNumberTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        mCheehckBoxBtn.setImage(img_uncheck_box!, for: .normal)
        mMAilBoxNumberTxtFl.setBorder(color: color_navigationBar!, width:1)
        mMAilBoxNumberTxtFl.delegate = self
    }
    
    override func prepareForReuse() {
            
        }
      
    func setCellInfo(item: RegistrationBotModel, index: Int)  {
        mCheckBoxTitleLb.tag = index
        if item.userRegisterInfo?.isFilled == true {
            if (item.userRegisterInfo?.string ?? "").count > 0  {
                textFiledFilled(txt: (item.userRegisterInfo?.string)!)
            } else {
                mMAilBoxNumberTxtFl.isUserInteractionEnabled = false
                mCheehckBoxBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                mMAilBoxNumberTxtFl.setPlaceholder(string: item.userRegisterInfo?.placeholder ?? "", font: font_bot_placeholder!, color: color_email!)
            }
        } else {
            mMAilBoxNumberTxtFl.setPlaceholder(string: item.userRegisterInfo?.placeholder ?? "", font: font_bot_placeholder!, color: color_email!)
        }

    }
    
    @IBAction func mailCheckBox(_ sender: UIButton) {
        if sender.image(for: .normal) == img_uncheck_box! {
            sender.setImage(img_check_box, for: .normal)
            mMAilBoxNumberTxtFl.isHidden = true
           // mMAilBoxNumberTxtFl.isUserInteractionEnabled = false
            //sender.isUserInteractionEnabled = false
            delegate?.didReturn(text: nil, noMailBox: true, index: mCheckBoxTitleLb.tag)
        } else {
            sender.setImage(img_uncheck_box!, for: .normal)
            mMAilBoxNumberTxtFl.isHidden = false
            mMAilBoxNumberTxtFl.text = nil
            mMAilBoxNumberTxtFl.backgroundColor = .clear
        }
        
    }
    
    
    private func textFiledFilled(txt: String) {
        mMAilBoxNumberTxtFl.text = txt
        mMAilBoxNumberTxtFl.textColor = .white
       // mMAilBoxNumberTxtFl.isUserInteractionEnabled = false
        mMAilBoxNumberTxtFl.backgroundColor = color_navigationBar!
        mMAilBoxNumberTxtFl.layer.borderColor = color_navigationBar!.cgColor

    }
}



//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension MailBoxNumberTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            delegate?.didReturn(text:textField.text, noMailBox: false, index: mCheckBoxTitleLb.tag)
            textFiledFilled(txt: textField.text!)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
}
