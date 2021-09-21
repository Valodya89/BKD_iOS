//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class ReservetionWithDistancePriceCell: UICollectionViewCell {
    static let identifier = "ReservetionWithDistancePriceCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
//MARK: -- Outlets
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarIconImgV: UIImageView!
    @IBOutlet weak var mCarDescriptionLb: UILabel!
    
    @IBOutlet weak var mPickupCarImgV: UIImageView!
    @IBOutlet weak var mReturnCarImgV: UIImageView!
    @IBOutlet weak var mPickupLocationLb: UILabel!
    @IBOutlet weak var mPickupDay: UILabel!
    @IBOutlet weak var mPickupTimeLb: UILabel!
    @IBOutlet weak var mPickupMonthLb: UILabel!
    @IBOutlet weak var mReturnLocationLb: UILabel!
    @IBOutlet weak var mReturnDayLb: UILabel!
    @IBOutlet weak var mReturnMonthLb: UILabel!
    @IBOutlet weak var mReturnTimelb: UILabel!
    
    @IBOutlet weak var mCarRegisterInfoLb: UILabel!
    @IBOutlet weak var mCarRegisterNumberLb: UILabel!
    

    @IBOutlet weak var mReservedPayedLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRentalPriceLb: UILabel!
    @IBOutlet weak var mPaidLb: UILabel!
    @IBOutlet weak var mPaidPriceLb: UILabel!
    @IBOutlet var mStartCollectionImagV: [UIImageView]!
    
    @IBOutlet weak var mPayDistancePriceBtn: UIButton!
    
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mCompletedLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mPayDistancePriceBtn.layer.cornerRadius = 8
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
        mPayDistancePriceBtn.setTitleColor(color_email!, for: .normal)
        mPayDistancePriceBtn.isEnabled = false
        
    }
    
    func  setCellInfo() {
        
    }

 
}
