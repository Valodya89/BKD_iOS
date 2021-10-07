//
//  CompareCategoryTableCell.swift
//  CompareCategoryTableCell
//
//  Created by Karine Karapetyan on 06-10-21.
//

import UIKit

class CompareCategoryTableCell: UITableViewCell {
    static let identifier = "CompareCategoryTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    //MARK: --Outlets
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mImgV: UIImageView!
    
    //MARK: -- Variables
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCategoryCellInfo(item: CarTypes) {
        mTitleLb.text = item.name
        if item.image != nil {
            mImgV.sd_setImage(with:item.image!.getURL()!, placeholderImage: nil)
        }
    }
    
    
    func setVehicleCellInfo(item: CarModel) {
//        mTitleLb.text = item.name
//        if item.image != nil {
//            mImgV.sd_setImage(with:item.image!.getURL()!, placeholderImage: nil)
//        }
    }
    
}
