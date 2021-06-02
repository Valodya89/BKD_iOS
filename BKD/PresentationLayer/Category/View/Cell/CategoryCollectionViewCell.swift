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
    }
    
    func setUpView() {
        mInfoBckgV.layer.cornerRadius = 16
        mBlurBackgV.layer.cornerRadius = 16


        mInfoBckgV.setShadow(color: UIColor.lightGray)
        mBlurBackgV.setShadow(color: UIColor.lightGray)
        
        mBlurBackgV.setGradientWithCornerRadius(cornerRadius: 16, startColor: UIColor(named: "gradient_blur_start")!, endColor: UIColor(named: "gradient_blur_end")!)
    mBlurBackgV.alpha = 0.7

        
        
        //mBlurBackgV.setBlur()
    }
    
//    private func addBlurEffect(viewForBlur: UIView) {
//        let blurEffectView = UIVisualEffectView(effect: nil)
//        viewForBlur.insertSubview(blurEffectView, at: 0)
//        blurEffectView.backgroundColor = .white
//        blurEffectView.alpha = 0.75
//        blurEffectView.frame = viewForBlur.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        UIView.animate(withDuration: 0.5) {
//            blurEffectView.effect = UIBlurEffect(style: .dark)
//
//        }
//
////        viewForBlur.removeFromSuperview()
////        UIApplication.shared.windows.first?.addSubviewSizedConstraints(view: viewForBlur)
//    }
}
