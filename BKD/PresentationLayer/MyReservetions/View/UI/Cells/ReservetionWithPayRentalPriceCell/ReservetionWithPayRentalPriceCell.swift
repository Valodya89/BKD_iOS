//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class ReservetionWithPayRentalPriceCell: UICollectionViewCell {
    static let identifier = "ReservetionWithPayRentalPriceCell"
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
    @IBOutlet weak var mViaOfficeTerminalLb: UILabel!
    @IBOutlet weak var mStatusTypeLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    @IBOutlet weak var mPayRentalPriceBtn: UIButton!
    
    //MARK: -- Variables
    var payRentalPrice:(()-> Void)?
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mPayRentalPriceBtn.layer.cornerRadius = 8
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
    }

    override func prepareForReuse() {
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
      //  mPayRentalPriceBtn.setTitleColor(color_email!, for: .normal)
        mPayRentalPriceBtn.isEnabled = true
        
    }
    
    //
    func getPaymentStatusModel() -> PaymentStatusModel {
        let paymentModel = PaymentStatusModel(status: mStatusTypeLb.text ?? "", paymentType: mViaOfficeTerminalLb.text, isActivePaymentBtn: true,  price: Double(mPriceLb.text ?? "0.0") ?? 0.00 , paymentButtonType: mPayRentalPriceBtn.title(for: .normal))
        return paymentModel
    }
    
    
    ///Set cell informetion
    func  setInfoCell(item: ReservationWithReservedPaidModel , index: Int) {
        mPayRentalPriceBtn.tag = index
        mPayRentalPriceBtn.addTarget(self, action: #selector(payRentalPrice(sender:)), for: .touchUpInside)
        
    }

    @objc func payRentalPrice(sender: UIButton) {
        payRentalPrice?()
    }
 
}
