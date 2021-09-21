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
    @IBOutlet weak var mPaymentTypeLb: UILabel!
    
    @IBOutlet weak var mPayContantV: UIView!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mPayBtn: UIButton!
    @IBOutlet weak var mPayContentVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mStatusVBottom: NSLayoutConstraint!
    //MARK: Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        mPayBtn.layer.cornerRadius = 8
    }

     override func prepareForReuse() {
         mStatusVBottom.constant = 20
         mPayContantV.isHidden = true
         mPaymentTypeLb.text = ""
    }
    
    
    func setCellInfo(item: PaymentStatusModel) {
        mStatusNameLb.text = item.status
        if let paymentType = item.paymentType {
            mPaymentTypeLb.text = paymentType
        }
        
        mPayContantV.isHidden = !item.isActivePaymentBtn
        if  item.isActivePaymentBtn {
            mStatusVBottom.constant = 66
            if let title = item.paymentButtonType {
                mPayBtn.setTitle(title, for: .normal)
            }
        }
        if let price = item.price {
            mPriceLb.text = String(price)
        }
  
    }
    
}
