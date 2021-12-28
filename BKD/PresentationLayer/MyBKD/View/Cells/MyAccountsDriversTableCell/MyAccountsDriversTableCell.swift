//
//  MyAccountsDriversTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit

class MyAccountsDriversTableCell: UITableViewCell {
//MyAccountsDriversTableCell
    @IBOutlet weak var mShadowV: UIView!
    
    @IBOutlet weak var mVerificationLb: UILabel!
    
    @IBOutlet weak var mFullNameLb: UILabel!
    
    @IBOutlet weak var mLicenzyNumberLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
