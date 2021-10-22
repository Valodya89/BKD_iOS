//
//  RegistrationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 03-07-21.
//

import UIKit

class RegistrationViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlets
    @IBOutlet weak var mEmailAddressTxtFl: TextField!
    
    @IBOutlet weak var mPasswordTxtFl: TextField!
    @IBOutlet weak var mConfirmPasswordTxtFl: TextField!
    @IBOutlet weak var mPasswordVisibleBtn: UIButton!
    @IBOutlet weak var mConfirmPasswordVisibleBtn: UIButton!
    @IBOutlet weak var mAgreeCheckBoxBtn: UIButton!
    @IBOutlet weak var mAgreeLb: UILabel!
    @IBOutlet weak var mContinueBckgV: UIView!
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mContinueBtn: UIButton!
    
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    let registrationViewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mContinueLeading.constant = 0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBorderToTextFileds() 
    }
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_navigationBar!)
        tabBarController?.tabBar.isHidden = true
        
        mRightBarBtn.image = img_bkd
        setBorderToTextFileds()
        mPasswordVisibleBtn.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        mConfirmPasswordVisibleBtn.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        mContinueBtn.layer.cornerRadius = 8
        mContinueBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mEmailAddressTxtFl.setPlaceholder(string: Constant.Texts.emailAdd,
                                      font: font_register_placeholder!,
                                      color: color_email!)
        mPasswordTxtFl.setPlaceholder(string: Constant.Texts.password,
                                      font: font_register_placeholder!,
                                      color: color_email!)
        mConfirmPasswordTxtFl.setPlaceholder(string: Constant.Texts.confirmPassword,
                                      font: font_register_placeholder!,
                                      color: color_email!)
        setAttribute()
    }
    
    func setBorderToTextFileds() {
        mPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mConfirmPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mEmailAddressTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mErrorLb.isHidden = true
    }
    
    /// set Atributte to lable
    private func setAttribute() {
        let text = Constant.Texts.agreeTerms
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: Constant.Texts.termsConditions)
        attriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        mAgreeLb.attributedText = attriString
        mAgreeLb.isUserInteractionEnabled = true
        mAgreeLb.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapAgreeLabel(gesture:))))
    }
    
    
    /// will check if active or not continue button
    private func checkStatusOfContinue() {
        registrationViewModel.areFieldsFilled(email: mEmailAddressTxtFl.text,
                                              password: mPasswordTxtFl.text,
                                              confirmpassword: mConfirmPasswordTxtFl.text) { (isActive) in
            if isActive && self.mAgreeCheckBoxBtn.image(for: .normal) == img_check_box {
                self.mContinueBckgV.isUserInteractionEnabled = true
                self.mContinueBckgV.alpha = 1.0
            } else {
                self.mContinueBckgV.isUserInteractionEnabled = false
                self.mContinueBckgV.alpha = 0.8
            }
        }
    }
    
    /// Check are valid password fields
    private func areValidPasswordFields() -> Bool {
         if mPasswordTxtFl.text!.count < 8 {
            self.showError(errorTxt: Constant.Texts.passwordErr, textFld: mPasswordTxtFl)
            return false
        } else if mPasswordTxtFl.text != mConfirmPasswordTxtFl.text {
            self.showError(errorTxt: Constant.Texts.confirmPasswordErr, textFld: mConfirmPasswordTxtFl)
            return false

        }
        return true
    }
    
    ///click continue  button
    private func clickContinue() {
        ChatViewModel().isValidEmail(email: mEmailAddressTxtFl.text!) { [self] (isValid) in
            if isValid {
                if self.areValidPasswordFields() {
                    self.signUp()
                }
            } else {
                self.showError(errorTxt: Constant.Texts.errorIncorrectEmail, textFld: mEmailAddressTxtFl)
            }
        }
    }
    
    ///will show error lable
    private func showError(errorTxt: String, textFld: UITextField?) {
        if let _ = textFld {
            textFld!.setBorder(color: color_error!, width: 2)
        }
        mErrorLb.isHidden = false
        mErrorLb.text = errorTxt
    }
    
    ///Confirm button move to right  with animation
    private func animateContinue() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueBckgV.bounds.width - self.mContinueBtn.frame.size.width
            self.mContinueBckgV.layoutIfNeeded()
        } completion: { _ in
            self.goToVerification()
        }
    }
    
    ///Sent sign up request
    func signUp()  {
        registrationViewModel.signUp(username: mEmailAddressTxtFl.text!, password: mPasswordTxtFl.text!) { (status) in
            switch status {
            case .accountExist:
                self.showError(errorTxt: Constant.Texts.accountExist,
                               textFld: nil)
            case .success:
                self.saveEmailAndPassOnKeychain()
                self.animateContinue()
            case .error:
                self.showError(errorTxt: Constant.Texts.failedRequest,
                               textFld: nil)
            default: break
            }
        }
    }
        
    ///Open Verification screen
    func goToVerification() {
        
        let verificationCode = VerificationCodeViewController.initFromStoryboard(name: Constant.Storyboards.verificationCode)
        verificationCode.email = mEmailAddressTxtFl.text!
        self.navigationController?.pushViewController(verificationCode, animated: true)
    }
    
   
    /// Save email and password on KeychainManager
    private func saveEmailAndPassOnKeychain() {
        KeychainManager().saveUsername(username: mEmailAddressTxtFl.text ?? "")
        KeychainManager().savePassword(passw: mPasswordTxtFl.text ?? "")
    }
    
    //MARK: - Actions
    // -----------------------------
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
    
    @IBAction func agreeThermsAndConditions(_ sender: UIButton) {
        if sender.image(for: .normal) == img_check_box {
            sender.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        checkStatusOfContinue()
    }
    @IBAction func continueRegistration(_ sender: UIButton) {
        clickContinue()
    }
    
    @IBAction func continueSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        clickContinue()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAgreeLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (Constant.Texts.agreeTerms as NSString).range(of: Constant.Texts.termsConditions)
        if gesture.didTapAttributedTextInLabel(label: mAgreeLb, inRange: termsRange) {
            
                let termsConditionsVC = TermsConditionsViewController.initFromStoryboard(name: Constant.Storyboards.registration)
                self.navigationController?.pushViewController(termsConditionsVC, animated: true)
        }
    }
    
}


//MARK: UITextFieldDelegate
// -----------------------------
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTextFieldTag = textField.tag + 1
        if textField == mEmailAddressTxtFl {
            mPasswordTxtFl.becomeFirstResponder()
        } else if textField == mPasswordTxtFl {
            mConfirmPasswordTxtFl.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    
//           if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? TextField {
//               nextTextField.becomeFirstResponder()
//           } else {
//               textField.resignFirstResponder()
//           }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        textField.text = fullString
        checkStatusOfContinue()
        setBorderToTextFileds()
        return false
    }
}
