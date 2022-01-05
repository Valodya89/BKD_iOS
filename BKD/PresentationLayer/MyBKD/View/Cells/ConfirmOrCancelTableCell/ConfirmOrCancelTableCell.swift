//
//  ConfirmOrCancelTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-01-22.
//

import UIKit

class ConfirmOrCancelTableCell: UITableViewCell {
    static let identifier = "ConfirmOrCancelTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlets
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mConfirmBtn: UIButton!
    
    var didPressCancel:(()->())?
    var didPressConfirm:(()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1)
        mConfirmBtn.layer.cornerRadius = 8
        mConfirmBtn.setBorder(color: color_menu!, width: 1)
    }

    ///Set cell info
    func setCellInfo(index: Int) {
        
    }
    
    //MARK: -- Actions
    @IBAction func cancel(_ sender: UIButton) {
        didPressCancel?()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        didPressConfirm?()
    }
}
