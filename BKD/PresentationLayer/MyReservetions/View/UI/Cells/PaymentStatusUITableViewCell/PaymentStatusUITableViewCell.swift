//
//  PaymentStatusUITableViewCell.swift
//  PaymentStatusUITableViewCell
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit


class PaymentStatusUITableViewCell: UITableViewCell  {
    
    static let identifier = "PaymentStatusUITableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    
    //MARK: Outlets
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mStatusNameLb: UILabel!
    @IBOutlet weak var mPaymentTypeContentV: UIView!
    @IBOutlet weak var mPaymentTypeLb: UILabel!
    
    @IBOutlet weak var mWaitingForAdminLb: UILabel!
    @IBOutlet weak var mWaitingStatusContentV: UIView!
    @IBOutlet weak var mPayContantV: UIView!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mPayBtn: UIButton!
    
    //Waiting for distance price calculation
    @IBOutlet weak var mWaitingBkdCalculationContentV: UIView!
    @IBOutlet weak var mStatusFinishedLb: UILabel!
    @IBOutlet weak var mPaidLb: UILabel!
    
    @IBOutlet weak var mPendingLb: UILabel!
    @IBOutlet weak var mDistancePriceStatusLb: UILabel!
    @IBOutlet weak var mWaitingLb: UILabel!
    
    
    
    
    //MARK: --Varible
    var didPressPay:((Bool)-> Void)?
    var isPayLater = false
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mPayBtn.layer.cornerRadius = 8
    }

     override func prepareForReuse() {
         isPayLater = false
         mPaymentTypeContentV.isHidden = false
         mPayContantV.isHidden = true
         mPaymentTypeLb.text = ""
         mWaitingStatusContentV.isHidden = true

    }
    
    
    func setCellInfo(item: PaymentStatusModel) {
        if !item.waitingForDistanc {
            mWaitingBkdCalculationContentV.isHidden = true
            mStatusNameLb.text = item.status
            if let paymentType = item.paymentType {
                mPaymentTypeLb.text = paymentType
            }
            
            mPayContantV.isHidden = !item.isActivePaymentBtn
            if  item.isActivePaymentBtn {
                if let title = item.paymentButtonType {
                    mPayBtn.setTitle(title, for: .normal)
                }
            }
            if let price = item.price {
                mPriceLb.text = String(price)
            }
            
            if item.status == Constant.Texts.payLater {
                mPaymentTypeContentV.isHidden = true
                isPayLater = true
            }
            if item.waitingStatus != nil {
                mWaitingStatusContentV.isHidden = false
                mWaitingForAdminLb.text = item.waitingStatus
            } else {
                mWaitingStatusContentV.isHidden = true
            }
            
        } else {
            
            mWaitingBkdCalculationContentV.isHidden = false
            mPaidLb.text = String(format: Constant.Texts.paidPrice, item.paid ?? 0.0)
        }
        
        
  
    }
    
    @IBAction func pay(_ sender: UIButton) {
        
        didPressPay?(isPayLater)
    }
    
}
