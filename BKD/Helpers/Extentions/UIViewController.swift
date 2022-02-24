//
//  UIViewController.swift
//  MimoBike
//
//  Created by Vardan on 12.05.21.
//

import UIKit

extension UIViewController {
    
    func showAlertMessage(_ title: String, meassage: String = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertMessage(_ title: String, meassage: String = "", actionText: String, action: @escaping (() -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionText, style: .default, handler: {_ in
                action()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertMessage(_ title: String, meassage: String = "", actionText: [String], action: @escaping ((String) -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
            
            actionText.forEach { (actionTitlte) in
                alert.addAction(UIAlertAction(title: actionTitlte, style: .default, handler: {_ in
                    action(actionTitlte)
                }))
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorAlertMessage(_ message: String = Constant.Texts.somethingWrong) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.Texts.ok, style: .default, handler: nil))
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Set view controller as root
    func setRootViewController(_ vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}

extension UIAlertController {
    static func showAction(title: String, message: String, actions: (String,UIAlertAction.Style, (UIAlertController)->())...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let window = UIApplication.topController() else { return }
        
        actions.forEach { action in
            let action = UIAlertAction(title: action.0, style: action.1, handler: {_ in
                action.2(alertController)
            })
            alertController.addAction(action)
        }
        window.present(alertController, animated: true, completion: nil)
    }
    
//    static func showError(message: String) {
//        UIAlertController.showAction(title: "Error".localized(), message: message, actions: ("OK".localized(), .default, {
//            action in
//            action.dismiss(animated: true, completion: nil)
//        }))
//    }

//    static func showLocationDeniedAlert() {
//        UIAlertController.showAction(title: "Warning".localized(), message: "Mimo needs your location to show bikes near to you.", actions: ("Settings", .default, { controller in
//            controller.dismiss(animated: true, completion: nil)
//            AppDelegate.redirectSettings()
//        }))
//    }
}

extension AppDelegate {
    
    static func redirectSettings() {
    
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
