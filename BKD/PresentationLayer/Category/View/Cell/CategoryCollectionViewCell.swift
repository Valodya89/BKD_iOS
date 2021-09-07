//
//  CategoryCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-05-21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
        
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
            
        }
    
    @IBOutlet weak var mInfoBckgV: UIView!
    @IBOutlet weak var mBlurBackgV: UIView!
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mBlurCarNameLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForReuse() {
        mBlurBackgV.isHidden = true
        mBlurCarNameLb.isHidden = true
        mCarNameLb.text = ""
        mBlurCarNameLb.text = ""
        mCarImgV.image = nil
    }
    
    func setUpView() {
        mInfoBckgV.layer.cornerRadius = 16
        mBlurBackgV.layer.cornerRadius = 16
        mInfoBckgV.setShadow(color:  color_shadow!)
        mBlurBackgV.setShadow(color:  color_shadow!)
        mBlurBackgV.setGradientWithCornerRadius(cornerRadius: 16, startColor: UIColor(named: "gradient_blur_start")!, endColor: UIColor(named: "gradient_blur_end")!)
    mBlurBackgV.alpha = 0.7
}
    ///Set cell info
    func setCellInfo(item: CarsModel) {
        
        mCarNameLb.text = item.name
        mBlurCarNameLb.text = item.name
        mBlurBackgV.isHidden = item.active
        mBlurCarNameLb.isHidden = item.active
        mInfoBckgV.isHidden = !item.active
        self.mCarImgV.kf.setImage(with: item.image.getURL() ?? URL(string: ""))
//        UIImage.loadFrom(url: item.image.getURL()!) { image in
//            guard let _ = image else {return}
//            self.mCarImgV.image = image
//        }
    }

}
