//
//  PriceTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-06-21.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    
    static let identifier = "PriceTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK:Outlets
    @IBOutlet weak var mPriceTitleLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mDiscountPrecentLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    ///Set cell info
    func setCellInfo(item: PriceModel) {
        if item.offertPrice != nil {
            mPriceLb.textColor = color_error
            mDiscountPrecentLb.isHidden = false
            mDiscountPrecentLb.text = "-" + String(item.discountPrecent ?? 0.0) + "%"
        }
        mPriceTitleLb.text = item.priceTitle
        mPriceLb.text = String(item.price ?? 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
