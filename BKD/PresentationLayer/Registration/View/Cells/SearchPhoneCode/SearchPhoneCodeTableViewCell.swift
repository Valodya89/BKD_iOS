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
    
    override func prepareForReuse() {
        backgroundColor = .clear
        layer.cornerRadius = 0
        mCountryLb.textColor = color_dark_register!
    }
    
    
    func setCellInfo(item: PhoneCode)  {
        mCountryLb.text = item.country
        mCodeLb.text = item.code
        mFlagImgV.image = item.imageFlag
        
        if isSelected {
            layer.cornerRadius = 8
            backgroundColor = color_dark_register!
            mCountryLb.textColor = color_menu!

        }
    
    }
    

}
