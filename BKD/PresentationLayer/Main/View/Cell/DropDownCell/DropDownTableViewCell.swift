//
//  DropDownTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
    
    static let identifier = "DropDownTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
   //MARK: Outlet
    @IBOutlet weak var mLocationNameLb: EdgeInsetLabel!
    @IBOutlet weak var mMapImgV: UIImageView!
    @IBOutlet weak var mSeeMapBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        
    }
    
    func setUpView() {
        mSeeMapBtn.addBorder(color: UIColor(named:"see_map")!, width: 1.0)
        mSeeMapBtn.layer.cornerRadius = 10
        mSeeMapBtn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
        mLocationNameLb.textInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0)

       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func seeMap(_ sender: UIButton) {
        sender.backgroundColor = UIColor(named: "see_map_backg")
    }
}
