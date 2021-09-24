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
    }
    
    override func draw(_ rect: CGRect) {
        setupView()
    }
    func setupView() {
        mGradientV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mDamageGradientV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mDamageContentV.layer.borderColor = color_shadow!.cgColor
        mDamageContentV.layer.borderWidth = 1.0
        mAddDAmageContentV.layer.borderColor = color_shadow!.cgColor
        mAddDAmageContentV.layer.borderWidth = 1.0
        mAddBtn.setTitle("", for: .normal)
        
    }
    
    override func prepareForReuse() {
        mDamageImgV.image = img_camera!
        mDamageNameLb.text = Constant.Texts.damageName

    }
    
    
    func setCellInfo(item: StartRideModel, index: Int, isAddCell: Bool) {
        mAddBtn.addTarget(self, action: #selector(pressAdd(sender:)), for: .touchUpInside)
        mDamageNameLb.text = item.damageName
        mDamageImgV.image = item.damageImg
        mDamageContentV.isHidden = isAddCell
        mAddDAmageContentV.isHidden = !isAddCell
        if item.damageImg == img_camera {
            mDamageImgV.contentMode = .center
        } else {
            mDamageImgV.contentMode = .scaleAspectFit
        }
    }
    
    
    @objc func pressAdd(sender:UIButton) {
        didPressAdd?()
    }

}
