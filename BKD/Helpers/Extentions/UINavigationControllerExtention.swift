//
//  UINavigationControllerExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-06-21.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
      func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
          popToViewController(vc, animated: animated)
        }
      }
    
    
    func setNavigationBarBackground(color: UIColor) {
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color_navigationBar
            appearance.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
        } else {
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

