//
//  ReservetionStartRideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class AdditionalDriverWaithingApplovalCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
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
    @IBOutlet weak var mAdditionalDriverTableHeight: NSLayoutConstraint!
    
    var drivers:[MyDriversModel]? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        
        mShadowContentV.layer.cornerRadius = 16
        mShadowContentV.setShadow(color: color_shadow!)
        mAdditionalDriverTableV.delegate = self
        mAdditionalDriverTableV.dataSource = self
        mAdditionalDriverTableV.register(AdditionalDriverForWaithingApprovalCell.nib(), forCellReuseIdentifier: AdditionalDriverForWaithingApprovalCell.identifier)
       //
        
    }

    override func prepareForReuse() {
      
    
        
    }
    
    /// Set cell information
    func  setCellInfo() {
        mAdditionalDriverTableV.reloadData()
        mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
    }

  
    //MARK: -- UITableViewDelegate, UITableViewDataSource
    //MARK: ----------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalDriverForWaithingApprovalCell.identifier, for: indexPath) as! AdditionalDriverForWaithingApprovalCell
        guard let drivers = drivers else {
            return cell
        }
        cell.setCellInfo(item: drivers[indexPath.row])
        return cell
    }
 
}

