//
//  NavigationTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-12-21.
//

import UIKit

class NavigationTableCell: UITableViewCell {
    static let identifier = "NavigationTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
//MARK: -- Outlets
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mShadowV: UIView!
    @IBOutlet weak var mLineV: UIView!
    @IBOutlet weak var mDateLb: UILabel!
    @IBOutlet weak var mTimeLb: UILabel!
    @IBOutlet weak var mNotificationLb: UILabel!
    
    public var pressSelected: Bool = false
    var notificationSelected:((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mShadowV.layer.cornerRadius = 16
        mShadowV.setShadow(color: color_shadow!)
    }

    ///Set cell information
    func setCellInfo(item: NotificationModel, index: Int) {
        mSelectBtn.tag = index
        mSelectBtn.addTarget(self, action: #selector(selectNotification(sender:)), for: .touchUpInside)
        mSelectBtn.isEnabled = pressSelected
        mDateLb.text = item.date
        mTimeLb.text = item.time
        mNotificationLb.text = item.text
        mShadowV.backgroundColor = item.isSelect ? color_select_notif! : color_subbackground!
    }
    
    @objc func selectNotification(sender: UIButton) {
        notificationSelected?(sender.tag)
    }
}
