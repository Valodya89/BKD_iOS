//
//  MyDriverTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-12-21.
//

import UIKit

class MyDriverTableViewCell: UITableViewCell {
    static let identifier = "MyDriverTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var mShadowV: UIView!
    @IBOutlet weak var mVerificationLb: UILabel!
    @IBOutlet weak var mLicenseLb: UILabel!
    @IBOutlet weak var mFullNameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mShadowV.setShadow(color: color_shadow!)
    }

    func setCellInfo(item: MainDriver) {
        
        mFullNameLb.text = (item.name ?? "") + " " + (item.surname ?? "")
        mLicenseLb.text = item.drivingLicenseNumber
        if item.state == Constant.Texts.state_accepted {
            mFullNameLb.textColor = color_navigationBar!
            mLicenseLb.textColor = color_email!
            mVerificationLb.isHidden = true
        } else {
            mFullNameLb.textColor = color_driving_license!
            mLicenseLb.textColor = color_driving_license!
            mVerificationLb.isHidden = false

        }
    }
    
    
}
