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
        unselectCell()
    }
    
    ///Set cell info
    func setCellInfo(item: EquipmentModel) {
        mTitleLb.text = item.equipmentName
        mImageV.image = item.equipmentImg
        mImageV.setTintColor(color: mImageV.tintColor)
        if item.didSelect {
            DispatchQueue.main.async {
                self.mImageV.setTintColor(color: color_selected_filter_fields!)
                self.mTitleLb.font = font_selected_filter
                self.mTitleLb.textColor = color_selected_filter_fields
    //            self.layer.borderColor = color_menu!.cgColor
    //            self.backgroundColor = color_menu!
                self.backgroundColor = color_btn_pressed
                self.layer.borderWidth = 0.0
            }
            
        } else {
            unselectCell()
        }
    }
    
    private func unselectCell() {
        DispatchQueue.main.async { 
            self.layer.borderWidth = 1.0
            self.backgroundColor = .clear
            self.mImageV.setTintColor(color: color_exterior_tint!)
            self.mTitleLb.font = font_unselected_filter
            self.mTitleLb.textColor = color_filter_fields
    //        self.layer.borderColor = color_navigationBar?.cgColor
    //        self.backgroundColor = .clear
        }
        

    }

}
