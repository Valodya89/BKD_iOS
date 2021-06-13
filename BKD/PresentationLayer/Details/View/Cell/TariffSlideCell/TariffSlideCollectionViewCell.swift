//
//  TariffSlideCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit

class TariffSlideCollectionViewCell: UICollectionViewCell {
    static let identifier = "TariffSlideCollectionViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    //MARK: Outlates
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mDetailsBckgV: UIView!
    @IBOutlet weak var mDetailTitleLb: UILabel!
    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var mDetailValueLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
        layer.cornerRadius = 3
    }
}
