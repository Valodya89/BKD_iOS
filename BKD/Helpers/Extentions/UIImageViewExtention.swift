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

