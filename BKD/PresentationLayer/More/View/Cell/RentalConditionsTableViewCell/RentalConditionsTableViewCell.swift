//
//  RentalConditionsTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit

class RentalConditionsTableViewCell: UITableViewCell {
    static let identifier = "RentalConditionsTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
  
    @IBOutlet weak var mImgV: UIImageView!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mValueLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mValueBckgV: UIView!
    @IBOutlet weak var mSeparatorV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // set info to the cell
    func setCellInfo(item: RentalConditionsModel, vehicleModel: VehicleModel?,  index: Int) {
        mImgV.image =  item.img
        mTitleLb.text = item.title
        if index == 1 {
            mValueBckgV.isHidden = true
            mSeparatorV.isHidden = false
        } else {
            mValueLb.text = String(vehicleModel?.depositPrice ?? 0.0)
            

            if index == 4 {
                mImgV.setTintColor(color: color_email!)
            }
        }
        if index != 0 && index != 1 {
            mEuroLb.isHidden = true
            mValueLb.text = item.value

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
