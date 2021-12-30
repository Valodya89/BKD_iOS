//
//  MailBoxNumberTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

class MailBoxNumberTableCell: UITableViewCell {
    
    static let identifier = "MailBoxNumberTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlet
    @IBOutlet weak var mFildNameLb: UILabel!
    @IBOutlet weak var mTxtFl: TextField!
    @IBOutlet weak var mCheckBoxBtn: UIButton!
    @IBOutlet weak var mIDondLiveInBuildingLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    ///Set cell information
    func setCellInfo(item: MainDriverModel, index: Int, isEdit: Bool) {
        mFildNameLb.text = item.fieldName
        mTxtFl.text = item.fieldValue
        if item.fieldValue == "" || item.fieldValue == nil {
            mCheckBoxBtn.setImage(img_check_box, for: .normal)
        }
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
    }
}
