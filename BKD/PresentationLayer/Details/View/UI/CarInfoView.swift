//
//  CarInfoView.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-06-21.
//

import UIKit

class CarInfoView: UIView {
//MARK: Outlates
    @IBOutlet weak var mCardImgV: UIImageView!
    @IBOutlet weak var mMeterCubeImgV: UIImageView!
    @IBOutlet weak var mKgImgV: UIImageView!
    @IBOutlet weak var mSizeImgV: UIImageView!
    
    @IBOutlet weak var mCardLb: UILabel!
    @IBOutlet weak var mMeterCubeLb: UILabel!
    @IBOutlet weak var mKgLb: UILabel!
    @IBOutlet weak var mSizeLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        
    }
}
