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
    
   
}


