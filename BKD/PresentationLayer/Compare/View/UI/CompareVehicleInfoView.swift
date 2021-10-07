//
//  CompareVehicleInfoView.swift
//  CompareVehicleInfoView
//
//  Created by Karine Karapetyan on 06-10-21.
//

import UIKit

class CompareVehicleInfoView: UIView {

    //MARK: -- Outlets
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mTowBarContentV: UIView!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarTypeLb: UILabel!
    @IBOutlet weak var mDetailsTableV: DetailsTableView!
    
    @IBOutlet weak var mStartingLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mMoreInfoBtn: UIButton!
    
    @IBOutlet weak var mShadowContentV: UIView!
   
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mShadowContentV.layer.cornerRadius = 3
        mShadowContentV.setShadow(color: color_shadow!)
        mMoreInfoBtn.layer.cornerRadius = 8
        mMoreInfoBtn.setBorder(color: color_menu!, width: 1.0)
    }
    
    //MARK: -- Actions
    @IBAction func moreInfo(_ sender: UIButton) {
    }
    
}
