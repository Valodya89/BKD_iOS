//
//  AccidentFormTableViewCell.swift
//  AccidentFormTableViewCell
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit

class AccidentFormTableCell: UITableViewCell {

    static let identifier = "AccidentFormTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    //MARK: --Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
