//
//  PaddingUILable.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-05-21.
//

import UIKit

//class EdgeInsetLabel: UILabel {
//    var textInsets = UIEdgeInsets.zero {
//        didSet { invalidateIntrinsicContentSize() }
//    }
//
//    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
//        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
//                                          left: -textInsets.left,
//                                          bottom: -textInsets.bottom,
//                                          right: -textInsets.right)
//        return textRect.inset(by: invertedInsets)
//    }
//
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: textInsets))
//    }
//}


class UILabelPadding: UILabel {

    var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }



}
