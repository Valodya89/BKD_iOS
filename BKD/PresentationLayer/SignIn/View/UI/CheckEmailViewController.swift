//
//  CheckEmailViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class CheckEmailViewController: UIViewController, StoryboardInitializable {

    //MARK: Outlets

    @IBOutlet weak var mCheckEmailTitleLb: UILabel!
    @IBOutlet weak var mOpenEmailInfoLb: UILabel!
    @IBOutlet weak var mTryAnotherEmailLb: UILabel!
    @IBOutlet weak var mOpenEmailBckgV: UIView!
    @IBOutlet weak var mOpenEmailBtn: UIButton!
    @IBOutlet weak var mOpenEmailLeading: NSLayoutConstraint!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: Variables
    var emailAddress: String?
    let checkEmailViewModel = CheckEmailViewModel()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func  setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(CheckEmailViewController.handleDeepLink), name: Constant.Notifications.resetPassEmailVerify, object: nil)
        
        mRightBarBtn.image = img_bkd
        mOpenEmailBtn.layer.cornerRadius = 8
        mOpenEmailBtn.addBorder(color:color_navigationBar!, width: 1.0)
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
    
    ///Handle DeepLink
    @objc private func handleDeepLink(notification: Notification) {
      
        self.dismiss(animated: true, completion: nil)
        goToNextController(code: notification.object as? String)
        }
    
    /// will push next viewController
    private func goToNextController(code: String?) {
        
        let newPasswordVC = NewPasswordViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        newPasswordVC.emailAddress = emailAddress
        newPasswordVC.code = code
        self.navigationController?.pushViewController(newPasswordVC, animated: true)
    }
    
    
    private func openEmailClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mOpenEmailLeading.constant = self.mOpenEmailBckgV.bounds.width - self.mOpenEmailBtn.frame.size.width
            self.mOpenEmailBckgV.layoutIfNeeded()
        } completion: { [self] _ in

            self.showActionSheet(texts: emailAppNames)
        }
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
            self.mOpenEmailLeading.constant = 0.0
            self.mOpenEmailBckgV.layoutIfNeeded()
        }))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.present(alertC, animated: true)
        }
    }
    
    
    //MARK: ACTIONS
    @IBAction func openEmail(_ sender: UIButton) {
        openEmailClicked()
    }
    
    @IBAction func openEmailSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        openEmailClicked()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (Constant.Texts.checkEmail as NSString).range(of: Constant.Texts.tryAnotherEmail)
        if gesture.didTapAttributedTextInLabel(label: mTryAnotherEmailLb, inRange: termsRange) {
            self.navigationController?.popViewController(animated: true)
            print("Tapped terms")
        } else {
            print("Tapped none")
        }
    }
}
