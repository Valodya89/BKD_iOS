//
//  MainCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 07-05-21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
static let identifier = "MainCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
        
    }
    @IBOutlet weak var mOffertPriceLb: UILabel!
    @IBOutlet weak var mInfoBckV: UIView!
    @IBOutlet weak var mOffertBackgV: UIView!
    @IBOutlet weak var mValueBckV: UIView!
    
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mCardImgV: UIImageView!
    @IBOutlet weak var mCubeImgV: UIImageView!
    @IBOutlet weak var mKgImgV: UIImageView!
    @IBOutlet weak var mCarUseImgV: UIImageView!
    @IBOutlet weak var mOffertImgV: UIImageView!
    @IBOutlet weak var mFiatImgV: UIImageView!
    @IBOutlet weak var mTowBarIngV: UIImageView!
    
    @IBOutlet weak var mCardLb: UILabel!
    @IBOutlet weak var mCubeLb: UILabel!
    @IBOutlet weak var mKgLb: UILabel!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarUseLb: UILabel!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mValueLb: UILabel!
    
    @IBAction func mSwitch(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
     
        // corner radius
        mInfoBckV.layer.cornerRadius = 10
        mValueBckV.clipsToBounds = true
        mValueBckV.layer.cornerRadius = 10
        mValueBckV.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        // border
        mInfoBckV.layer.borderWidth = 0.2
        mInfoBckV.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        mInfoBckV.setShadow(color: color_shadow!)
        
        //gradient
        mValueBckV.setGradient(startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
        
        
        let amountText = NSMutableAttributedString.init(string: mValueLb.text!)

        // set the custom font and color for the 0,1 range in string
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                  NSAttributedString.Key.foregroundColor: UIColor(named: "value") as Any],
                                     range: NSMakeRange(0, 1))
        // if you want, you can add more attributes for different ranges calling .setAttributes many times
        // set the attributed string to the UILabel object

        // set the attributed string to the UILabel object
        mValueLb.attributedText = amountText
        

    }

}
