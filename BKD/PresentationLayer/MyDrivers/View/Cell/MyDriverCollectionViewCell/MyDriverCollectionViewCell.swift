//
//  MyDriverCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

protocol MyDriverCollectionViewCellDelegate: AnyObject {
    func didPressSelect()
}

class MyDriverCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyDriverCollectionViewCell"
    
    @IBOutlet weak var mFullNameLb: UILabel!
    @IBOutlet weak var mLicenseLb: UILabel!
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mShadowBckgV: UIView!
    
    weak var delegate: MyDriverCollectionViewCellDelegate?

    
override func awakeFromNib() {
        super.awakeFromNib()
    setupView()
}

func setupView() {
    mSelectBtn.makeBorderWithCornerRadius(radius: 36,
                                          borderColor: color_navigationBar!,
                                          borderWidth: 1)
    mShadowBckgV.setShadow(color: color_shadow!)
    
    
}

func setCellInfo() {
    mSelectBtn.addTarget(self, action: #selector(selectDriver(sender:)), for: .touchUpInside)
}

@objc func selectDriver(sender:UIButton) {
    if sender.backgroundColor == color_navigationBar! {
        sender.backgroundColor = .clear
        sender.setTitleColor(color_navigationBar, for: .normal)
    } else {
        sender.backgroundColor = color_navigationBar!
        sender.setTitleColor(color_menu, for: .normal)
    }
}

}
