//
//  VehicleDimageCollectionCell.swift
//  VehicleDimageCollectionCell
//
//  Created by Karine Karapetyan on 20-09-21.
//

import UIKit

class VehicleDimageCollectionCell: UICollectionViewCell {
    static let identifier = "VehicleDimageCollectionCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    //MARK: -- Outlets
    ///Damage image
    @IBOutlet weak var mDamageContentV: UIView!
    @IBOutlet weak var mDamageNameLb: UILabel!
    @IBOutlet weak var mDamageGradientV: UIView!
    @IBOutlet weak var mDamageImgV: UIImageView!
    
    ///Add damage
    @IBOutlet weak var mAddDAmageContentV: UIView!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mInfoLb: UILabel!
    @IBOutlet weak var mAddDamageLb: UILabel!
    @IBOutlet weak var mAddBtn: UIButton!
    
    //MARK: -- Varable
    var didPressAdd:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mGradientV.setGradient(startColor: color_navigationBar!.withAlphaComponent(13.5), endColor: color_navigationBar!.withAlphaComponent(45))
        mDamageGradientV.setGradient(startColor: color_navigationBar!.withAlphaComponent(13.5), endColor: color_navigationBar!.withAlphaComponent(45))
        mDamageContentV.layer.borderColor = color_shadow!.cgColor
        mDamageContentV.layer.borderWidth = 1.0
        mAddDAmageContentV.layer.borderColor = color_shadow!.cgColor
        mAddDAmageContentV.layer.borderWidth = 1.0
    }
    
    func setCellInfo(item: StartRideModel, index: Int, isAddCell: Bool) {
        mAddBtn.addTarget(self, action: #selector(pressAdd(sender:)), for: .touchUpInside)
        mDamageNameLb.text = item.damageName
        mDamageImgV.image = item.damageImg
        mDamageContentV.isHidden = isAddCell
        mAddDAmageContentV.isHidden = !isAddCell
        
    }
    
    @objc func pressAdd(sender:UIButton) {
        didPressAdd?()
    }

}
