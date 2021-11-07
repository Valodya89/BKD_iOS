//
//  MyDriverCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

protocol MyDriverCollectionViewCellDelegate: AnyObject {
    func didPressSelect(isSelected: Bool, cellIndex: Int)
}

class MyDriverCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyDriverCollectionViewCell"
    
    @IBOutlet weak var mFullNameLb: UILabel!
    @IBOutlet weak var mLicenseLb: UILabel!
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mShadowBckgV: UIView!
    
    //Admin approval
    @IBOutlet weak var mAdminApprovalWaitingContentyV: UIView!
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mAdminApprovalWaitingLb: UILabel!
    
    weak var delegate: MyDriverCollectionViewCellDelegate?

    
override func awakeFromNib() {
        super.awakeFromNib()
    setupView()
}

func setupView() {
    mSelectBtn.roundCornersWithBorder(corners: .allCorners, radius: 36, borderColor: color_navigationBar!, borderWidth: 1)
    mShadowBckgV.setShadow(color: color_shadow!)
}

    func setCellInfo(item: MyDriversModel, index: Int) {
        mSelectBtn.tag = index
        mSelectBtn.addTarget(self, action: #selector(selectDriver(sender:)), for: .touchUpInside)
        mFullNameLb.text = item.fullname
        mLicenseLb.text = Constant.Texts.licenseNumber + " " + item.licenciNumber
        if item.isSelected {
            mSelectBtn.backgroundColor = color_navigationBar!
            mSelectBtn.setTitleColor(color_menu!, for: .normal)
        }
        mSelectBtn.isHidden = item.isWaitingForAdmin
        mAdminApprovalWaitingContentyV.isHidden = !item.isWaitingForAdmin
}

@objc func selectDriver(sender:UIButton) {
    if sender.backgroundColor == color_navigationBar! { //deselecte
        sender.backgroundColor = .clear
        sender.setTitleColor(color_navigationBar, for: .normal)
        delegate?.didPressSelect(isSelected: false, cellIndex: sender.tag)
    } else { //selecte
        sender.backgroundColor = color_navigationBar!
        sender.setTitleColor(color_menu, for: .normal)
        delegate?.didPressSelect(isSelected: true, cellIndex: sender.tag)
    }
}

}
