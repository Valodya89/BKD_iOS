//
//  RegisterNumberTableCell.swift
//  RegisterNumberTableCell
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit

class RegisterNumberTableCell: UITableViewCell {
    
    static let identifier = "RegisterNumberTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    //MARK: -- Outlets
    @IBOutlet weak var mRegisterNumberTitleLb: UILabel!
    @IBOutlet weak var mRegisterNumberLb: UILabel!
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        mRegisterNumberLb.text = ""
   }
   
   
    func setCellInfo(item: String ) {
       mRegisterNumberLb.text = item
 
   }
   
   
    
}
