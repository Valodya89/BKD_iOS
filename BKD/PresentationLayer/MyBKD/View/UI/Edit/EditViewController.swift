//
//  EditViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

class EditViewController: BaseViewController {

   //MARK: -- Outlets
    @IBOutlet weak var mNewEmailTxtFl: TextField!
    @IBOutlet weak var mChangePassTxtFl: TextField!
    @IBOutlet weak var mTextFiledStackV: UIStackView!
    @IBOutlet weak var mButtonsStackV: UIStackView!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mCheckEmailLb: UILabel!
        @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationControll(navControll: navigationController, barBtn: mRightBarBtn)
        configureUI()
    }
    
    ///Configutre UI
    func configureUI() {
        mCancelBtn.setBorder(color: color_menu!, width: 2)
        mCancelBtn.layer.cornerRadius = 8
        mConfirmBtn.layer.cornerRadius = 8
        mNewEmailTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mChangePassTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mNewEmailTxtFl.setPlaceholder(string: Constant.Texts.newEmail, font: font_chat_placeholder!, color: color_navigationBar!)
        mChangePassTxtFl.setPlaceholder(string: Constant.Texts.currPassword, font: font_chat_placeholder!, color: color_navigationBar!)

    }
    
    ///If valid email addres will call signIn function else will shoa error message
    private func checkEmailAddress() {
        ChatViewModel().isValidEmail(email: mNewEmailTxtFl.text!) { [self] (isValid) in
            if isValid {
                //signIn()
            } else {
                mNewEmailTxtFl.layer.borderColor = color_error!.cgColor
            }
        }
    }
    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        mButtonsStackV.isHidden = true
        mTextFiledStackV.isHidden = true
        mCheckEmailLb.isHidden = false
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}



//MARK: -- UITextFieldDelegate
extension EditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mNewEmailTxtFl {
            mChangePassTxtFl.becomeFirstResponder()
            textField.returnKeyType = .done
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mNewEmailTxtFl.layer.borderColor = color_navigationBar!.cgColor
        mChangePassTxtFl.layer.borderColor = color_navigationBar!.cgColor
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        var nextTxt:String?
        if textField == mNewEmailTxtFl {
            nextTxt = mChangePassTxtFl.text
        } else {
            nextTxt = mNewEmailTxtFl.text
        }
        textField.text = fullString
        return false
    }
}
