//
//  ImagesBottomCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-06-21.
//

import UIKit

class ImagesBottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImagesBottomCollectionViewCell"
    //MARK: Outlet
    @IBOutlet weak var mImgV: UIImageView!

    @IBOutlet weak var mShadowBckgV: UIView!

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mShadowBckgV.layer.borderColor = UIColor.clear.cgColor
        setShadow()
    }
    
    override func draw(_ rect: CGRect) {
        setShadow()
    }
    
    
    override func prepareForReuse() {
        mShadowBckgV.layer.borderColor = UIColor.clear.cgColor
        setShadow()
    }

    private func setShadow() {
        mImgV.contentMode = .scaleAspectFit
        mShadowBckgV.layer.cornerRadius = 3
        contentView.setShadow(color: color_shadow!)
    }
    
    /// set cell info
    func setCellInfo(img: UIImage, currentImageIndex: Int, index: Int ) {

        mImgV.image = img
        if  currentImageIndex == index {
            
            mShadowBckgV.layer.cornerRadius = 3
            mShadowBckgV.layer.borderWidth = 0.5
           // mShadowBckgV.layer.borderColor = color_navigationBar!.cgColor
            
            if #available(iOS 13.0, *) {
                self.traitCollection.performAsCurrent {
                    mShadowBckgV.layer.borderColor = color_navigationBar!.cgColor
//                mShadowBckgV.layer.borderColor = color_navigationBar?.resolvedColor(with: self.traitCollection).cgColor
                }
            } else {
                // Fallback on earlier versions
                mShadowBckgV.layer.borderColor = color_navigationBar!.cgColor
            }

        }
    }
   
}
