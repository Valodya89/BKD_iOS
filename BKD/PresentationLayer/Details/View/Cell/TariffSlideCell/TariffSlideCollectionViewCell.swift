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
    
    /// set tarif slide info
    func setTariffSlideCellInfo(item: TariffSlideModel, index: Int) {
        mDetailsBckgV.isHidden = true
        mTitleLb.text = item.type
        containerV.backgroundColor = item.bckgColor
        isUserInteractionEnabled = true
        mTitleLb.textColor = item.typeColor
    }
    
    /// set info for open slide
    func setOptionsTariffSlideCellInfo(item: TariffSlideModel, index: Int) {
        mDetailsBckgV.isHidden = false
        mDetailTitleLb.text = item.name
        mDetailValueLb.text = Constant.Texts.euro + " " + (item.value ?? "")!
        mDetailValueLb.textColor = item.typeColor
        mDetailTitleLb.textColor = item.typeColor
        mDetailsBckgV.backgroundColor = item.bckgColor
    }
}
