//
//  UIImageExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

extension UIImageView {
    func setTintColor(color:UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

extension UITextField {
    func setPadding() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


extension UILabel {
    func requiredHeight(labelText:String, width: CGFloat, font: UIFont) -> CGFloat {

        self.frame =  CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.font = font
        self.text = labelText
        self.sizeToFit()
        return self.frame.height
    }
    
    func setMargins(margin: CGFloat = 10) {
            if let textString = self.text {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = margin
                paragraphStyle.headIndent = margin
                paragraphStyle.tailIndent = -margin
                let attributedString = NSMutableAttributedString(string: textString)
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
            }
        }
}
