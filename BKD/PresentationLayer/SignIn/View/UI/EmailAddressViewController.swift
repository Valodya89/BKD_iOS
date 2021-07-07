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
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
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
        mRightBarBtn.image = img_bkd
        mEmailAddressTextFl.setBorder(color: color_navigationBar!, width: 1)
        mConfirmBtn.layer.cornerRadius = 8
        mConfirmBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mEmailAddressTextFl.setPlaceholder(string: Constant.Texts.emailAdd,
                                           font: font_register_placeholder!,
                                           color: color_email!)
    }
   
    
    ///
    private func sendClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()
        } completion: { [self] _ in
            self.mEmailAddressTextFl.resignFirstResponder()
            self.goToNextController()
        }
    }
    
    /// will push next viewController
    private func goToNextController() {
        let ceheckEmailVC = CheckEmailViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(ceheckEmailVC, animated: true)
    }
    
    ///will show  or hide error of email
    private func showEmailError(isError: Bool) {
        mEmailAddressTextFl.layer.borderColor = isError ? color_error!.cgColor : color_navigationBar!.cgColor
        mErrorLb.isHidden = !isError
    }
    
    private func showOrHideCheckEmailView(isHide: Bool) {
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
        sendClicked()
    }
    
    @IBAction func confirmSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        sendClicked()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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


