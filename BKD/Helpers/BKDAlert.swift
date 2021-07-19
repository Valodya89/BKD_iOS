//
//  BKDAlert.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit


class BKDAlert: NSObject {
    
    struct  Constants {
        static let backgroundAlpaTo: CGFloat = 0.6
    }
    private var didHandleOkAction: (() -> Void)?
    private var didHandleCancelAction: (() -> Void)?

    var messageAlignment: NSTextAlignment = .center
    let backgroundView = UIView()
    let alertView = UIView()

    
    func showAlert(on viewController: UIViewController,
                   title: String?,
                   message: String?,
                   messageSecond: String?,
                   cancelTitle: String?,
                   okTitle: String?,
                   cancelAction: (() -> Void)?,
                   okAction: (() -> Void)?) {
        
        guard let targetView = viewController.view else {
            return
        }
        didHandleOkAction = okAction
        didHandleCancelAction = cancelAction
        
        backgroundView.frame = targetView.bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = Constants.backgroundAlpaTo
        targetView.addSubview(backgroundView)
        
        //Aert
        alertView.backgroundColor = color_alert_bckg
         alertView.layer.masksToBounds = true
         alertView.layer.cornerRadius = 20
        alertView.frame = CGRect(x: 0,
                                 y: targetView.frame.origin.y * 0.5,
                                 width: targetView.frame.size.width * 0.652174,
                                 height: 200)
        
        
        let titleWidth: CGFloat = alertView.frame.size.width - 40
        let titleX: CGFloat = 20
        let titleTop: CGFloat = 11
        let titleSpacep: CGFloat = 10
        let buttonHeight: CGFloat = 44
        var titleLableHeight: CGFloat = 0
        var messageLabelHeight: CGFloat = 0
        var messageLabelHeight2: CGFloat = 0
        var alertSpaces: CGFloat = titleSpacep*2
        
        let messageLabel = UILabel()
        let titleLable = UILabel()
        let messageLabel2 = UILabel()

        //Message
        messageLabelHeight = messageLabel.requiredHeight(labelText: message!,
                                                             width: titleWidth,
                                                             font: font_unselected_filter!)
        messageLabel.frame = CGRect(x: titleX, y: titleTop, width: titleWidth , height: messageLabelHeight)
        messageLabel.textColor = color_alert_txt
        messageLabel.text = message
        messageLabel.textAlignment = messageAlignment
        messageLabel.numberOfLines = 20
        alertView.addSubview(messageLabel)
        
        //title
        if let title = title {
            alertSpaces = titleSpacep*3
            titleLableHeight = titleLable.requiredHeight(labelText: title, width:titleWidth,  font: font_alert_title!)
            titleLable.frame = CGRect(x: titleX,
                                      y: titleTop + messageLabelHeight + titleSpacep,
                                      width: titleWidth,
                                      height: titleLableHeight)
            titleLable.numberOfLines = 0
            titleLable.text = title
            titleLable.textAlignment = .center
            titleLable.textColor = color_alert_txt
            alertView.addSubview(titleLable)
        }
        
        // second message
        if let messageSecond = messageSecond {
            alertSpaces = titleSpacep*4
            messageLabelHeight2 = messageLabel2.requiredHeight(labelText: messageSecond,
                                                                 width: titleWidth,
                                                                 font: font_unselected_filter!)
            messageLabel2.frame = CGRect(x: titleX,
                                         y: titleTop + messageLabelHeight +  titleLableHeight + 2*titleSpacep,
                                         width: titleWidth,
                                         height: messageLabelHeight2)
            messageLabel2.textColor = color_alert_txt
            messageLabel2.text = messageSecond
            messageLabel2.textAlignment = messageAlignment
            messageLabel2.numberOfLines = 20
            alertView.addSubview(messageLabel2)
        }
        
        var buttonY:CGFloat = messageLabel.frame.origin.y + messageLabel.frame.size.height + titleTop
        let buttonCancel:UIButton? =  UIButton(type: .system)
        // buttons
        if let cancelTitle = cancelTitle {
            if let _ = messageSecond {
                buttonY = messageLabel2.frame.origin.y + messageLabel2.frame.size.height + titleTop
            } else  if let _ = title {
                buttonY = titleLable.frame.origin.y + titleLable.frame.size.height + titleTop
            }
            buttonCancel!.frame =  CGRect(x: alertView.frame.origin.x,
                                          y: buttonY,
                                          width: alertView.frame.size.width/2,
                                          height: buttonHeight)

            buttonCancel!.setTitle(cancelTitle, for: .normal)
            buttonCancel!.setTitleColor(color_btn_alert, for: .normal)
            buttonCancel!.titleLabel?.font = font_alert_cancel
            buttonCancel!.addBorderBySide(sides: [.top], color: color_btn_border!, width: 1)
           buttonCancel!.addBorderBySide(sides: [.right], color: color_btn_border!, width: 1)
            if #available(iOS 14.0, *) {
                buttonCancel!.addAction(UIAction(title: "", handler: { [self] _ in
                    alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    cancelAlert()
                }), for: .touchUpInside)
            } else {
                buttonCancel!.addTarget(self,
                                        action: #selector(cancelAlert),
                                       for: .touchUpInside)
            }
            

        }
        let buttonOk:UIButton? =  UIButton(type: .system)
        if let okTitle = okTitle {
            var okWidth: CGFloat = alertView.frame.size.width
            var okX: CGFloat = alertView.frame.origin.x

            if let _ = cancelTitle {
                okWidth /= 2
                okX = okWidth
            }
            buttonOk!.frame = CGRect(x: okX,
                                     y: buttonY,
                                     width: okWidth,
                                     height: buttonHeight)
            buttonOk!.setTitle(okTitle, for: .normal)
            buttonOk!.setTitleColor(color_btn_alert, for: .normal)
            buttonOk!.titleLabel?.font = font_alert_agree
            buttonOk!.addBorderBySide(sides: [.top], color: color_btn_border!, width: 1)
                        
            if #available(iOS 14.0, *) {
                buttonOk!.addAction(UIAction(title: "", handler: { [self] _ in
                    okAlert()
                    alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()

                }), for: .touchUpInside)
            } else {
                buttonOk!.addTarget(self,
                                    action: #selector(okAlert),
                                    for: .touchUpInside)
            }

        }
        
        alertView.frame = CGRect(x: targetView.frame.size.width/2 - alertView.frame.size.width/2,
                                 y: targetView.frame.size.height * 0.2,
                                 width: alertView.frame.size.width,
                                 height: messageLabelHeight + messageLabelHeight2 + titleLableHeight + buttonHeight + alertSpaces)
       
        targetView.addSubview(alertView)
        alertView.addSubview(buttonOk!)
        alertView.addSubview(buttonCancel!)
       // alertView.center = targetView.center
        alertView.popupAnimation()

    }

    
    func showAlertOk(on viewController: UIViewController,
                   message: String?,
                   okTitle: String?,
                   okAction: (() -> Void)?) {
        
        guard let targetView = viewController.view else {
            return
        }
        didHandleOkAction = okAction
        
        backgroundView.frame = targetView.bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = Constants.backgroundAlpaTo
        targetView.addSubview(backgroundView)
        
        //Aert
        alertView.backgroundColor = color_alert_bckg
         alertView.layer.masksToBounds = true
         alertView.layer.cornerRadius = 20
        alertView.frame = CGRect(x: 0,
                                 y: targetView.frame.origin.y * 0.5,
                                 width: targetView.frame.size.width * 0.652174,
                                 height: 200)
        
        
        let titleWidth: CGFloat = alertView.frame.size.width - 40
        let titleX: CGFloat = 20
        let titleTop: CGFloat = 11
        let titleSpacep: CGFloat = 10
        let buttonHeight: CGFloat = 44
        let alertSpaces: CGFloat = titleSpacep*2
        let titleLableHeight: CGFloat = 0
        var messageLabelHeight: CGFloat = 0
        let messageLabel = UILabel()

        //Message
        messageLabelHeight = messageLabel.requiredHeight(labelText: message!,
                                                             width: titleWidth,
                                                             font: font_unselected_filter!)
        messageLabel.frame = CGRect(x: titleX, y: titleTop, width: titleWidth , height: messageLabelHeight)
        messageLabel.textColor = color_alert_txt
        messageLabel.text = message
        messageLabel.textAlignment = messageAlignment
        messageLabel.numberOfLines = 20
        alertView.addSubview(messageLabel)
        
        
        let buttonY:CGFloat = messageLabel.frame.origin.y + messageLabel.frame.size.height + titleTop
        let buttonOk:UIButton? =  UIButton(type: .system)
        let okWidth: CGFloat = alertView.frame.size.width
        let okX: CGFloat = alertView.frame.origin.x
        buttonOk!.frame = CGRect(x: okX,
                                 y: buttonY,
                                 width: okWidth,
                                 height: buttonHeight)
        buttonOk!.setTitle(okTitle, for: .normal)
        buttonOk!.setTitleColor(color_btn_alert, for: .normal)
        buttonOk!.titleLabel?.font = font_alert_agree
        buttonOk!.addBorderBySide(sides: [.top], color: color_btn_border!, width: 1)
        
        if #available(iOS 14.0, *) {
            buttonOk!.addAction(UIAction(title: "", handler: { [self] _ in
                okAlert()
                alertView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                
            }), for: .touchUpInside)
        } else {
            buttonOk!.addTarget(self,
                                action: #selector(okAlert),
                                for: .touchUpInside)
        }
        
            
        alertView.frame = CGRect(x: targetView.frame.size.width/2 - alertView.frame.size.width/2,
                                 y: targetView.frame.size.height * 0.2,
                                 width: alertView.frame.size.width,
                                 height: messageLabelHeight +  titleLableHeight + buttonHeight + alertSpaces)
       
        targetView.addSubview(alertView)
        alertView.addSubview(buttonOk!)
        alertView.popupAnimation()

    }
    
    @objc func cancelAlert() {
        if let didHandleCancelAction = didHandleCancelAction {
            alertView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            didHandleCancelAction()
        }
    }
    
    @objc func okAlert() {
        if let didHandleOkAction = didHandleOkAction {
            didHandleOkAction()
        }
    }
    
}


