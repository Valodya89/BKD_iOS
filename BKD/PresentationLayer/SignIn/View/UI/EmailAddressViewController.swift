//
//  EmailAddressViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-07-21.
//

import UIKit

class EmailAddressViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlets
    @IBOutlet weak var mEmailAddressTextFl: TextField!
    @IBOutlet weak var mEmailInfoLb: UILabel!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mCheckEmailBckgV: UIView!
    @IBOutlet weak var mCheckEmailTitleLb: UILabel!
    @IBOutlet weak var mTryAnotherEmailLb: UILabel!
    
    //MARK: Variables
    lazy var signInViewModel = SignInViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mConfirmLeading.constant = 0.0
    }
    

    
    func  setUpView() {
        mEmailAddressTextFl.setBorder(color: color_navigationBar!, width: 1)
        mConfirmBtn.layer.cornerRadius = 8
        mConfirmBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mEmailAddressTextFl.setPlaceholder(string: Constant.Texts.emailAdd,
                                           font: font_register_placeholder!,
                                           color: color_email!)
        setAttribute()
    }
   
    /// set Atributte to lable
    private func setAttribute() {
        let text = Constant.Texts.checkEmail
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: Constant.Texts.tryAnotherEmail)
        
        attriString.addAttribute(NSAttributedString.Key.font, value: font_alert_agree! as UIFont, range: range1)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: color_navigationBar!, range: range1)
        mTryAnotherEmailLb.attributedText = attriString
        mTryAnotherEmailLb.isUserInteractionEnabled = true
        mTryAnotherEmailLb.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    ///
    private func confirmClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()
        } completion: { [self] _ in
            if self.mCheckEmailBckgV.isHidden {
                self.showOrHideCheckEmailView(isHide: false)
                self.mEmailAddressTextFl.resignFirstResponder()
            } else {
                self.goToNextController()
            }
        }
        
        
    }
    
    /// will push next viewController
    private func goToNextController() {
        let newPasswordVC = UIStoryboard(name: Constant.Storyboards.signIn, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.newPassword) as! NewPasswordViewController
        self.navigationController?.pushViewController(newPasswordVC, animated: true)
    }
    ///will show  or hide error of email
    private func showEmailError(isError: Bool) {
        mEmailAddressTextFl.layer.borderColor = isError ? color_error!.cgColor : color_navigationBar!.cgColor
        mErrorLb.isHidden = !isError
    }
    
    private func showOrHideCheckEmailView(isHide: Bool) {
        self.mCheckEmailBckgV.isHidden = isHide
        self.mConfirmBtn.setTitle(isHide ? Constant.Texts.signIn : Constant.Texts.oprnEmail, for: .normal)
        self.mConfirmLeading.constant = 0.0
        self.mConfirmBckgV.layoutIfNeeded()
    }
    
    ///change status of confirm button
    private func changeConfirmStatus(isActive: Bool) {
        mConfirmBckgV.alpha = isActive ? 1.0 : 0.8
        mConfirmBckgV.isUserInteractionEnabled = isActive
        mConfirmLeading.constant = 0.0
        mConfirmBckgV.layoutIfNeeded()
    }
    
    /// check is valid email address
    private func checkEmailAddress(text: String, isShowError: Bool) {
        OfflineChatViewModel().isValidEmail(email: text) { [self] (isValid) in
            changeConfirmStatus(isActive: isValid)
            if isShowError {
                showEmailError(isError: !isValid)
            }
        }
    }
    
    //MARK: ACTIONS
    @IBAction func confirm(_ sender: UIButton) {
        confirmClicked()
    }
    
    @IBAction func confirmSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        confirmClicked()
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (Constant.Texts.checkEmail as NSString).range(of: Constant.Texts.tryAnotherEmail)
        if gesture.didTapAttributedTextInLabel(label: mTryAnotherEmailLb, inRange: termsRange) {
            showOrHideCheckEmailView(isHide: true)
            print("Tapped terms")
        } else {
            print("Tapped none")
        }
    }
}


//MARK: UITextFieldDelegate
// -----------------------------
extension EmailAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 > 0 {
            checkEmailAddress(text: textField.text!, isShowError: true)
        }
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showEmailError(isError: false)
        textField.becomeFirstResponder()
    }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
            guard let text = textField.text else { return false }
            let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
            checkEmailAddress(text: fullString, isShowError: false)

            return true
        }
}


