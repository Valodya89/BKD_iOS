//
//  UILabelExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-11-21.
//

import UIKit


//MARK: UILabel extension
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
    
    func setPadding(_ padding: CGFloat = 10) {
            if let textString = self.text {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = padding
                paragraphStyle.headIndent = padding
                paragraphStyle.tailIndent = -padding
                let attributedString = NSMutableAttributedString(string: textString)
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
            }
        }
    
    func formattToNumber() -> NSNumber {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.number(from: self.text!) ?? 0
        
    }
    
    
    func setAttributeBold(text: String, boldText: String, color: UIColor ) {
       // let text = Constant.Texts.agreeTerms
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: boldText)
        
        attriString.addAttribute(NSAttributedString.Key.font, value: font_alert_agree! as UIFont, range: range1)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        self.attributedText = attriString
    }
}

