//
//  NewPasswordViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-07-21.
//

import UIKit

class NewPasswordViewController: BaseViewController {
   
    //MARK: Outlets
    @IBOutlet weak var mNewPasswordTitleLb: UILabel!
    @IBOutlet weak var mNewPasswordInfoLb: UILabel!
    @IBOutlet weak var mPasswordTxtFl: TextField!
    @IBOutlet weak var mConfirmPasswordTxtFl: TextField!
    @IBOutlet weak var mVisiblePasswordBtn: UIButton!
    @IBOutlet weak var mVisibleConfirmPasswordBtn: UIButton!
    @IBOutlet weak var mPasswordLb: UILabel!
    @IBOutlet weak var mConfirmPasswordLb: UILabel!
    @IBOutlet weak var mResetPasswordBtn: UIButton!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mErrorLb: UILabel!
    
    lazy var signInViewModel = SignInViewModel()
    var emailAddress: String?
    var code: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBorder()
        mResetPasswordBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    func setUpView() {
        setBorder()
        mRightBarBtn.image = img_bkd
        mResetPasswordBtn.layer.cornerRadius = 8
        mVisiblePasswordBtn.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        mVisibleConfirmPasswordBtn.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        mResetPasswordBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
        mPasswordTxtFl.setPlaceholder(string: Constant.Texts.password,
                                           font: font_register_placeholder!,
                                           color: color_email!)
        mConfirmPasswordTxtFl.setPlaceholder(string: Constant.Texts.confirmPassword,
                                           font: font_register_placeholder!,
                                           color: color_email!)
    }

    private func setBorder() {
        mPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mConfirmPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
    }
    
    ///Change user account password
    private func changePassword() {
        signInViewModel.changePassword(username: emailAddress ?? "", password: mPasswordTxtFl.text!, code: code ?? "") { [self] (status) in
            switch status {
            case .success:
                self.goToSignInPage()
                break                
            default:
                self.showAlertMessage(Constant.Texts.errChangePassword)
                break
            }
        }
    }
    
    
    // MARK: ACTIONS
    @IBAction func visiblePassword(_ sender: UIButton) {
        if sender.image(for: .normal) == img_invisible {
            sender.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
            mPasswordTxtFl.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
            mPasswordTxtFl.isSecureTextEntry = true
        }
    }

    @IBAction func visibleConfirmPassword(_ sender: UIButton) {
        if sender.image(for: .normal) == img_invisible {
            sender.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
                mConfirmPasswordTxtFl.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
            mConfirmPasswordTxtFl.isSecureTextEntry = true
        }
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        mPasswordTxtFl.resignFirstResponder()
        mConfirmPasswordTxtFl.resignFirstResponder()
        sender.setClickTitleColor(color_menu!)
        signInViewModel.areFieldsFilled(firtStr: mPasswordTxtFl.text,
                                          secondStr: mConfirmPasswordTxtFl.text) { [self] (isActive) in
            if isActive {
                if mPasswordTxtFl.text!.count < 8 {
                    mPasswordLb.textColor = color_error
                    mPasswordTxtFl.addBorder(color: color_error!, width: 2)
                } else if  mPasswordTxtFl.text! != mConfirmPasswordTxtFl.text! {
                    mConfirmPasswordLb.textColor = color_error
                    mConfirmPasswordTxtFl.addBorder(color: color_error!, width: 2)
                } else {
                    changePassword()
                }
            } else {
                mErrorLb.isHidden = isActive
                if mPasswordTxtFl.text?.count == 0 {
                    mPasswordTxtFl.addBorder(color: color_error!, width: 2)
                }
                if mConfirmPasswordTxtFl.text?.count == 0{
                    mConfirmPasswordTxtFl.addBorder(color: color_error!, width: 2)
                }
                    
            }
            
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popToViewController(ofClass: EmailAddressViewController.self)
    }
}



//MARK: UITextFieldDelegate
// -----------------------------
extension NewPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mPasswordTxtFl {
            mConfirmPasswordTxtFl.becomeFirstResponder()
            textField.returnKeyType = .done
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mErrorLb.isHidden = true
        mPasswordLb.textColor = color_navigationBar!
        mConfirmPasswordLb.textColor = color_navigationBar!
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        textField.text = fullString
       setBorder()
        return false
    }
}
