//
//  CarouselCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-06-21.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
 
    static let identifier = "CarouselCollectionViewCell"
    
    @IBOutlet weak var mCategoryNameLb: UILabel!
    @IBOutlet weak var mCategoryImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 2
        self.setShadow(color: color_shadow!)
        // Initialization code
    }

    
    ///Set cell information
    func  setInfoCell(item:CarTypes, typeImages: [UIImage], index: Int, currentPage: Int ) {
        mCategoryNameLb.text = item.name
        self.mCategoryImg.image = typeImages[index]
            if index == currentPage {
                self.backgroundColor = color_menu
                self.mCategoryNameLb.textColor = color_selected_filter_fields
                self.mCategoryImg.setTintColor(color: color_selected_filter_fields!)
            } else {
                self.backgroundColor = color_carousel
                self.mCategoryNameLb.textColor = .white
                self.mCategoryImg.setTintColor(color: color_carousel_img_tint!)
            }

    }
}
