//
//  SearchPhoneCodeTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

class SearchPhoneCodeTableViewCell: UITableViewCell {
    static let identifier = "SearchPhoneCodeTableViewCell"

    //MARK: Outlets
    @IBOutlet weak var mFlagImgV: UIImageView!
    @IBOutlet weak var mCodeLb: UILabel!
    @IBOutlet weak var mCountryLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
