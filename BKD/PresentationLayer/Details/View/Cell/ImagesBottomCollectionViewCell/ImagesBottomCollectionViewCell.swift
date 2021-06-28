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
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIScreen.main.nativeBounds.height <= 1334 {
            mShadowBckgV.frame = CGRect(x: mShadowBckgV.frame.origin.x, y: mShadowBckgV.frame.origin.y, width: mShadowBckgV.frame.width - 7, height: mShadowBckgV.frame.height - 11)
        }
       
    }
    
    /// set cell info
    func setCellInfo(item: CarModel, currentImageIndex: Int, index: Int ) {
        removeBorderFromCell()
        mImgV.contentMode = .scaleAspectFit
        mShadowBckgV.layer.cornerRadius = 3
        contentView.setShadow(color: color_shadow!)
        mImgV.image = item.carImage
       
        
        if  currentImageIndex == index {
           
             //  mShadowBckgV.makeBorderWithCornerRadius(radius: 3, borderColor: color_navigationBar!, borderWidth: 0.5)
            mShadowBckgV.roundCornersWithBorder(corners: .allCorners, radius: 3, borderColor: color_navigationBar!, borderWidth: 0.5)
        }
    }
   
    ///Remove CAShapeLayer(border) from view
     func removeBorderFromCell() {
        if mShadowBckgV.layer.sublayers != nil {
            for layer in mShadowBckgV.layer.sublayers! {
               if layer.isKind(of: CAShapeLayer.self) {
                  layer.removeFromSuperlayer()
               }
            }
        }
    }
}
