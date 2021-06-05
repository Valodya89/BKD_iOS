//
//  OfflineChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-06-21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class OfflineChatViewController: MessagesViewController {
    
    //MARK: Variables
    private lazy  var offlineVC = OfflineViewController.initFromStoryboard(name: Constant.Storyboards.chat)
    private var emailBottom: CGFloat = 0.0
    private var emailY: CGFloat = 0.0

    
    //MARK: - Life cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        
               NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillHide),
                                                      name: UIResponder.keyboardWillHideNotification,
                                                      object: nil)
   }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            offlineVC.view.frame = CGRect(x: 0,
                                          y: 0,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height)
        emailBottom = offlineVC.mEmailBottom.constant
        emailY = offlineVC.mEmailTextFl.frame.origin.y
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func  setupView()  {
        addChildView()
        configureDelegate()
        configureMessagesViewController()

    }
    private func addChildView(){
        addChild(offlineVC)
        self.view.addSubview(offlineVC.view)
        offlineVC.delegate = self
        
    }
    private func sendOffleinMessage(){
        // will sent by request (email, text)
        showOfflineMessageStatus()
    }
    
    private func configureDelegate(){
        messageInputBar.delegate = self
    }
    
    private func configureMessagesViewController(){
        
        self.messageInputBar.inputTextView.font = font_search_cell
        self.messageInputBar.inputTextView.placeholderTextColor = color_chat_placeholder
        self.messageInputBar.inputTextView.placeholderLabel.font = font_chat_placeholder
        self.messageInputBar.inputTextView.placeholder = "Type your message"
        self.messageInputBar.sendButton.title = ""
        self.messageInputBar.backgroundView.backgroundColor = color_Offline_bckg
        self.messageInputBar.inputTextView.textColor = .white
        self.messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send_active"), for: .normal)
    }
    
    
    private func showOfflineMessageStatus() {
        offlineVC.mSuccessBckgV.isHidden = false
        offlineVC.mSuccessBckgV.popupAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
//            UIView.animate(withDuration: 1, delay: 0, options:  [.curveEaseOut], animations: { [self] in
//                self.offlineVC.mSuccessBckgV.alpha = 0
//            }, completion: {_ in
//                self.offlineVC.mSuccessBckgV.isHidden = true
//                self.offlineVC.mSuccessBckgV.alpha = 1
//            })
            
            UIView.animate(withDuration: 0.5) {
                self.offlineVC.mSuccessBckgV.alpha = 0
            } completion: { _ in
                self.offlineVC.mSuccessBckgV.isHidden = true
                self.offlineVC.mSuccessBckgV.alpha = 1
            }
        }
       
}
    private func dismissKeyboard(){
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.messageInputBar.inputTextView.text = ""
    }
    
    private func isFilledInEmail(email: String?) -> Bool{
        guard let _ = email else {
            return false
        }
        return true
    }
    
    private func showEmailError(){
        UIView.animate(withDuration: 0.5) {
            self.offlineVC.mEmailBottom.constant = self.offlineVC.mEmailErrorLb.frame.height + 3
        }

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageInputBar.frame.origin.y == 0 {
                self.offlineVC.mEmailTextFl.frame.origin.y -= keyboardSize.height
               // offlineVC.mEmailBottom.constant = keyboardSize.height + self.offlineVC.mEmailTextFl.frame.height + 20

            }
            
           // UIView.animate(withDuration: 1, animations: { [self] in
           //            self.offlineVC.mEmailBottom.constant =
           //        })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
       // if self.view.frame.origin.y != 0 {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
          //  self.offlineVC.mEmailTextFl.frame.origin.y += keyboardSize.height
            }
           // offlineVC.mEmailBottom.constant = emailBottom
       // self.offlineVC.view.layoutIfNeeded()
       // }
    }
}


////MARK: MessageInputBarDelegate
extension OfflineChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if isFilledInEmail(email: offlineVC.mEmailTextFl.text) {
            dismissKeyboard()
            sendOffleinMessage()
        } else {
            
        }
            
            
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if  text.count > 0  {
            self.messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "offline_send"), for: .normal)

        } else  if  text.count == 0 {
            self.messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send_active"), for: .normal)
        }

    }

   
}

////MARK: OfflineViewControllerDelegate
extension OfflineChatViewController: OfflineViewControllerDelegate {
    func dismiss()  {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
        
    }
}