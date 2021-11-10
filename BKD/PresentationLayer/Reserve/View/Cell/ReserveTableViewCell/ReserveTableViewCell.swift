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

    
    func setDriversCell(item: MyDriversModel, index: Int)  {
        mFullNameLb.text = item.fullname
        mAccessorieTitleBckgV.isHidden = true
        mAccessoriesImgV.isHidden = true
        
    }
    
    func setAccessoriesCell(item: AccessoriesEditModel, index: Int)  {
        mFullNameLb.isHidden = true
        mAccessoriesNameLb.text = item.name
        mAccessoriesCountLb.text = "x" + String(item.count ?? 1)
        mAccessoriesImgV.sd_setImage(with:  item.imageUrl ?? URL(string: ""), placeholderImage: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
