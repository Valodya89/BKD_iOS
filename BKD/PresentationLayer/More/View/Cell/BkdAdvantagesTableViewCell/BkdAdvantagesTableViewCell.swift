//
//  BkdAdvantagesTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit

class BkdAdvantagesTableViewCell: UITableViewCell {
    static let identifier = "BkdAdvantagesTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    //MARK: Outlets
    @IBOutlet weak var mAvailable: UILabel!
    @IBOutlet weak var mPersonalizedApproachLb: UILabel!
    @IBOutlet weak var mCaseOurChallengeLb: UILabel!
    @IBOutlet weak var mFastSafeLb: UILabel!
    @IBOutlet weak var mBckgShadowV: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    // set info to the cell
    func setCellInfo(item: BkdAdvantagesModel) {
        mBckgShadowV.setShadow(color: color_shadow!)
        mBckgShadowV.layer.cornerRadius = 3
        mAvailable.text = item.title1
        mPersonalizedApproachLb.text = item.title2
        mCaseOurChallengeLb.text = item.title3
        mFastSafeLb.text = item.title4
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
