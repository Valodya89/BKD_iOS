//
//  OfflineViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 03-06-21.
//

import UIKit




protocol OfflineViewControllerDelegate: AnyObject {
    func dismiss()
}
class OfflineViewController: UIViewController, StoryboardInitializable  {
    
    //MARK: Outlets
    @IBOutlet weak var mNavigationBarV: UIView!
    @IBOutlet weak var mOfflineV: UILabel!
    @IBOutlet weak var mCloseBtn: UIButton!
    @IBOutlet weak var mNoticeBckgV: UIView!
    @IBOutlet weak var mNoticeLb: UILabel!
    @IBOutlet weak var mEmailErrorLb: UILabel!
    @IBOutlet weak var mEmailTextFl: UITextField!
    @IBOutlet weak var mSuccessBckgV: UIView!
    @IBOutlet weak var mMessaeStatusLb: UILabel!
    @IBOutlet weak var mThankYouLb: UILabel!
    @IBOutlet weak var mInputBackV: UIView!
    @IBOutlet weak var mSendBtn: UIButton!
    @IBOutlet weak var mSendImgV: UIImageView!
    @IBOutlet weak var mMessageTxtV: UITextView!
    @IBOutlet weak var mSendMessageBottomBckgV: UIView!
    
    @IBOutlet weak var mDateLb: UILabel!
    @IBOutlet weak var mEmailBottom: NSLayoutConstraint!
    @IBOutlet weak var mInputVBottom: NSLayoutConstraint!
    //MARK: Variables
    weak var delegate: OfflineViewControllerDelegate?
    private var emailBottom: CGFloat = 0.0
    private var emailY: CGFloat = 0.0
    private var isOpenKeyboard: Bool = false
    
    //MARK: - Life cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailBottom = mEmailBottom.constant
        emailY = mEmailTextFl.frame.origin.y
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
  

    func setupView() {
            configureView()
        configureDelegate()
            // mSuccessBckgV.setBorder(color: .white, width: 2)
        }
        
    private func configureView(){
        mDateLb.text = Date().getDateByFormat()
        mNoticeLb.setMargins()
        mNavigationBarV.setShadowByBezierPath(color: .black)
        mEmailTextFl.setPadding()
        mSuccessBckgV.roundCornersWithBorder(corners: [.topLeft, .bottomRight, .topRight, .bottomLeft],
                                             radius: 10,
                                             borderColor: .white,
                                             borderWidth: 2.0)
    }
    private func configureMessageTextView(isPlaceholder: Bool) {
        if !isPlaceholder {
            mMessageTxtV.textColor = .white
            mMessageTxtV.font = font_search_cell
            mMessageTxtV.text = ""
        } else if isPlaceholder {
            mMessageTxtV.textColor = color_chat_placeholder
            mMessageTxtV.font = font_chat_placeholder
            mMessageTxtV.text = "Type your message"
        }
    }
    
    private func configureDelegate(){
        mEmailTextFl.delegate = self
        mMessageTxtV.delegate = self
        
    }
        
    private func sendOffleinMessage(){
            // will sent by request (email, text)
            showOfflineMessageStatus()
        }
        
       
    private func showOfflineMessageStatus() {
            mSuccessBckgV.isHidden = false
            mSuccessBckgV.popupAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                //            UIView.animate(withDuration: 1, delay: 0, options:  [.curveEaseOut], animations: { [self] in
                //                self.offlineVC.mSuccessBckgV.alpha = 0
                //            }, completion: {_ in
                //                self.offlineVC.mSuccessBckgV.isHidden = true
                //                self.offlineVC.mSuccessBckgV.alpha = 1
                //            })
                
                UIView.animate(withDuration: 0.5) {
                    self.mSuccessBckgV.alpha = 0
                } completion: { _ in
                    self.mSuccessBckgV.isHidden = true
                    self.mSuccessBckgV.alpha = 1
                }
            }
            
        }
        
    private func dismissKeyboard(){
            mMessageTxtV.resignFirstResponder()
            self.mMessageTxtV.text = ""
        }
        
       
    private func isFilledInEmail(email: String?) -> Bool{
        if email?.count == 0 || email == "E-mail" {
                return false
            }
            return true
        }
        
       
    private func showEmailError(){
            UIView.animate(withDuration: 0.5) {
                self.mEmailTextFl.backgroundColor = .clear
                self.mEmailTextFl.setBorder(color: color_error!, width: 1)
                self.mEmailTextFl.textColor = color_chat_placeholder
                self.mEmailBottom.constant = -(self.mEmailErrorLb.frame.height)
            }
            
        }
        
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize =  (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               
               // if mEmailTextFl.text == "E-mail" && mMessageTxtV.text == "Type your message" {
                if !isOpenKeyboard {
                    isOpenKeyboard = true
                    self.mSendMessageBottomBckgV.frame.origin.y -= keyboardSize.height
                }
            }
        }
        
    @objc func keyboardWillHide(notification: NSNotification) {
            // if self.view.frame.origin.y != 0 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                if isOpenKeyboard {
                    isOpenKeyboard = false
                    self.mSendMessageBottomBckgV.frame.origin.y += keyboardSize.height
                }

            }

        }
    
    
    // MARK: ACTIONS
    // MARK: ------------------------
    @IBAction func close(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
        mMessageTxtV.resignFirstResponder()

    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if isFilledInEmail(email: mEmailTextFl.text) {
            showOfflineMessageStatus()
        } else {
            showEmailError()
        }
    }
}


extension OfflineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        return true
    }
}

extension OfflineViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureMessageTextView(isPlaceholder: false)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        configureMessageTextView(isPlaceholder: true)

    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            mSendImgV.image = #imageLiteral(resourceName: "offline_send")
        } else if textView.text == "" {
            mSendImgV.image = #imageLiteral(resourceName: "send_active")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if text == "\n"  // Recognizes enter key in keyboard
              {
                  textView.resignFirstResponder()
                  return false
              }
              return true
          }
    }
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"  // Recognizes enter key in keyboard
//        {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
//}
