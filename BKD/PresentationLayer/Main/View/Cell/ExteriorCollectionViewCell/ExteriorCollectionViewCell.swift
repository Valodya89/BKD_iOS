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
   
//    override var isSelected: Bool {
//           didSet {
//            
//             //  if isSelected {
//                   backgroundColor = color_btn_pressed
//                   layer.borderWidth = 0.0
//print(selectedItems)
////               } else {
////                backgroundColor = .clear
////                layer.borderWidth = 1.0
////
////               }
//
//
//           }
//       }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setBorder(color: color_navigationBar!, width: 1)
        layer.cornerRadius = self.frame.size.height/2.5
    }


}
