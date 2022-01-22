//
//  SubmenuTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-01-22.
//

import UIKit

class SubmenuTableCell: UITableViewCell {
    static let identifier = "SubmenuTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mTitleBtn: UIButton!
    @IBOutlet weak var mImgV: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
