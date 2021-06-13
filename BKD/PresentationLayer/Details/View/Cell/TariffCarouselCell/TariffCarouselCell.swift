//
//  TariffCarouselCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-06-21.
//

import UIKit

class TariffCarouselCell: UIView {
    //MARK: Outlates
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mMoreBtn: UIButton!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mVatLb: UILabel!
    @IBOutlet weak var mKwImgV: UIImageView!
    @IBOutlet weak var mFuelConsumptionImgV: UIImageView!
    @IBOutlet weak var mFuelConsumptionLb: UILabel!
    @IBOutlet weak var mDepositImgV: UIImageView!
    @IBOutlet weak var mKwLb: UILabel!
    @IBOutlet weak var mDepositLb: UILabel!
    
    @IBOutlet weak var mConfirmBckgV: UIView!
    
    @IBOutlet weak var mConfirmBtn: UIButton!
    
   
    @IBOutlet weak var mHoursSegmentC: UISegmentedControl!
    @IBOutlet weak var mUnselectedBckgV: UIView!
    @IBOutlet weak var mUnselectedTitleLb: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {       Bundle.main.loadNibNamed(Constant.NibNames.tariffCarousel, owner: self, options: nil)
        addSubview(contentView)
contentView.frame = self.bounds
       contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
    func setUpView() {
        self.layer.cornerRadius = 3
        mMoreBtn.layer.cornerRadius = 4
        mMoreBtn.setBorder(color: color_menu!, width: 1)
        mKwImgV.setTintColor(color: color_navigationBar!)
        mUnselectedTitleLb.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))

        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color_menu!], for: .selected)

        
    }

    //MARK: ACTIONS
    //MARK: --------------------
    @IBAction func more(_ sender: UIButton) {
    }
    
    @IBAction func confirm(_ sender: UIButton) {
    }
    
    @IBAction func hours(_ sender: UISegmentedControl) {
        
    }
    
    
}
