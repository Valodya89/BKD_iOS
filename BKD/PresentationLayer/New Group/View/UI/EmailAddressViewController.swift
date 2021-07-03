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
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
   
    @IBOutlet weak var mCheckEmailBckgV: UIView!
    @IBOutlet weak var mCheckEmailTitleLb: UILabel!
    @IBOutlet weak var mEmailInfoLb: UILabel!
    @IBOutlet weak var mTryAnotherEmailLb: UILabel!
    
    //MARK: Variables
    lazy var signInViewModel = SignInViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func  setUpView() {
        mEmailAddressTextFl.setBorder(color: color_navigationBar!, width: 1)
        mConfirmBtn.layer.cornerRadius = 8
        mConfirmBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mEmailAddressTextFl.setPlaceholder(string: Constant.Texts.emailAdd,
                                      font: font_register_placeholder!,
                                      color: color_email!)
    }
    
    private func setAtribute() {
        let str = "Did not receive the email? Check your spam filter, or try another email address"
        let attributes = [NSAttributedString.Key.foregroundColor: color_navigationBar!,
                          NSAttributedString.Key.font: font_alert_cancel]
        mTryAnotherEmailLb.attributedText = NSAttributedString(string: str, attributes: attributes as [NSAttributedString.Key : Any])

               let handler = {
                   (hyperLabel: UILabel!, substring: String!) -> Void in

                   //action here
               }
               //Step 3: Add link substrings
//               mTryAnotherEmailLb.setLinksForSubstrings(["try another email address"], withLinkHandler: handler)
    }
    
    private func searchClicked(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()
        }
        mCheckEmailBckgV.isHidden = false
        mConfirmBtn.setTitle(Constant.Texts.oprnEmail, for: .normal)
    }
    
    private func showEmailError(isError: Bool) {
        mEmailAddressTextFl.layer.borderColor = isError ? color_error!.cgColor : color_navigationBar!.cgColor
        mErrorLb.isHidden = !isError
        
        mConfirmBckgV.alpha = isError ? 0.8 : 1.0
        mConfirmBckgV.isUserInteractionEnabled = !isError
        mConfirmLeading.constant = 0.0
        mConfirmBckgV.layoutIfNeeded()
    }
    
    
    //MARK: ACTIONS
    @IBAction func confirm(_ sender: UIButton) {
        searchClicked()
    }
    
    @IBAction func confirmSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        searchClicked()
    }
}


//MARK: UITextFieldDelegate
// -----------------------------
extension EmailAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        OfflineChatViewModel().isValidEmail(email: textField.text!) { [self] (isValid) in
            if isValid {
                showEmailError(isError: false)
            } else {
                showEmailError(isError: true)
            }
        }
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showEmailError(isError: false)
        textField.becomeFirstResponder()
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        guard let text = textField.text else { return false }
//        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
//    
//        return true
//    }
}
