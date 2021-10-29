//
//  OnRideCollectionViewCell.swift
//  OnRideCollectionViewCell
//
//  Created by Karine Karapetyan on 22-09-21.
//

import UIKit

class OnRideCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnRideCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    //MARK: -- Outlets
    ///Car info
    @IBOutlet weak var mIconImg: UIImageView!
    @IBOutlet weak var mCarTypeLb: UILabel!
    @IBOutlet weak var mCarNameLb: UILabel!
    
    ///Timer
    @IBOutlet weak var mDayLb: UILabel!
    @IBOutlet weak var mHourLb: UILabel!
    @IBOutlet weak var mMinuteLb: UILabel!
    
    ///Driver info
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mStatusTypeLb: UILabel!
    @IBOutlet weak var mDriverLb: UILabel!
    @IBOutlet weak var mDriverNameLb: UILabel!
    @IBOutlet weak var mDriverLicenseNumberLb: UILabel!
    @IBOutlet weak var mReturnLocationLb: UILabel!
    @IBOutlet weak var mBkdOfficeLb: UILabel!
    @IBOutlet weak var mLocationBtn: UIButton!
    ///Price
    @IBOutlet weak var mPriceLb: UILabel!
    
   ///
    @IBOutlet weak var mAddDamagesBtn: UIButton!
    @IBOutlet weak var mSwitchDriverBtn: UIButton!
    @IBOutlet weak var mStopRideBtn: UIButton!
    @IBOutlet weak var mShadowContentV: UIView!
    
    //MARK: -- Varables
    var pressedStopRide:(()-> Void)?
    var pressedAddDamages:(()-> Void)?
    var pressedSwitchDriver:(()-> Void)?
    var pressedSeeMap:(()->Void)?
    
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mStopRideBtn.layer.cornerRadius = 16
        mAddDamagesBtn.layer.cornerRadius = 8
        mSwitchDriverBtn.layer.cornerRadius = 8
        mAddDamagesBtn.addBorder(color: color_menu!, width: 1.0)
        mSwitchDriverBtn.addBorder(color: color_menu!, width: 1.0)
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
        mLocationBtn.setTitle("", for: .normal)
       
    }

    override func prepareForReuse() {
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
       
        
    }
    
    //
    func getOnRideModel() -> OnRideModel {
        
        let onRideModel = OnRideModel(status: mStatusTypeLb.text ?? "",
                                      locationName: mBkdOfficeLb.text,
                                      isActiveSwitchDriverBtn: !mSwitchDriverBtn.isHidden)
        return onRideModel
    }
    
    func setInfoCell(item: ReservationWithReservedPaidModel, index: Int) {
        mStopRideBtn.tag = index
        mStopRideBtn.addTarget(self, action: #selector(pressedStopRide(sender:)), for: .touchUpInside)
        mAddDamagesBtn.tag = index
        mAddDamagesBtn.addTarget(self, action: #selector(addDamages(sender:)), for: .touchUpInside)
        mSwitchDriverBtn.tag = index
        mSwitchDriverBtn.addTarget(self, action: #selector(switchDriver(sender:)), for: .touchUpInside)
        
        mLocationBtn.tag = index
        mLocationBtn.addTarget(self, action: #selector(seeMap(sender:)), for: .touchUpInside)
    }
    
    @objc func pressedStopRide(sender: UIButton) {
        pressedStopRide?()
    }
    
    @objc func addDamages(sender: UIButton) {
        pressedAddDamages?()
    }
    
    @objc func switchDriver(sender: UIButton) {
        pressedSwitchDriver?()
    }
    
    @objc func seeMap(sender: UIButton) {
        pressedSeeMap?()
    }
}
