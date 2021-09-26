//
//  UIButton+Border.swift
//  BKD
//
//  Created by Karine Karapetyan on 07-05-21.
//

import UIKit

public enum BorderSide {
    case top, bottom, left, right
}

extension UIButton {
    
    public func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    public func addBorderBySide(sides: [BorderSide], color: UIColor, width: CGFloat) {
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
    
    func setButtonClickImage (image: UIImage) {
        let oldImg = self.image(for: .normal)
        self.setImage(image, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
            self.setImage(oldImg, for: .normal)
         }
    }
    
    func setClickTitleColor (_ color : UIColor) {
        let oldColor = self.titleColor(for: .normal)
        self.setTitleColor(color, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
            self.setTitleColor(oldColor, for: .normal)
         }
    }
    
    func setClickColor (_ color : UIColor, titleColor: UIColor) {
        let oldBckgColor = self.backgroundColor
        let oldTitleColor = self.titleColor(for: .normal)

        self.backgroundColor = color
        self.setTitleColor(titleColor, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.setTitleColor(oldTitleColor, for: .normal)
            self.backgroundColor = oldBckgColor
         }
    }
    
    func enable(){
        self.isEnabled = true
        self.alpha = 1
    }
    
    func disable() {
        self.isEnabled = false
        self.alpha = 0.8
    }
   
}


