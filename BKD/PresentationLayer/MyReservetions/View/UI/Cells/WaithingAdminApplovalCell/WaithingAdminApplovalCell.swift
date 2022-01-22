//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class WaithingAdminApplovalCell: UICollectionViewCell {
    static let identifier = "WaithingAdminApplovalCell"
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
    
    @IBOutlet weak var mStatusLb: UILabel!

    @IBOutlet weak var mEditStatusLb: UILabel!
    @IBOutlet weak var mWaithingApprovalLb: UILabel!
    
    @IBOutlet weak var mDepositPaidLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    
    var drivers:[MyDriversModel]? = nil

    
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
    
    func  setCellInfo(item: Rent) {
        
        //Car info
        mCarIconImgV.sd_setImage(with:  item.carDetails.logo.getURL() ?? URL(string: ""), placeholderImage: nil)
        let currCar: CarsModel? = ApplicationSettings.shared.allCars?.filter( {$0.id == item.carDetails.id}).first
        mCarNameLb.text = currCar?.name
        mCarDescriptionLb.text = (ApplicationSettings.shared.carTypes?.filter( {$0.id == currCar?.type} ).first)?.name
        
        //Pickup location
        if item.pickupLocation.type == Constant.Keys.custom,
           let returnLocation = item.returnLocation.customLocation {
            mPickupLocationLb.text = returnLocation.name
        } else if let pickupLocation = item.pickupLocation.parking {
            mPickupLocationLb.text = pickupLocation.name
        }
        //Return location
        if item.returnLocation.type == Constant.Keys.custom,
           let returnLocation = item.returnLocation.customLocation {
            mReturnLocationLb.text = returnLocation.name
        } else if let returnParkin = item.returnLocation.parking {
            mReturnLocationLb.text = returnParkin.name
        }
        //Date
        let startDate = Date().doubleToDate(doubleDate: item.startDate)
        let endDate = Date().doubleToDate(doubleDate: item.endDate)
        mPickupDay.text = startDate.getDay()
        mPickupMonthLb.text =  startDate.getMonth(lng: "en")
        mPickupTimeLb.text = startDate.getHour()
        mReturnDayLb.text = endDate.getDay()
        mReturnMonthLb.text = endDate.getMonth(lng: "en")
        mReturnTimelb.text = endDate.getHour()
    }

 
}
