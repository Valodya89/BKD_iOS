//
//  AditionalDriverTableCell.swift
//  AditionalDriverTableCell
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit

class AditionalDriverTableCell: UITableViewCell {

    
    static let identifier = "AditionalDriverTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlets
    @IBOutlet weak var mAdditionalDriverHeight: NSLayoutConstraint!
    @IBOutlet weak var mAdditionalDriverLb: UILabel!
    @IBOutlet weak var mDriverNameLb: UILabel!
    @IBOutlet weak var mDriverNumberLb: UILabel!
    

    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
   }
   
   
   func setCellInfo(item: MyDriversModel, index: Int) {
       mAdditionalDriverLb.isHidden = (index != 0)
       if index != 0 {
           mAdditionalDriverHeight.constant = 0
       }
       mDriverNameLb.text = item.fullname
       mDriverNumberLb.text = item.licenciNumber
   }
    
}
