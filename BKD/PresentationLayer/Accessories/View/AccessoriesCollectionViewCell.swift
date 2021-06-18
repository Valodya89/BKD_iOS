//
//  AccessoriesCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit
protocol AccessoriesCollectionViewCellDelegate: AnyObject {
    func didPressAdd(addValue: Double, isIncrease: Bool)
}
class AccessoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "AccessoriesCollectionViewCell"
   
    //MARK: Outlates
   
    @IBOutlet weak var mAddBtn: UIButton!
    @IBOutlet weak var mIncreaseBtn: UIButton!
    @IBOutlet weak var mDecreaseBtn: UIButton!
    @IBOutlet weak var mAccessorieImgV: UIImageView!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mAccessoriesInfoBckgV: UIView!
    @IBOutlet weak var mAccessorieCountLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    
    @IBOutlet weak var mAddImgV: UIImageView!
    weak var delegate: AccessoriesCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func setupView() {
       // mAddBtn.setBorder(color: color_navigationBar!, width: 1)
//        mAccessoriesInfoBckgV.setBorder(color: color_shadow!.withAlphaComponent(0.1), width: 0.5)

        mAccessoriesInfoBckgV.roundCorners(corners: .bottomRight, radius: 32)
        mAccessoriesInfoBckgV.setShadow(color: color_shadow!)

    }
    
    func setCellInfo() {
        mAddBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        mIncreaseBtn.addTarget(self, action: #selector(increase), for: .touchUpInside)
        mDecreaseBtn.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        
    }
    
    
    @objc func add(sender: UIButton) {
        let count = mAccessorieCountLb.formattToNumber()
        let price = mPriceLb.formattToNumber()
        let addValue: Double = Double(truncating: count) * Double(truncating: price)
        
        if sender.titleColor(for: .normal) == color_navigationBar! { //select
            mAddImgV.image = #imageLiteral(resourceName: "added")
            sender.setTitleColor(color_menu, for: .normal)
            delegate?.didPressAdd(addValue: addValue, isIncrease: true)
        } else {// unselect
            mAddImgV.image = #imageLiteral(resourceName: "add")
            sender.setTitleColor(color_navigationBar!, for: .normal)
            delegate?.didPressAdd(addValue: addValue, isIncrease: false)
        }
    }
    @objc func increase() {
        let count = mAccessorieCountLb.formattToNumber()
        let price = mPriceLb.formattToNumber()
        let addValue: Double = Double(truncating: price)
    
        mAccessorieCountLb.text = String(Int(truncating: count) + 1)
        if mAddBtn.titleColor(for: .normal) == color_menu!  {
            delegate?.didPressAdd(addValue: addValue, isIncrease: true)
        }
    }
    @objc func decrease() {
        let count = mAccessorieCountLb.formattToNumber()
        let price = mPriceLb.formattToNumber()
        let addValue: Double = Double(truncating: price)
        
        if Int(truncating: count)  > 1  {
            mAccessorieCountLb.text = String(Int(truncating: count) - 1)
            if mAddBtn.titleColor(for: .normal) == color_menu! {
                delegate?.didPressAdd(addValue: addValue, isIncrease: false)
            }
        }
        
       
    }

}
