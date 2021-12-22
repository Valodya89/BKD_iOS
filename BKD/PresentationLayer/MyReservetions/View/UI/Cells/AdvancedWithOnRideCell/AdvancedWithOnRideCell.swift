//
//  PaymentStatusUITableViewCell.swift
//  PaymentStatusUITableViewCell
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit


class AdvancedWithOnRideCell: UITableViewCell  {
    
    static let identifier = "AdvancedWithOnRideCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    
    //MARK: Outlets
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mStatusNameLb: UILabel!
    @IBOutlet weak var mLocationContentV: UIView!
    
    @IBOutlet weak var mReturnLocationLb: UILabel!
    
    @IBOutlet weak var mLocationNameLb: UILabel!
    @IBOutlet weak var mLocationBtn: UIButton!
    
    @IBOutlet weak var mAddDamageBtn: UIButton!
    @IBOutlet weak var mSwitchDriverBtn: UIButton!
    
    
    //MARK: --Varible
    var didPressAddDamage:(()-> Void)?
    var didPressSwitchDriver:(()-> Void)?
    var didPressMap:((Int)-> Void)?

    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mAddDamageBtn.layer.cornerRadius = 8
        mSwitchDriverBtn.layer.cornerRadius = 8
        mAddDamageBtn.addBorder(color: color_menu!, width: 1.0)
        mSwitchDriverBtn.addBorder(color: color_menu!, width: 1.0)
        mLocationBtn.setTitle("", for: .normal)

    }

     override func prepareForReuse() {
        
    }
    
    
    /// Set cell information
    func setCellInfo(item: OnRideModel) {
        
        mStatusNameLb.text = item.status
        mSwitchDriverBtn.isHidden = !item.isActiveSwitchDriverBtn
        guard let location =  item.locationName else {
            return
        }
        mLocationNameLb.text = location
    }
    
  //MARK: -- Actions
    
    @IBAction func switchDriver(_ sender: UIButton) {
        didPressSwitchDriver?()
    }
    
    @IBAction func addDamage(_ sender: UIButton) {
        didPressAddDamage?()
    }
    @IBAction func map(_ sender: UIButton) {
        didPressMap?(sender.tag)
    }
}
