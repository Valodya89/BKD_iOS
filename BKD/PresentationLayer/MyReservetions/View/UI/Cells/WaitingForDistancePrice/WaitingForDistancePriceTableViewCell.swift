//
//  WaitingForDistancePriceTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-02-22.
//

import UIKit

class WaitingForDistancePriceTableViewCell: UICollectionViewCell {
    static let identifier = "WaitingForDistancePriceTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    
  //MASK: -- Outlets
    @IBOutlet weak var mShadowContentV: UIView!
    @IBOutlet weak var mLogoImgV: UIImageView!
    //Car
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarTypeLb: UILabel!
    //Date
    @IBOutlet weak var mPickUpLocationLb: UILabel!
    @IBOutlet weak var mPickUpDayLb: UILabel!
    @IBOutlet weak var mPickUpMonthLb: UILabel!
    @IBOutlet weak var mPickUpTimeLb: UILabel!
    
    @IBOutlet weak var mReturnLocationLb: UILabel!
    @IBOutlet weak var mReturnDayLb: UILabel!
    @IBOutlet weak var mReturnmonthLb: UILabel!
    @IBOutlet weak var mReturnTimeLb: UILabel!
    //Status
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mStatusNameLb: UILabel!
    @IBOutlet weak var mRentalPriceLb: UILabel!
    @IBOutlet weak var mPaidPriceLb: UILabel!
    
    @IBOutlet weak var mDistancePriceLb: UILabel!
    @IBOutlet weak var mPendingLb: UILabel!
    
    @IBOutlet weak var mWaithingForBkdLb: UILabel!
    
    
    //MARK: -- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
      
    }
    
    
    func getPaymentStatusModel() -> PaymentStatusModel {
        let paymentModel = PaymentStatusModel(status: mStatusNameLb.text ?? "",  isActivePaymentBtn: false,  price: Double(mPaidPriceLb.text ?? "0.0") ?? 0.00 , paymentButtonType: "", waitingStatus: mWaithingForBkdLb.text, waitingForDistanc: true)
        return paymentModel
    }
    
    
    ///Set cel information
    func  setCellInfo(item: Rent, reservatiopnState: MyReservationState) {
        
       // setPaymentType(state: reservatiopnState)

        //Car info
        mLogoImgV.sd_setImage(with:  item.carDetails.logo.getURL() ?? URL(string: ""), placeholderImage: nil)
        let currCar: CarsModel? = ApplicationSettings.shared.allCars?.filter( {$0.id == item.carDetails.id}).first
        mCarNameLb.text = currCar?.name
        mCarTypeLb.text = (ApplicationSettings.shared.carTypes?.filter( {$0.id == currCar?.type} ).first)?.name
        
        //Pickup location
        if item.pickupLocation.type == Constant.Keys.custom,
           let returnLocation = item.returnLocation.customLocation {
            mPickUpLocationLb.text = returnLocation.name
        } else if let pickupLocation = item.pickupLocation.parking {
            mPickUpLocationLb.text = pickupLocation.name
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
        mPickUpDayLb.text = startDate.getDay()
        mPickUpMonthLb.text =  startDate.getMonth(lng: "en")
        mPickUpTimeLb.text = startDate.getHour()
        mReturnDayLb.text = endDate.getDay()
        mReturnmonthLb.text = endDate.getMonth(lng: "en")
        mReturnTimeLb.text = endDate.getHour()
         
        //Price
        mPaidPriceLb.text = String(format: Constant.Texts.paidPrice, item.depositPayment.amount + item.rentPayment.amount)
    }

    
}
