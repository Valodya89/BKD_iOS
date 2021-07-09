//
//  MailBoxNumberTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

protocol MailBoxNumberTableViewCellDelegate: AnyObject {
    func didReturn(text: String?, noMailBox:Bool)
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
        mCheehckBoxBtn.setImage(#imageLiteral(resourceName: "uncheck_mailbox"), for: .normal)
        mMAilBoxNumberTxtFl.setBorder(color: color_alert_txt!, width:1)
        mMAilBoxNumberTxtFl.delegate = self
        
    }
    
    override func prepareForReuse() {
            
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCellInfo(item: RegistrationBotModel)  {
        if item.userRegisterInfo?.isFilled == true {
            if let txt = item.userRegisterInfo?.string  {
                textFiledFilled(txt: txt)
            } else {
                mCheehckBoxBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            }
        } else {
            mMAilBoxNumberTxtFl.setPlaceholder(string: item.userRegisterInfo?.placeholder ?? "", font: font_bot_placeholder!, color: color_email!)
        }

    }
    
    @IBAction func mailCheckBox(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "uncheck_mailbox") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            mMAilBoxNumberTxtFl.isUserInteractionEnabled = false
            sender.isUserInteractionEnabled = false
            delegate?.didReturn(text: nil, noMailBox: true)
        } else {
            sender.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
        }
    }
    
    
    private func textFiledFilled(txt: String) {
        mMAilBoxNumberTxtFl.text = txt
        mMAilBoxNumberTxtFl.textColor = .white
        mMAilBoxNumberTxtFl.isUserInteractionEnabled = false
        mMAilBoxNumberTxtFl.backgroundColor = color_dark_register!
//        mMAilBoxNumberTxtFl.setBackgroundColorToCAShapeLayer(color: color_dark_register!)

    }
}



//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension MailBoxNumberTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.count ?? 0 > 0 {
            delegate?.didReturn(text:textField.text, noMailBox: false)
            textFiledFilled(txt: textField.text!)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
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
