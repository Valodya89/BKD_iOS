//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class ReservationHistoryCell: UICollectionViewCell {
    static let identifier = "ReservationHistoryCell"
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
    

    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRentalPriceLb: UILabel!
   
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mCompletedLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    
    
    @IBOutlet var mStarImgVCollection: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
        
    }
    
    func  setCellInfo() {
        
    }

 
}
