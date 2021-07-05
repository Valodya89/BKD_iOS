//
//  MyBkdTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-07-21.
//

import UIKit

class MyBkdTableViewCell: UITableViewCell {
    
    static let identifier = "MyBkdTableViewCell"

    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
