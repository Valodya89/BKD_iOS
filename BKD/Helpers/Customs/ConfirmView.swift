//
//  ConfirmView.swift
//  ConfirmView
//
//  Created by Karine Karapetyan on 26-09-21.
//

import UIKit

class ConfirmView: UIView {

    //MARK: Outlets
    @IBOutlet weak var mGradientImgV: UIImageView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mConfirmBtnLeading: NSLayoutConstraint!
  
    //MARK: --Variables
    var didPressConfirm:(()-> Void)?
    var willCheckConfirm:(()-> Void)?
    var title: String?
    var needsCheck = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mConfirmBtn.layer.cornerRadius = 8
        mGradientImgV.layer.cornerRadius = 8
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1.0)
        guard let title = title else {return}
        mConfirmBtn.setTitle(title, for: .normal)

    }
    
  public  func initConfirm() {
        self.mConfirmBtnLeading.constant = 0
        self.layoutIfNeeded()
    }
    
    /// Animate Confirm click
    public func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmBtnLeading.constant = self.bounds.width - self.mConfirmBtn.frame.size.width
            self.layoutIfNeeded()

        } completion: { _ in
            self.didPressConfirm?()
        }
    }
    
    //MARK: -- Actions
    @IBAction func confirm(_ sender: UIButton) {
        if needsCheck {
            willCheckConfirm?()
        } else {
            clickConfirm()

        }
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if needsCheck {
            willCheckConfirm?()
        } else {
            clickConfirm()
        }
    }
}
