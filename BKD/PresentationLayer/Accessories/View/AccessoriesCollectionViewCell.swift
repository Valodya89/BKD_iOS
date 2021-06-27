//
//  AccessoriesCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit
protocol AccessoriesCollectionViewCellDelegate: AnyObject {
    func didPressAdd(accessories:  AccessoriesModel, isIncrease: Bool)
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
    @IBOutlet weak var mAccessoriesBackgImgV: UIImageView!
    @IBOutlet weak var mPriceLb: UILabel!
    
    @IBOutlet weak var mAddImgV: UIImageView!
    weak var delegate: AccessoriesCollectionViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func setupView() {
       // mAddBtn.setBorder(color: color_navigationBar!, width: 1)

       // mAccessoriesInfoBckgV.roundCorners(corners: .bottomRight, radius: 32)
        
//        mAccessoriesInfoBckgV.roundCorners(corners: [.bottomRight], radius: 50)

        mAccessoriesBackgImgV.setShadow(color: color_shadow!)
    }
    
    func setCellInfo(item: AccessoriesModel) {
        mAccessorieImgV.image = item.accessoryImg
        mTitleLb.text = item.accessoryName
        mPriceLb.text = String(item.accessoryPrice!)
        mAddBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        mIncreaseBtn.addTarget(self, action: #selector(increase(sender:)), for: .touchUpInside)
        mDecreaseBtn.addTarget(self, action: #selector(decrease(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc func add(sender: UIButton) {
        let count = Int(mAccessorieCountLb.text ?? "0")
        let price = Double(mPriceLb.text ?? "0")
        var accessoriesModel: AccessoriesModel = AccessoriesModel(accessoryImg: mAccessorieImgV.image!,
                                                                  accessoryName: mTitleLb.text!,
                                                                  accessoryPrice:Double(count!) * price!, accessoryCount: count)
        
        if sender.titleColor(for: .normal) == color_alert_txt { //select
            mAddImgV.image = img_add
            sender.setTitleColor(color_menu, for: .normal)
            delegate?.didPressAdd(accessories: accessoriesModel, isIncrease: true)
        } else {// unselect
            mAddImgV.image = #imageLiteral(resourceName: "add")
            sender.setTitleColor(color_alert_txt!, for: .normal)
            delegate?.didPressAdd(accessories: AccessoriesModel(accessoryPrice:Double(count!) * price!, accessoryCount: count), isIncrease: false)
        }
    }
    @objc func increase(sender: UIButton) {
       
        setButtonClickImage(sender: sender, image: #imageLiteral(resourceName: "selected_plus"))
        let count = Int(mAccessorieCountLb.text ?? "0" )
        let price = Double(mPriceLb.text ?? "0" )
    
        mAccessorieCountLb.text = String(count! + 1)
        if mAddBtn.titleColor(for: .normal) == color_menu!  {
            delegate?.didPressAdd(accessories: AccessoriesModel(accessoryPrice:price!), isIncrease: true)
        }
    }
    @objc func decrease(sender: UIButton) {
        let count = Int(mAccessorieCountLb.text ?? "0" )
        let price = Double(mPriceLb.text ?? "0" )
        
        if count! > 1  {
            mAccessorieCountLb.text = String(count! - 1)
            if mAddBtn.titleColor(for: .normal) == color_menu! {
                delegate?.didPressAdd(accessories: AccessoriesModel(accessoryPrice:price!), isIncrease: false)
            }
        }
       
    }
    
    private func setButtonClickImage (sender: UIButton, image: UIImage) {
        let oldImg = sender.image(for: .normal)
        sender.setImage(image, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
            sender.setImage(oldImg, for: .normal)
         }
    }

}
