//
//  TextField.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit

class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
   
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
}
