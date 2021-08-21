//
//  ExteriorCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-05-21.
//

import UIKit

class ExteriorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExteriorCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
  
    @IBOutlet weak var mTitleLb: UILabel!
     var selectedItems :[Int] = []
   

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        mTitleLb.backgroundColor = .clear
    }
    override func prepareForReuse() {
        setupView()
        mTitleLb.backgroundColor = .clear
        backgroundColor = .clear
        layer.borderWidth = 1.0
//        mTitleLb.textColor = item.didSelect ? color_selected_filter_fields : color_filter_fields
    }
    
    func setupView() {
        self.setBorder(color: color_navigationBar!, width: 1)
        layer.cornerRadius = self.frame.size.height/2.5
    }
    
    
    func setCellInfo(item: ExteriorModel) {
        mTitleLb.text = item.exterior!.getExterior()
        if item.didSelect {
            mTitleLb.textColor = color_selected_filter_fields
            backgroundColor = color_btn_pressed
            layer.borderWidth = 0.0

        } else {
            mTitleLb.textColor = color_filter_fields
            backgroundColor = .clear
            layer.borderWidth = 1.0

        }
    }


}
