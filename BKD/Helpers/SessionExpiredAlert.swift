//
//  SessionExpiredAlert.swift
//  MimoBike
//
//  Created by Sedrak Igityan on 6/13/21.
//

import UIKit

final class SessionExpiredAlert {
        
    static func showAlert() {
    
        UIApplication.topController()?.showAlertMessage("Session Expired", meassage: "Your current session expired, please login again.", actionText: [Constant.Texts.signIn], action: { _ in
           // AccountViewModel().logout()
//            let splashVC = SplashViewController.initFromStoryboard(name: Constant.Storyboards.splash)
//            UIApplication.topController()?.setRootViewController(splashVC)
            
            let signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
            //UIApplication.topController()?.setRootViewController(signInVC)
            let navigationController = UINavigationController(rootViewController: signInVC)

            
           
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
    }
}
