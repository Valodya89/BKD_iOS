//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class AdditionalDriverWaithingApplovalCell: UICollectionViewCell {
    static let identifier = "AdditionalDriverWaithingApplovalCell"
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
    @IBOutlet weak var mStatusLb: UILabel!
    @IBOutlet weak var mStatuisDescriptionLb: UILabel!
    @IBOutlet weak var mEditStatusLb: UILabel!
    @IBOutlet weak var mWaithingApprovalLb: UILabel!
    @IBOutlet weak var mShadowContentV: UIView!
    @IBOutlet weak var mAdditionalDriverTableV: UITableView!
    
    var drivers:[MyDriversModel]? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
        mAdditionalDriverTableV.register(AdditionalDriverForWaithingApprovalCell.nib(), forCellReuseIdentifier: AdditionalDriverForWaithingApprovalCell.identifier)
        
    }

    override func prepareForReuse() {
      
    
        
    }
    
    func  setCellInfo() {
        
    }

 
}


extension AdditionalDriverWaithingApplovalCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalDriverForWaithingApprovalCell.identifier, for: indexPath) as! AdditionalDriverForWaithingApprovalCell
                
        return cell
    }
}
