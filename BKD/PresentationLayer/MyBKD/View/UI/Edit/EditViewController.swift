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
    
    public var email = ""
    
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
                checkPassword()
            } else {
                mNewEmailTxtFl.layer.borderColor = color_error!.cgColor
            }
        }
    }
    
    ///Check password field
    private func checkPassword() {
       let pass = MyBKDViewModel().password
        if pass != mChangePassTxtFl.text {
            mChangePassTxtFl.layer.borderColor = color_error!.cgColor
        } else {
            sendNewEmailCode(email: mNewEmailTxtFl.text!)
        }
    }
    
    ///Send new email code
    func sendNewEmailCode(email: String) {
        MyBKDViewModel().updateEmail(email: email) { [self] response in
            guard let _ = response else {return}
            goToVerification()
        }
        
    }
   
    ///Open Verification screen
    func goToVerification() {
        
        let verificationCode = VerificationCodeViewController.initFromStoryboard(name: Constant.Storyboards.verificationCode)
        verificationCode.email = email
        self.navigationController?.pushViewController(verificationCode, animated: true)
    }
    
//    func showEmailVerificationMessage() {
//        mButtonsStackV.isHidden = true
//        mTextFiledStackV.isHidden = true
//        mCheckEmailLb.isHidden = false
//    }
    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        checkEmailAddress()
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
       
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mNewEmailTxtFl {
            mNewEmailTxtFl.layer.borderColor = color_navigationBar!.cgColor
        } else {
            mChangePassTxtFl.layer.borderColor = color_navigationBar!.cgColor
        }
        
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
