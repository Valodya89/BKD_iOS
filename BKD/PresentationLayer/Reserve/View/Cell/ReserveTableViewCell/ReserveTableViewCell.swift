//
//  ReserveTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class ReserveTableViewCell: UITableViewCell {

    @IBOutlet weak var mHeadreLb: UILabel!
    
    @IBOutlet weak var mAccessoriesNameLb: UILabel!
    @IBOutlet weak var mFullNameLb: UILabel!
    @IBOutlet weak var mAccessoriesImgV: UIImageView!
    @IBOutlet weak var mAccessoriesCountLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
