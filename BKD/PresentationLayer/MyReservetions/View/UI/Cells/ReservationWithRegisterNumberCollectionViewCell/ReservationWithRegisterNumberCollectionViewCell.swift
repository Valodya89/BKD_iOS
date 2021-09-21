//
//  ReservationWithStartRideCollectionViewCell.swift
//  ReservationWithStartRideCollectionViewCell
//
//  Created by Karine Karapetyan on 13-09-21.
//

import UIKit

class ReservationWithRegisterNumberCollectionViewCell: UICollectionViewCell {

    static let identifier = "ReservationWithRegisterNumberCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    //MARK: Outlets
    
    ///car info
    @IBOutlet weak var mLogoImgV: UIImageView!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarTypeLb: UILabel!
    
    ///reservation dates
    @IBOutlet weak var mPickupCarImgV: UIImageView!
    @IBOutlet weak var mReturnCarImgV: UIImageView!
    @IBOutlet weak var mPickupAddressLb: UILabel!
    @IBOutlet weak var mPickupDayLb: UILabel!
    @IBOutlet weak var mPickupMonthLb: UILabel!
    @IBOutlet weak var mPickupTimeLb: UILabel!
    @IBOutlet weak var mReturnAddressLb: UILabel!
    @IBOutlet weak var mReturnDayLb: UILabel!
    @IBOutlet weak var mReturnMonthLb: UILabel!
    @IBOutlet weak var mReturnTimeLb: UILabel!
    
   ///registration number
    @IBOutlet weak var mRegistrationNumberContentV: UIView!
    @IBOutlet weak var mRegistrationNumberTitleLb: UILabel!
    @IBOutlet weak var mRegistrationNumberLb: UILabel!
    
  ///reserved and payed
    @IBOutlet weak var mReservedPayedContentV: UIView!
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mReservedPayedLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mViaOfficeTerminalLb: UILabel!
    @IBOutlet weak var mReservedPayedTop: NSLayoutConstraint!
    
    /// start ride
    @IBOutlet weak var mStartRideBtn: UIButton!
    @IBOutlet weak var mShadowContentV: UIView!
    
    var didPressStartRide:(() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mStartRideBtn.layer.cornerRadius = 16
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
        mReservedPayedTop.constant = 0
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
        mStartRideBtn.setTitleColor(color_email!, for: .normal)
        mStartRideBtn.isEnabled = false
        
    }
    
    func setInfoCell(item: ReservationWithReservedPaidModel, index: Int) {
        mStartRideBtn.tag = index
        mStartRideBtn.addTarget(self, action: #selector(startRide(sender:)), for: .touchUpInside)
        
        mStartRideBtn.isEnabled = item.isActiveStartRide
        mRegistrationNumberContentV.isHidden = !item.isRegisterNumber

        if !item.isRegisterNumber {
            mReservedPayedTop.constant = -mRegistrationNumberContentV.frame.size.height
        }
        if item.isActiveStartRide {
            mStartRideBtn.setTitleColor(color_navigationBar, for: .normal)
        }
    }
    
    @objc func startRide(sender: UIButton) {
        didPressStartRide?()
    }
    
    
}
