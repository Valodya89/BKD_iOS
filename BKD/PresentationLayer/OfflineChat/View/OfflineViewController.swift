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
    @IBOutlet weak var mMessageTextVHeight: NSLayoutConstraint!
    
    //MARK: Variables
    weak var delegate: OfflineViewControllerDelegate?
    let offlineChatViewModel: OfflineChatViewModel = OfflineChatViewModel()

    private var textViewMinHeight: CGFloat = 36
    private var textViewMaxHeight: CGFloat = 129
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView() {
        configureView()
        configureDelegate()
    }
    
    private func configureView(){
        mSendBtn.isEnabled = false
        mMessageTxtV.tintColor = .white
        mEmailTextFl.tintColor = .black
        mDateLb.text = Date().getDateByFormat()
        mNoticeLb.setMargins()
        mNavigationBarV.setShadowByBezierPath(color: .black)
        mEmailTextFl.setPadding()
//        mSuccessBckgV.makeBorderWithCornerRadius(radius: 10, borderColor: .white, borderWidth: 2.0)
        
    }
    private func configureMessageTextView(isPlaceholder: Bool) {
        
        if !isPlaceholder && mMessageTxtV.text == Constant.Texts.messagePlaceholder  {
            mMessageTxtV.tintColor = .white
            mMessageTxtV.textColor = .white
            mMessageTxtV.font = font_search_cell
            mMessageTxtV.text = ""
        } else if isPlaceholder {
            mMessageTxtV.textColor = color_chat_placeholder
            mMessageTxtV.font = font_chat_placeholder
            mMessageTxtV.text = Constant.Texts.messagePlaceholder
        }
    }
    
    private func configureEmailTextFiled(isBecomeFirstResponder: Bool) {
        if isBecomeFirstResponder && mEmailTextFl.text == key_email {
            mEmailTextFl.text = ""
            mEmailTextFl.tintColor = .black
            mEmailTextFl.textColor = .black
        } else if mEmailTextFl.text?.count == 0 {
            mEmailTextFl.text = key_email
            mEmailTextFl.textColor = .white
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
        dismissKeyboard()
        mSendImgV.image = #imageLiteral(resourceName: "send_active")
        mSendBtn.isEnabled = false
        mSuccessBckgV.isHidden = false
        mSuccessBckgV.popupAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            UIView.animate(withDuration: 0.5) {
                self.mSuccessBckgV.alpha = 0
            } completion: { _ in
                self.mSuccessBckgV.isHidden = true
                self.mSuccessBckgV.alpha = 1
            }
        }
        
    }
    
    private func dismissKeyboard(){
        mEmailTextFl.resignFirstResponder()
        mMessageTxtV.resignFirstResponder()
        configureMessageTextView(isPlaceholder: true)
    }
    
    
    private func isFilledInEmail(email: String?) -> Bool{
        if email?.count == 0 || email == key_email {
            return false
        }
        return true
    }
    
    
    private func showEmailError(errorText: String){
        UIView.animate(withDuration: 0.5) {
            self.mEmailErrorLb.text = errorText
            self.mEmailTextFl.backgroundColor = .clear
            self.mEmailTextFl.setBorder(color: color_error!, width: 1)
            self.mEmailTextFl.textColor = color_chat_placeholder
            self.mEmailBottom.constant = -(self.mEmailErrorLb.frame.height)
        }
    }
    private func hideEmailError() {
        UIView.animate(withDuration: 0.5) {
            self.mEmailTextFl.textColor = .black
            self.mEmailTextFl.backgroundColor = color_email
            self.mEmailTextFl.layer.borderWidth = 0
            self.mEmailBottom.constant = 0
        }
    }
    
    //MARK: Keyboard Notification funcs
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =  (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            var bottomPadding:CGFloat = 0.0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows[0]
                bottomPadding = window.safeAreaInsets.bottom
            }
            self.mInputVBottom.constant = keyboardSize.height - bottomPadding
            UIView.animate(withDuration: duration as! TimeInterval) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        self.mInputVBottom.constant = 0
        UIView.animate(withDuration: duration as! TimeInterval) {
            self.view.layoutIfNeeded()
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
        if !isFilledInEmail(email: mEmailTextFl.text) {
            showEmailError(errorText: Constant.Texts.errorEmail)
        } else  {
            offlineChatViewModel.isValidEmail(email: mEmailTextFl.text!) { [self] (isValid) in
                if isValid { // we should send request
                    self.showOfflineMessageStatus()
                } else {
                    showEmailError(errorText: Constant.Texts.errorIncorrectEmail)
                }
            }
        }
    }
}


//MARK: UITextFieldDelegate
// -----------------------------
extension OfflineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        configureEmailTextFiled(isBecomeFirstResponder: false)
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        configureEmailTextFiled(isBecomeFirstResponder: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)
        if self.mEmailBottom.constant < 0 && fullString.count > 0  {
            hideEmailError()
        }
        
        return true
    }
}

//MARK: UITextViewDelegate
// -----------------------------
extension OfflineViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureEmailTextFiled(isBecomeFirstResponder: false)
        configureMessageTextView(isPlaceholder: false)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            configureMessageTextView(isPlaceholder: true)
        }
        if mEmailTextFl.text?.count == 0 {
            configureEmailTextFiled(isBecomeFirstResponder: false)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // textView height will increase depend of lines
        let textHeight = textView.calculateViewHeightWithCurrentWidth()
        if textView.text != "" {
            if textHeight > textViewMinHeight && textHeight <= textViewMaxHeight {
                mMessageTextVHeight.constant = textHeight/2
            }
        } else {
            mMessageTextVHeight.constant = 0
        }
        self.view.layoutIfNeeded()
         //send button will enabled or disabled dependent of typing
        if textView.text.count > 0 {
            mSendBtn.isEnabled = true
            mSendImgV.image = #imageLiteral(resourceName: "offline_send")
        } else if textView.text == "" {
            mSendBtn.isEnabled = false
            mSendImgV.image = #imageLiteral(resourceName: "send_active")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                
        if text == "\n" { //this will return keyboard
            textView.resignFirstResponder()
            return false
        } else if text == "" { // this will permit remove the text
            return true
        }
        //this will check maximum range of lines
        let textHeight = textView.calculateViewHeightWithCurrentWidth()
        return textHeight < textViewMaxHeight
    }
}

