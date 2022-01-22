//
//  AccessoriesCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit

protocol AccessoriesCollectionViewCellDelegate: AnyObject {
    func increaseOrDecreaseAccessory(accessoryPrice:Double,
                     isIncrease: Bool)
    func didPressAdd(isAdd: Bool,
                     cellIndex: Int,
                     id: String?,
                     name: String?,
                     image: UIImage?)
    func didChangeCount(isAdd: Bool,
                        cellIndex: Int,
                        count: Int)
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
    
    //MARK: -- Variables
    weak var delegate: AccessoriesCollectionViewCellDelegate?
    //let accessoriesViewModel = AccessoriesViewModel()
    var accessoryId: String?
    var maxCount: Double?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func setupView() {

      //  mAccessoriesBackgImgV.setShadow(color: color_shadow!)
    }
    
    func setCellInfo(editItem: AccessoriesEditModel, index: Int) {
        accessoryId = editItem.id
        maxCount = editItem.maxCount
        mAddBtn.tag = index
        mIncreaseBtn.tag = index
        mDecreaseBtn.tag = index
        mAddBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        mIncreaseBtn.addTarget(self, action: #selector(increase(sender:)), for: .touchUpInside)
        mDecreaseBtn.addTarget(self, action: #selector(decrease(sender:)), for: .touchUpInside)
        
        self.mAccessorieImgV.sd_setImage(with:  editItem.imageUrl ?? URL(string: ""), placeholderImage: nil)
        mTitleLb.text = editItem.name
        mPriceLb.text = String(editItem.price ?? 0.0)
        mAccessorieCountLb.text = String(1)

        if editItem.isAdded {
            mAddImgV.image = img_add_selecte
            mAddBtn.setTitleColor(color_menu, for: .normal)
            mAccessorieCountLb.text = String(editItem.count ?? 1)
        } else {
            mAddImgV.image = img_add_unselece
            mAddBtn.setTitleColor(color_alert_txt!, for: .normal)
        }
    }
    
    
    @objc func add(sender: UIButton) {
        let count = Int(mAccessorieCountLb.text ?? "0")
        let price = Double(mPriceLb.text ?? "0")
        var isIncrease = true
        
        if sender.titleColor(for: .normal) == color_alert_txt { //select
            mAddImgV.image = img_add_selecte
            sender.setTitleColor(color_menu, for: .normal)
            
            
        } else {// unselect
            isIncrease = false
            mAddImgV.image = img_add_unselece
            sender.setTitleColor(color_alert_txt!, for: .normal)
            
        }
        increaseOrDecreaseAccessory(accessoryPrice:Double(count!) * price!,
                                    accessoryCount: count!,
                                    isIncrease: isIncrease)
        delegate?.didPressAdd(isAdd: isIncrease,
                              cellIndex: sender.tag,
                              id: accessoryId,
                              name: mTitleLb.text,
                              image: mAccessorieImgV.image)
    }
    
    
    @objc func increase(sender: UIButton) {
        let count = Int(mAccessorieCountLb.text ?? "0")

        if Double(count!) < maxCount ?? 0 {
            sender.setButtonClickImage(image: #imageLiteral(resourceName: "selected_plus"))
            let count = Int(mAccessorieCountLb.text ?? "0" )
            let price = Double(mPriceLb.text ?? "0" )
            
            mAccessorieCountLb.text = String(count! + 1)
            let isAdd = mAddBtn.titleColor(for: .normal) == color_menu!
            if isAdd  {
                increaseOrDecreaseAccessory(accessoryPrice:price!,
                                            accessoryCount:count! + 1,
                                            isIncrease: true)
                
            }
            delegate?.didChangeCount(isAdd: isAdd,
                                     cellIndex: sender.tag,
                                     count: count! + 1)
        }
    }
    
    
    @objc func decrease(sender: UIButton) {
        let count = Int(mAccessorieCountLb.text ?? "0" )
        let price = Double(mPriceLb.text ?? "0" )
        
        if count! > 1  {
            mAccessorieCountLb.text = String(count! - 1)
            let isAdd = mAddBtn.titleColor(for: .normal) == color_menu!
            if isAdd  {
                increaseOrDecreaseAccessory(accessoryPrice:price!,
                            accessoryCount:count! - 1,
                            isIncrease: false)
            }
            delegate?.didChangeCount(isAdd: isAdd,
                                     cellIndex: sender.tag,
                                     count: count! - 1)
        }
       
    }
    
 
    private func increaseOrDecreaseAccessory(accessoryPrice:Double,
                             accessoryCount:Int,
                             isIncrease: Bool) {
        delegate?.increaseOrDecreaseAccessory(accessoryPrice:accessoryPrice,
                              isIncrease: isIncrease)

    }

}
