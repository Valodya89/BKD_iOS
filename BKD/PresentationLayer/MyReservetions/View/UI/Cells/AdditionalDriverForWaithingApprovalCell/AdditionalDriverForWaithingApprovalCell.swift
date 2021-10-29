//
//  AdditionalDriverForWaithingApprovalCell.swift
//  AdditionalDriverForWaithingApprovalCell
//
//  Created by Karine Karapetyan on 16-09-21.
//

import UIKit

class AdditionalDriverForWaithingApprovalCell: UITableViewCell {

    static let identifier = "AdditionalDriverForWaithingApprovalCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlets
    @IBOutlet weak var mAdditionalDriverLb: UILabel!
    @IBOutlet weak var mDriverFullNameLb: UILabel!
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Set cell info
    func setCellInfo(item: MyDriversModel) {
        
        mDriverFullNameLb.text = item.fullname
    }
    
}
