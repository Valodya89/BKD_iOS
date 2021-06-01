//
//  SearchResultCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-05-21.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"
        
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
            
        }

    @IBOutlet weak var mCarMarkaBckgV: UIView!
    @IBOutlet weak var mInfoV: UIView!
    @IBOutlet weak var mflipBtn: UIButton!
    @IBOutlet weak var mDetailsBtn: UIButton!
    @IBOutlet weak var mDetailsUnderLineV: UIView!
    
    @IBOutlet weak var mFiatImgV: UIImageView!
    @IBOutlet weak var mCarNameLb: UILabel!
    
    
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mGradientEuroLb: UILabel!
    @IBOutlet weak var mGradientValueLb: UILabel!
    
    @IBOutlet weak var mOffertBckgV: UIView!
    @IBOutlet weak var mOffertImgV: UIImageView!
    @IBOutlet weak var mOffertValueLB: UILabel!
    @IBOutlet weak var mOffertEuroLb: UILabel!
    @IBOutlet weak var mValueLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mValueDeleteV: UIView!
    
    @IBOutlet weak var mMoreInfoBtn: UIButton!
    @IBOutlet weak var mReserveBtn: UIButton!
    
    @IBOutlet weak var mFlipReserveBtn: UIButton!
    @IBOutlet weak var mFlipMoreInfoBtn: UIButton!
    
    @IBOutlet weak var mCarImgV: UIImageView!
    
    
    @IBOutlet weak var mFlipInfoV: UIView!
    
    @IBOutlet var mCardImgV: UIImageView!
    @IBOutlet var mCubeImgV: UIImageView!
    @IBOutlet var mKgImgV: UIImageView!
    @IBOutlet var mMetrImgV: UIImageView!
    
    @IBOutlet var mCardLb: UILabel!
    @IBOutlet var mCubeLb: UILabel!
    @IBOutlet var mKgLb: UILabel!
    @IBOutlet var mMetrLb: UILabel!
    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var mCarImageViewCenterY: NSLayoutConstraint!
    
    private var isFlipView: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func setupView() {
        // corner radius
        mInfoV.layer.cornerRadius = 10
        mFlipInfoV.layer.cornerRadius = 10

        // border
        mInfoV.layer.borderWidth = 0.2
        mInfoV.layer.borderColor = UIColor.lightGray.cgColor
        mFlipInfoV.layer.borderWidth = 0.2
        mFlipInfoV.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        mInfoV.setShadow(color: UIColor.lightGray)
        mFlipInfoV.setShadow(color: UIColor.lightGray)

        //gradient
       // mGradientV.setGradient(startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
       // mGradientV.setGradientWithCornerRadius(cornerRadius: 0, startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
       // mCarMarkaBckgV.setGradientWithCornerRadius(cornerRadius: 0, startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
        //mCarMarkaBckgV.setGradient(startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
        initButtons(btn: mMoreInfoBtn)
        initButtons(btn: mReserveBtn)
        initButtons(btn: mFlipMoreInfoBtn)
        initButtons(btn: mFlipReserveBtn)
                
    }
    func initButtons(btn:UIButton) {
        btn.addBorder(color: color_btn_pressed!, width: 1.0)
        btn.layer.cornerRadius = 8
    }
 
    @IBAction func details(_ sender: UIButton) {
        if isFlipView {
            UIView.transition(with: mFlipInfoV, duration: 0.5, options: [.transitionFlipFromRight], animations: nil) { [self]_ in
                self.mInfoV.isHidden = !self.mInfoV.isHidden
                self.mFlipInfoV.isHidden = !self.mFlipInfoV.isHidden
            }
            UIView.animate(withDuration: 0.5) {
                self.mCarImageViewCenterY.constant = 0
                self.layoutIfNeeded()
            }
        } else {
            UIView.transition(with: mInfoV, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil) { [self]_ in
                self.mInfoV.isHidden = !self.mInfoV.isHidden
                self.mFlipInfoV.isHidden = !self.mFlipInfoV.isHidden
                self.mCarImageViewCenterY.constant = -20
            }
            UIView.animate(withDuration: 0.5) {
                self.mCarImageViewCenterY.constant = -20
                self.layoutIfNeeded()
            }
        }
       
        isFlipView = !isFlipView
       
    }
    
    @IBAction func moreInfo(_ sender: UIButton) {
        mMoreInfoBtn.backgroundColor = color_btn_pressed
        mFlipMoreInfoBtn.backgroundColor = color_btn_pressed
        mReserveBtn.backgroundColor = .clear
        mFlipReserveBtn.backgroundColor = .clear

    }
    
    @IBAction func reserve(_ sender: UIButton) {
        mReserveBtn.backgroundColor = color_btn_pressed
        mFlipReserveBtn.backgroundColor = color_btn_pressed
        mMoreInfoBtn.backgroundColor = .clear
        mFlipMoreInfoBtn.backgroundColor = .clear


    }
}


