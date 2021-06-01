//
//  UIViewExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-05-21.
//

import UIKit

extension UIView {
    
    func setGradient(startColor: UIColor, endColor: UIColor) {
        //gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  self.bounds
        gradientLayer.colors = [startColor.cgColor as Any, endColor.cgColor as Any]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setGradientWithCornerRadius(cornerRadius: CGFloat, startColor: UIColor, endColor: UIColor) {
        //gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor as Any, endColor.cgColor as Any]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.masksToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setShadow(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2.0
        
    }
    
    func setBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func setShadowByBezierPath(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    public func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func showFlip(){
                if self.isHidden{
                    UIView.transition(with: self, duration: 1, options: [.transitionFlipFromRight,.allowUserInteraction], animations: nil, completion: nil)
                    self.isHidden = false
                }

    }
    func hideFlip(){
            if !self.isHidden{
                UIView.transition(with: self, duration: 1, options: [.transitionFlipFromLeft,.allowUserInteraction], animations: nil,  completion: nil)
                self.isHidden = true
            }
    }
    
    
   
}
