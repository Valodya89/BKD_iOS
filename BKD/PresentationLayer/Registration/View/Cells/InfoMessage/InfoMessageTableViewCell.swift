//
//  InfoMessageTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class InfoMessageTableViewCell: UITableViewCell {
    static let identifier = "InfoMessageTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mMessageLb: UILabelPadding!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func draw(_ rect: CGRect) {
        mMessageLb.padding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        mMessageLb.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 8.0)
    }

    
    override func prepareForReuse() {
        mMessageLb.text = ""
        mMessageLb.padding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
       // mMessageLb.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 8.0)
    }
    
    func setCellInfo(items: [RegistrationBotModel], index: Int  )  {
        let model = items[index]
        mMessageLb.removeCAShapeLayer()

        mMessageLb.text = model.msgToFill
        if index >= 1 &&  items[index - 1].msgToFill != nil {
            mMessageLb.layer.frame = mMessageLb.bounds

            mMessageLb.layer.masksToBounds = true
            mMessageLb.layer.cornerRadius = 8

           // mMessageLb.roundCorners(corners: [.allCorners], radius: 8.0)
        } else {
            mMessageLb.layer.cornerRadius = 0
            mMessageLb.removeCAShapeLayer()
//            mMessageLb.layoutIfNeeded()
//            mMessageLb.setNeedsLayout()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
                self.mMessageLb.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 8.0)
            }
        }
        if let _ = model.msgToFillBold {
            mMessageLb.setAttributeBold(text: model.msgToFill!, boldText: model.msgToFillBold!, color: color_alert_txt!)
        }
       
    }
    
}
