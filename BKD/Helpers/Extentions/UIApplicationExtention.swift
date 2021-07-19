//
//  UIApplicationExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-07-21.
//

import UIKit

extension UIApplication {
    static func topController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }

        return nil
    }
}