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
    
    //MARK: -- Life cicle
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
        mPriceLb.text = "XX,X"
       // mRegistrationNumberLb.text = ""
       // mMakePaymentBtn.setTitleColor(color_email!, for: .normal)
        mMakePaymentBtn.isEnabled = true
        
    }
    
    
    //
    func getPaymentStatusModel() -> PaymentStatusModel {
        let paymentModel = PaymentStatusModel(status: mStatusTypeLb.text ?? "",  isActivePaymentBtn: true,  price: Double(mPriceLb.text ?? "0.0") ?? 0.00 , paymentButtonType: mMakePaymentBtn.title(for: .normal))
        return paymentModel
    }
    
    
    func  setCellInfo(item: ReservationWithReservedPaidModel , index: Int) {
        mMakePaymentBtn.tag = index
        mMakePaymentBtn.addTarget(self, action: #selector(makePayment(sender:)), for: .touchUpInside)
        
    }

    @objc func makePayment(sender: UIButton) {
        makePayment?()
    }

   
}
