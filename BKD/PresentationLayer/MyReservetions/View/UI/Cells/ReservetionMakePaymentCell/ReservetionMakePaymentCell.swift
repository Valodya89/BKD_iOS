//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class ReservetionMakePaymentCell: UICollectionViewCell {
    
    static let identifier = "ReservetionMakePaymentCell"
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
    
    @IBOutlet weak var mStatusTypeLb: UILabel!
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    @IBOutlet weak var mMakePaymentBtn: UIButton!
    
    
    //MARK: -- VAriable
    var makePayment:(()-> Void)?
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mMakePaymentBtn.layer.cornerRadius = 8
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
        mPriceLb.text = "0.0"
       // mRegistrationNumberLb.text = ""
       // mMakePaymentBtn.setTitleColor(color_email!, for: .normal)
        mMakePaymentBtn.isEnabled = true
        mMakePaymentBtn.setTitle("", for: .normal)
        mCarIconImgV.image = UIImage()
        
    }
    
    
    //
    func getPaymentStatusModel() -> PaymentStatusModel {
        let paymentModel = PaymentStatusModel(status: mStatusTypeLb.text ?? "",  isActivePaymentBtn: true,  price: Double(mPriceLb.text ?? "0.0") ?? 0.00 , paymentButtonType: mMakePaymentBtn.title(for: .normal))
        return paymentModel
    }
    
    
    func  setCellInfo(item: Rent,
                      index: Int,
                      reservatiopnState: MyReservationState) {
        
        mMakePaymentBtn.tag = index
        mMakePaymentBtn.addTarget(self, action: #selector(makePayment(sender:)), for: .touchUpInside)
        setPaymentType(state: reservatiopnState)
        
        //Car info
        mCarIconImgV.sd_setImage(with:  item.carDetails.logo.getURL() ?? URL(string: ""), placeholderImage: nil)
        let currCar: CarsModel? = ApplicationSettings.shared.allCars?.filter( {$0.id == item.carDetails.id}).first
        mCarNameLb.text = currCar?.name
        mCarDescriptionLb.text = (ApplicationSettings.shared.carTypes?.filter( {$0.id == currCar?.type} ).first)?.name
        

        //Pick up location
        if item.pickupLocation.type == Constant.Keys.custom,
           let pickupLocation = item.pickupLocation.customLocation {
            mPickupLocationLb.text = pickupLocation.name
        } else if let pickupParkin = item.pickupLocation.parking {
            mPickupLocationLb.text = pickupParkin.name
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
        
        //Price
        mPriceLb.text =  String(format: "%.2f", MyReservationViewModel().getPriceToPay(rent: item))
        
    }
    
    
    ///Set payment button
    func setPaymentType(state: MyReservationState) {
        
        switch state {
  
        case .maykePayment:
            mStatusTypeLb.text = Constant.Texts.payLater
            mMakePaymentBtn.setTitle(Constant.Texts.makePayment, for: .normal)
        case .payRentalPrice:
            mStatusTypeLb.text = Constant.Texts.depositPaid
            mMakePaymentBtn.setTitle(Constant.Texts.payRental, for: .normal)
        case .payDistancePrice:
            mStatusTypeLb.text = Constant.Texts.reservedPaid
            mMakePaymentBtn.setTitle(Constant.Texts.payDistance, for: .normal)
        case .startRide, .stopRide:
            mStatusTypeLb.text = Constant.Texts.reservedPaid
        case .waithingApproval:
            break
        }
    }

    @objc func makePayment(sender: UIButton) {
        makePayment?()
    }

   
}
