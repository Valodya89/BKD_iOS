//
//  CarAdditionalCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-05-21.
//

import UIKit

class CarEquipmentCollectionViewCell: UICollectionViewCell {
    static let identifier = "CarEquipmentCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mImageV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color_navigationBar?.cgColor
        self.layer.cornerRadius = self.frame.size.height/2.5
        mTitleLb.textColor = color_filter_fields
        mImageV.setTintColor(color: color_exterior_tint!)

    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color_navigationBar?.cgColor
        self.layer.cornerRadius = self.frame.size.height/2.5

        mTitleLb.text = ""
        mImageV.image = nil
        self.backgroundColor = .clear
        
       // mImageV.setTintColor(color: color_exterior_tint!)
        unselectCell()
    }
    
    ///Set cell info
    func setCellInfo(item: EquipmentModel) {
        mTitleLb.text = item.equipmentName
        mImageV.image = item.equipmentImg
        mImageV.setTintColor(color: mImageV.tintColor)
        if item.didSelect {
            mImageV.setTintColor(color: color_selected_filter_fields!)
            mTitleLb.font = font_selected_filter
            mTitleLb.textColor = color_selected_filter_fields
        } else {
            unselectCell()
        }
    }
    
    private func unselectCell() {
        mImageV.setTintColor(color: color_exterior_tint!)
        mTitleLb.font = font_unselected_filter
        mTitleLb.textColor = color_filter_fields
    }

}
