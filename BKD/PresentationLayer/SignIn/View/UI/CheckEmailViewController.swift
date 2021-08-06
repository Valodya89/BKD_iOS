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

    
    let checkEmailViewModel = CheckEmailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    

    func  setUpView() {
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
    
    /// will push next viewController
    private func goToNextController() {
        let newPasswordVC = NewPasswordViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(newPasswordVC, animated: true)
    }
    
    
    private func openEmailClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mOpenEmailLeading.constant = self.mOpenEmailBckgV.bounds.width - self.mOpenEmailBtn.frame.size.width
            self.mOpenEmailBckgV.layoutIfNeeded()
        } completion: { [self] _ in
            self.goToNextController()
//            checkEmailViewModel.getEmailApps { (emailAppNames) in
//                if emailAppNames?.count ?? 0 > 0 {
//                    self.showActionSheet(texts: emailAppNames!)
//                }
//            }
            
        }
    }
    
    func showActionSheet(texts: [String]) {
        let alertC = UIAlertController(title: "Select", message: "Select Mail App", preferredStyle: .actionSheet)

        texts.forEach { (text) in
            let alertAction = UIAlertAction(title: text, style: .default) { (action ) in
                switch action.title {
               // "googlegmail", "yahooMail"
                case "Googleg Mail" :
                    UIApplication.shared.canOpenURL(NSURL(string: "googlegmail://app")! as URL)
                case "Yahoo Mail":
                    UIApplication.shared.canOpenURL(NSURL(string: "yahooMail://app")! as URL)
                default :
                    UIApplication.shared.open(NSURL(string: "message://app")! as URL)
                }
            }
            
            alertC.addAction(alertAction)
        }
        
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
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
