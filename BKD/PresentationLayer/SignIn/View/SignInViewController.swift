//
//  SignInViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-07-21.
//

import UIKit


final class SignInViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mEmailAddressTextFl: TextField!
    @IBOutlet weak var mPasswordTxtFl: TextField!
    @IBOutlet weak var mForgoTPasswordBtn: UIButton!
    @IBOutlet weak var mSignInInfoLb: UILabel!
    @IBOutlet weak var mVisibilityPasswortBtn: UIButton!
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mSignInBtn: UIButton!
    @IBOutlet weak var mSignInBckgV: UIView!
    @IBOutlet weak var mSignInLeading: NSLayoutConstraint!
    @IBOutlet weak var mRegisterInfoLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRegisterBtn: UIButton!
    
    //MARK: Variables
    private var keychainManager = KeychainManager()
    lazy var signInViewModel = SignInViewModel()
    
    var didSignIn:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        mPasswordTxtFl.text = ""
        mEmailAddressTextFl.text = ""
        mSignInLeading.constant = 0
        mSignInBckgV.isUserInteractionEnabled = false
        self.mSignInBckgV.alpha =  0.8
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mRegisterBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mEmailAddressTextFl.setBorder(color: color_navigationBar!, width: 1)
        mSignInBtn.addBorder(color:color_navigationBar!, width: 1.0)
//        mRegisterBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    private func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        mVisibilityPasswortBtn.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        
        mPasswordTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mEmailAddressTextFl.setBorder(color: color_navigationBar!, width: 1)
        mSignInBtn.layer.cornerRadius = 8
        mSignInBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mEmailAddressTextFl.setPlaceholder(string: Constant.Texts.emailAdd,
                                      font: font_register_placeholder!,
                                      color: color_email!)
        mPasswordTxtFl.setPlaceholder(string: Constant.Texts.password,
                                      font: font_register_placeholder!,
                                      color: color_email!)
    }
   
    ///Sign in
    private func signIn()  {
        signInViewModel.signIn(username: mEmailAddressTextFl.text!, password: mPasswordTxtFl.text!) { [weak self] (status) in
            guard let self = self else { return }
            switch status {
            case .success:
                self.keychainManager.saveUsername(username: self.mEmailAddressTextFl.text!)
                self.keychainManager.savePassword(passw: self.mPasswordTxtFl.text!)
                
                self.signInClicked()
            default:
                self.incorrectPasswordOrUsername()
                break
            }
        }
    }

    
    ///Incorrect username or password
    private func incorrectPasswordOrUsername() {
        mErrorLb.isHidden = false
        mPasswordTxtFl.layer.borderColor = color_error!.cgColor
        mEmailAddressTextFl.layer.borderColor = color_error!.cgColor
        mErrorLb.text = Constant.Texts.errUserOrPass
    }
    
    
    ///If valid email addres will call signIn function else will shoa error message
    private func checkEmailAddress() {
        ChatViewModel().isValidEmail(email: mEmailAddressTextFl.text!) { [self] (isValid) in
            if isValid {
                signIn()
            } else {
                mErrorLb.isHidden = false
                mEmailAddressTextFl.layer.borderColor = color_error!.cgColor
                mErrorLb.text = Constant.Texts.errorIncorrectEmail
            }
        }
    }
    
    ///Animate view when clicked signIn
    private func signInClicked(){
        dissmisKeyboar()
        UIView.animate(withDuration: 0.5) { [self] in
            self.mSignInLeading.constant = self.mSignInBckgV.bounds.width - self.mSignInBtn.frame.size.width
            self.mSignInBckgV.layoutIfNeeded()
        } completion: { _ in
            UserDefaults.standard.setValue(true, forKey: key_isLogin)
            self.didSignIn?()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func dissmisKeyboar() {
        mPasswordTxtFl.resignFirstResponder()
        mEmailAddressTextFl.resignFirstResponder()
    }
    
    
    //MARK: ACTIONS
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func visibility(_ sender: UIButton) {
        if sender.image(for: .normal) == img_invisible {
            sender.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
            mPasswordTxtFl.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "invisible"), for: .normal)
            mPasswordTxtFl.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        dissmisKeyboar()
        let emailAddressVC = EmailAddressViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(emailAddressVC, animated: true)
        
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        checkEmailAddress()
        //searchClicked()
        //incorrectPassword()
    }
    
    @IBAction func signInSwipGesture(_ sender: UISwipeGestureRecognizer) {
        //searchClicked()
        checkEmailAddress()

    }
    
    @IBAction func register(_ sender: UIButton) {
        dissmisKeyboar()
//        // TODO: - remove
//        let selectPaymentVC = SelectPaymentViewController.initFromStoryboard(name: Constant.Storyboards.payment)
//        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
//        return
        
        let registerVC = RegistrationViewController.initFromStoryboard(name: Constant.Storyboards.registration)
        self.navigationController?.pushViewController(registerVC, animated: true)
        
//        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
//        registrationBotVC.tableData = [RegistrationBotData.registrationBotModel[0]]
//        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
}


//MARK: UITextFieldDelegate
// -----------------------------
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mEmailAddressTextFl {
            mPasswordTxtFl.becomeFirstResponder()
            textField.returnKeyType = .done
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mErrorLb.isHidden = true
        mPasswordTxtFl.layer.borderColor = color_navigationBar!.cgColor
        mEmailAddressTextFl.layer.borderColor = color_navigationBar!.cgColor
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        var nextTxt:String?
        if textField == mEmailAddressTextFl {
            nextTxt = mPasswordTxtFl.text
        } else {
            nextTxt = mEmailAddressTextFl.text
        }
        textField.text = fullString
        signInViewModel.areFieldsFilled(firtStr: fullString,
                                        secondStr: nextTxt) { (isActive) in
            self.mSignInBckgV.alpha = isActive ? 1 : 0.8
            self.mSignInBckgV.isUserInteractionEnabled = isActive
        }
        return false
    }
}
