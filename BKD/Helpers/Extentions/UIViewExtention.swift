//
//  UIViewExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-05-21.
//

import UIKit


extension UIView {
    //MARK: GRADIENTS
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
   
    
    //MARK: SHADOWS
    func setShadow(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2.0
        
    }
    
    func setShadowByBezierPath(color: UIColor) {
        let shadowSize: CGFloat = 1.0
            let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                       y: -shadowSize / 2,
                                                       width: self.frame.size.width + shadowSize,
                                                       height: self.frame.size.height + 3))
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowPath = shadowPath.cgPath
    }
    
    //MARK:BORDERS
    public func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    public func setBorderBySide(sides: [BorderSide], color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)

        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)

        for side in sides {
            switch side {
            case .top:
                NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
            case .right:
                NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
            case .bottom:
                NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
            case .left:
                NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
            }
        }
        
    }
    
    //MARK: BLUR
    func setBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    
   //MARK:ROUNSCORNER
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
    }
    
    // Apply round corner and border. An extension method of UIView.

    func roundCornersWithBorder(corners:UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {

        let path = UIBezierPath.init(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius,
                                                         height: radius))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask

        let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
        
    }
    
   
    func makeBorderWithCornerRadius(radius: CGFloat,
                                    borderColor: UIColor,
                                    borderWidth: CGFloat) {
            let rect = self.bounds

            let maskPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: .allCorners,
                                        cornerRadii: CGSize(width: radius, height: radius))

            // Create the shape layer and set its path
            let maskLayer = CAShapeLayer()
            maskLayer.frame = rect
            maskLayer.path  = maskPath.cgPath

            // Set the newly created shape layer as the mask for the view's layer
            self.layer.mask = maskLayer

            // Create path for border
            let borderPath = UIBezierPath(roundedRect: rect,
                                          byRoundingCorners: .allCorners,
                                          cornerRadii: CGSize(width: radius, height: radius))

            // Create the shape layer and set its path
            let borderLayer = CAShapeLayer()

            borderLayer.frame       = rect
            borderLayer.path        = borderPath.cgPath
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.fillColor   = UIColor.clear.cgColor
            borderLayer.lineWidth   = borderWidth * UIScreen.main.scale

            //Add this layer to give border.
            self.layer.addSublayer(borderLayer)
        }


    //MARK: ANIMATIONs
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
    
    func popupAnimation() {
        self.alpha = 1
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.transform = .identity
        })
    }
    
    func popOutAnimation() {
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.alpha = 1.0;
                self.transform = .identity
        }, completion: nil)
    }
   
}
