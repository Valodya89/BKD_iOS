//
//  LeftTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    static let identifier = "LeftTableViewCell"
        
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
            
        }
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var mCustomerServiceV: UIView!
    
    @IBOutlet weak var mSettingsV: UIView!
    @IBOutlet weak var mChatWithUsBtn: UIButton!
    @IBOutlet weak var mFAQBtn: UIButton!
    @IBOutlet weak var mContactUsBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var mNotificationSwictch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl.font = UIFont(name: Constant.FontNames.sfproDodplay_light, size: 18)
    }

    @IBAction func dropDown(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func chatWithUs(_ sender: UIButton) {
    }
    
    @IBAction func contactUs(_ sender: UIButton) {
    }
    @IBAction func FAQ(_ sender: UIButton) {
    }
    
    @IBAction func dutch(_ sender: UIButton) {
    }
    
    @IBAction func french(_ sender: UIButton) {
    }
    
    @IBAction func english(_ sender: Any) {
    }
    @IBAction func notifications(_ sender: UIButton) {
    }
}
