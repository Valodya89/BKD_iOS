//
//  VerificationCodeViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-07-21.
//

import UIKit

class VerificationCodeViewController: UIViewController, StoryboardInitializable {

   //MARK: Outlets
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mInfoLb: UILabel!
    @IBOutlet weak var mAlertContentV: UIView!
    @IBOutlet weak var mAlertV: UIView!
    
    @IBOutlet weak var mThankBtn: UIButton!
    
    @IBOutlet weak var mOpenEmailOrContinueBtn: UIButton!
    @IBOutlet weak var mContinueV: UIView!
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    
    //MARK: Variables
    lazy var verificationCodeViewModel = VerificationCodeViewModel()
    var email:String = ""
 
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        sendEmailVerification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mOpenEmailOrContinueBtn.addBorder(color:color_navigationBar!, width: 1.0)
    }
    
    func setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(VerificationCodeViewController.handleDeepLink), name: Constant.Notifications.signUpEmailVerify, object: nil)
        mRightBarBtn.image = img_bkd
        mAlertV.layer.cornerRadius = 8
        mAlertContentV.backgroundColor = color_background?.withAlphaComponent(0.5)
        mOpenEmailOrContinueBtn.layer.cornerRadius = 8
        mOpenEmailOrContinueBtn.addBorder(color:color_navigationBar!, width: 1.0)
    }

    @objc private func handleDeepLink(notification: Notification) {
        self.dismiss(animated: true, completion: nil)
        sendAccountVerification(code: notification.object as? String ?? "")
    }
    
    ///Send email verification for signup
    func sendEmailVerification() {
        SignInViewModel().forgotPassword(username:  email, action: Constant.Texts.verification) { (status) in
            switch status {
            case .accountNoSuchUser:
                self.showErrorAlertMessage(Constant.Texts.errEmailVerifyNoUser)
                break
            case .success:
                print("sendEmailVerification success")
                break
            default:
                self.showAlertMessage(Constant.Texts.errEmailVerify)
                break
            }
        }
    }
    
    ///Send account verification for active account
    func sendAccountVerification(code: String){

        verificationCodeViewModel.putVerification(username: email, code: code) { [self] (status) in

            switch status {
            case .success:
                showAlert()
            default:
                self.showErrorAlertMessage(Constant.Texts.errAccountVerify)
                break
            }
        }
    }
    
    //Show alert of success email verify
    func showAlert() {
        self.mOpenEmailOrContinueBtn.setTitle(Constant.Texts.continueTxt, for: .normal)
        self.mContinueLeading.constant = 0.0
        self.mContinueV.layoutIfNeeded()
        mAlertContentV.isHidden = false
        self.mAlertV.isHidden = false
        self.mAlertV.popupAnimation()
    }
    
    func showActionSheet(texts: [String]) {
        let alertC = UIAlertController(title: Constant.Texts.select, message: Constant.Texts.selectMailApp, preferredStyle: .actionSheet)

        texts.forEach { (text) in
            let alertAction = UIAlertAction(title: text, style: .default) { (action ) in
                switch action.title {
                case Constant.Texts.googleMail :
                    UIApplication.shared.canOpenURL(NSURL(string: Constant.DeepLinks.googleMailApp)! as URL)
                case Constant.Texts.yahooMail:
                    UIApplication.shared.canOpenURL(NSURL(string: Constant.DeepLinks.yahooMailApp)! as URL)
                default :
                    UIApplication.shared.open(NSURL(string: Constant.DeepLinks.messageApp)! as URL)
                }
            }

            alertC.addAction(alertAction)
        }
        
        alertC.addAction(UIAlertAction(title: Constant.Texts.cancel, style: .cancel, handler: { _ in
            self.mContinueLeading.constant = 0.0
            self.mContinueV.layoutIfNeeded()
        }))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.present(alertC, animated: true)
        }
    }
    
    private func openEmailClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueV.bounds.width - self.mOpenEmailOrContinueBtn.frame.size.width
            self.mContinueV.layoutIfNeeded()
        } completion: { [self] _ in
            if self.mOpenEmailOrContinueBtn.title(for: .normal) == Constant.Texts.continueTxt {
                 self.goToFaceAndTouchId()
            } else {
                self.showActionSheet(texts: emailAppNames)
            }
        }
    }
    
   //Open FaceAndTouchId Screen
    private func goToFaceAndTouchId() {
    
        let FaceAndTouchIdVC = FaceAndTouchIdViewController.initFromStoryboard(name: Constant.Storyboards.registration)
        self.navigationController?.pushViewController(FaceAndTouchIdVC, animated: true)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func thankYou(_ sender: UIButton) {
        mAlertV.isHidden = true
        mAlertContentV.isHidden = true
    }
    
    
    @IBAction func openEmailOrContinue(_ sender: UIButton) {
        openEmailClicked()
    }
    
    @IBAction func swipeContinue(_ sender: UISwipeGestureRecognizer) {
        openEmailClicked()
    }
}


