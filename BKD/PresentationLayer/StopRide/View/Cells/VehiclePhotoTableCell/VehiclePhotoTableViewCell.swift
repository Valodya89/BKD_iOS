//
//  VehiclePhotoTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-12-21.
//

import UIKit

class VehiclePhotoTableViewCell: UITableViewCell {
    static let identifier = "VehiclePhotoTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var mImageV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mImageV.layer.cornerRadius = 3
    }

    func setInfoCell(item: Defect?) {
        if item?.image != nil {
        mImageV.sd_setImage(with:  item?.image!.getURL() ?? URL(string: ""), placeholderImage: nil)
        }
    }
    
}
