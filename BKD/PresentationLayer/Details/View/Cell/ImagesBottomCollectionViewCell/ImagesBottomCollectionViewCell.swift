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
    }
    
    /// set cell info
    func setCellInfo(item: CarModel ) {
        removeBorderFromCell()
        mImgV.contentMode = .scaleAspectFit
        mShadowBckgV.layer.cornerRadius = 3
        contentView.setShadow(color: color_shadow!)
        mImgV.image = item.carImage
    }
   
    ///Remove CAShapeLayer(border) from view
    private func removeBorderFromCell() {
        if mShadowBckgV.layer.sublayers != nil {
            for layer in mShadowBckgV.layer.sublayers! {
               if layer.isKind(of: CAShapeLayer.self) {
                  layer.removeFromSuperlayer()
               }
            }
        }
    }
}
