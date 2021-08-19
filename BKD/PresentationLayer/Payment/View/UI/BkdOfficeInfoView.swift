//
//  BkdOfficeInfoView.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-08-21.
//

import UIKit

class BkdOfficeInfoView: UIView {

    //MARK: Outlets
    @IBOutlet weak var mLocationBtn: UIButton!
    @IBOutlet weak var mPhoneBtn: UIButton!
    @IBOutlet weak var mWorkDaysLb: UILabel!
    @IBOutlet weak var mWorkHoursLb: UILabel!
    @IBOutlet weak var mLocationImgV: UIImageView!
    @IBOutlet weak var mPhoneImgV: UIImageView!
    @IBOutlet weak var mTimeImgV: UIImageView!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        mTimeImgV.setTintColor(color: color_email!)
    }
    

}
