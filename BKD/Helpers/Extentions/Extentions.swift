//
//  UIImageExtention.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit


//MARK: UIImageView extension
extension UIImageView {
    func setTintColor(color:UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func rotateImage ( rotationAngle: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}

//MARK: UIImage
extension UIImage {
    
    func colored(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
      }
}

//MARK: UITextField extension
extension UITextField {
    func setPadding() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    public func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
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

//MARK: UITextView extension
extension UITextView {
    // Note: This will trigger a text rendering!
    func calculateViewHeightWithCurrentWidth() -> CGFloat {
        let textWidth = self.frame.width -
            self.textContainerInset.left -
            self.textContainerInset.right -
            self.textContainer.lineFragmentPadding * 2.0 -
            self.contentInset.left -
            self.contentInset.right
        
        let maxSize = CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        var calculatedSize = self.attributedText.boundingRect(with: maxSize,
                                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                      context: nil).size
        calculatedSize.height += self.textContainerInset.top
        calculatedSize.height += self.textContainerInset.bottom
        
        return ceil(calculatedSize.height)
    }
}

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
    
    func formattToNumber() -> NSNumber {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.number(from: self.text!) ?? 0
        
    }
}


//MARK: UIColor extension
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
