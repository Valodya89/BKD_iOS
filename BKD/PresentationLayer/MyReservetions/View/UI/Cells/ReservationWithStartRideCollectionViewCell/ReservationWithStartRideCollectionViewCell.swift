//
//  ReservationWithStartRideCollectionViewCell.swift
//  ReservationWithStartRideCollectionViewCell
//
//  Created by Karine Karapetyan on 13-09-21.
//

import UIKit

class ReservationWithStartRideCollectionViewCell: UICollectionViewCell {

    static let identifier = "ReservationWithStartRideCollectionViewCell"
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
    
  ///reserved and payed
    @IBOutlet weak var mReservedPayedContentV: UIView!
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mReservedPayedLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mViaOfficeTerminalLb: UILabel!
    
    /// start ride
    @IBOutlet weak var mStartRideBtn: UIButton!
    @IBOutlet weak var mShadowContentV: UIView!
    
    //MARK: -- Variables
    var pressInactiveStartRide:(()->Void)?
    
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
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
        mStartRideBtn.setTitleColor(color_email!, for: .normal)
        
    }
    
    func getPaymentStatusModel() -> PaymentStatusModel {
        let paymentModel = PaymentStatusModel(status: mReservedPayedLb.text ?? "", paymentType: mViaOfficeTerminalLb.text, isActivePaymentBtn: false, price: Double(mPriceLb.text ?? "0.0") ?? 0.00)
        return paymentModel
    }
    
    func setInfoCell(item: Rent, index: Int) {
        mStartRideBtn.tag = index
        mStartRideBtn.addTarget(self, action: #selector(pressedStartRide(sender:)), for: .touchUpInside)
        
        //Get difference between now and start ride date
        let duration = Date().getDistanceByComponent(.minute, toDate: Date(timeIntervalSince1970: item.startDate)).minute
        if duration! <= 15 {
            mStartRideBtn.setTitleColor(color_selected_filter_fields!, for: .normal)
        }
        
        //Car info
        mLogoImgV.sd_setImage(with:  item.carDetails.logo.getURL() ?? URL(string: ""), placeholderImage: nil)
        let currCar: CarsModel? = ApplicationSettings.shared.allCars?.filter( {$0.id == item.carDetails.id}).first
        mCarNameLb.text = currCar?.name
        mCarTypeLb.text = (ApplicationSettings.shared.carTypes?.filter( {$0.id == currCar?.type} ).first)?.name
        

        //Pick up location
        if item.pickupLocation.type == Constant.Keys.custom,
           let pickupLocation = item.pickupLocation.customLocation {
            mPickupAddressLb.text = pickupLocation.name
        } else if let pickupParkin = item.pickupLocation.parking {
            mPickupAddressLb.text = pickupParkin.name
        }
        //Return location
        if item.returnLocation.type == Constant.Keys.custom,
           let returnLocation = item.returnLocation.customLocation {
            mReturnAddressLb.text = returnLocation.name
        } else if let returnParkin = item.returnLocation.parking {
            mReturnAddressLb.text = returnParkin.name
        }
        //Date
        let startDate = Date().doubleToDate(doubleDate: item.startDate)
        let endDate = Date().doubleToDate(doubleDate: item.endDate)
        mPickupDayLb.text = startDate.getDay()
        mPickupMonthLb.text =  startDate.getMonth(lng: "en")
        mPickupTimeLb.text = startDate.getHour()
        mReturnDayLb.text = endDate.getDay()
        mReturnMonthLb.text = endDate.getMonth(lng: "en")
        mReturnTimeLb.text = endDate.getHour()

    }
    
    @objc func pressedStartRide(sender: UIButton) {
        pressInactiveStartRide?()
    }
    
}
