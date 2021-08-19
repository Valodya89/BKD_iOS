//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class ReservetionStartRideCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReservetionStartRideCollectionViewCell"

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
    
    @IBOutlet weak var mCarRegisterInfoLb: UILabel!
    @IBOutlet weak var mCarRegisterNumberLb: UILabel!
    
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mReservedPayedLb: UILabel!
 @IBOutlet weak var mPriceLb: UILabel!
    
    @IBOutlet weak var mStartRideBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func  setCellInfo() {
        
    }

    @IBAction func startRide(_ sender: UIButton) {
    }
}
