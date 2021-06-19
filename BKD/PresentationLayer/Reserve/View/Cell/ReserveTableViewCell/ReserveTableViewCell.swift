//
//  ReserveTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class ReserveTableViewCell: UITableViewCell {
    static let identifier = "ReserveTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var mHeadreLb: UILabel!
    @IBOutlet weak var mAccessoriesNameLb: UILabel!
    @IBOutlet weak var mFullNameLb: UILabel!
    @IBOutlet weak var mAccessoriesImgV: UIImageView!
    @IBOutlet weak var mAccessorieTitleBckgV: UIView!
    @IBOutlet weak var mAccessoriesCountLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellInfo(item: ReserveModel) {
        if item.headerTitle != nil {
            mHeadreLb.text = item.headerTitle
        } else {
            mHeadreLb.isHidden = true
        }
        if item.fullName != nil {
            mFullNameLb.text = item.fullName
        }else {
            mFullNameLb.isHidden = true
        }
        
        if item.accessorieTitle != nil {
            mAccessoriesNameLb.text = item.accessorieTitle
        }else {
            mAccessorieTitleBckgV.isHidden = true
        }
        
        if item.accessorieCount != nil {
            mAccessoriesCountLb.text = item.accessorieCount
        }else {
            mAccessoriesCountLb.isHidden = true
        }
        
        if item.accessorieImg != nil {
            mAccessoriesImgV.image = item.accessorieImg
        }else {
            mAccessoriesImgV.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}