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
//    required  ?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//      //  self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
//        
////        self.layer.borderWidth = 10
////        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
//    }
    
    ///Set cell information
    func  setInfoCell(item:CategoryCarouselModel, index: Int, currentPage: Int ) {
        
        mCategoryImg.image = item.CategoryImg
        mCategoryNameLb.text = item.categoryName
        if index == currentPage {
            backgroundColor = color_menu
            mCategoryNameLb.textColor = color_selected_filter_fields
            mCategoryImg.setTintColor(color: color_selected_filter_fields!)
        } else {
            backgroundColor = color_carousel
            mCategoryNameLb.textColor = .white
            mCategoryImg.setTintColor(color: color_carousel_img_tint!)
        }
    }
}
