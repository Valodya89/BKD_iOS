//
//  ExamplePhotoTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class ExamplePhotoTableViewCell: UITableViewCell {
    
    static let identifier = "ExamplePhotoTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
   //MARK: Outlet
    @IBOutlet weak var mImageV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mImageV.layer.cornerRadius = 3.0
    }

    override func prepareForReuse() {
            
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
