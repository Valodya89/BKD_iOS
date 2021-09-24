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
    
    @IBOutlet weak var mPayContantV: UIView!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mPayBtn: UIButton!
    
    //MARK: --Varible
    var didPressPay:((Bool)-> Void)?
    var isPayLater = false
    
    //MARK: Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        mPayBtn.layer.cornerRadius = 8
    }

     override func prepareForReuse() {
         isPayLater = false
         mPaymentTypeContentV.isHidden = false
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
  
    }
    
    @IBAction func pay(_ sender: UIButton) {
        
        didPressPay?(isPayLater)
    }
    
}
