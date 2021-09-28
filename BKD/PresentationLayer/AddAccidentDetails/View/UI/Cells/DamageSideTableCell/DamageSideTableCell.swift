//
//  DamageSideTableCell.swift
//  DamageSideTableCell
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit


class DamageSideTableCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "DamageSideTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlets
   
    ///Selecte vehicle side
    @IBOutlet weak var mSelectSideTxtFl: TextField!
    @IBOutlet weak var mSelectSideDropDownImgV: UIImageView!
    @IBOutlet weak var mSelectSideBtn: UIButton!
    
   ///Take photo
    @IBOutlet weak var mTakePhotoContentV: UIView!
    @IBOutlet weak var mTakePhotoLb: UILabel!
    @IBOutlet weak var mCameraImgV: UIImageView!
    @IBOutlet weak var mTakePhotoBtn: UIButton!
    
   ///Add more
    @IBOutlet weak var mAddMoreContentV: UIView!
    @IBOutlet weak var mAddImgV: UIImageView!
    @IBOutlet weak var mAddMoreBtn: UIButton!
    @IBOutlet weak var mAddMoreLb: UILabel!
    
  ///Vehicle image
    @IBOutlet weak var mAddAndTakePhotoContentV: UIView!
    @IBOutlet weak var mDemageImgContentV: UIView!
    @IBOutlet weak var mDemageImgV: UIImageView!
    
    //MARK: -- Viriables
    
    var willOpenPicker:((UITextField) -> Void)?
    var didPressTakePhoto:(()->Void)?
    var didPressAddMore:(()->Void)?
    
    //MARK: --Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        mSelectSideTxtFl.setBorder(color: color_navigationBar!, width: 1.0)
        mSelectSideTxtFl.setPlaceholder(string: Constant.Texts.selectSide, font: font_placeholder!, color: color_search_placeholder!)
        
        mTakePhotoContentV.layer.cornerRadius = mTakePhotoContentV.frame.height/2
        mTakePhotoContentV.setBorder(color: color_navigationBar!, width: 1.0)
        
        mAddMoreContentV.layer.cornerRadius = 8
        mAddMoreContentV.setBorder(color: color_menu!, width: 1.0)
        mDemageImgV.layer.cornerRadius = 3
        
        mSelectSideTxtFl.delegate = self
    }
    
    override func prepareForReuse() {
       // mSelectSideDropDownImgV.image =
        mSelectSideTxtFl.setPlaceholder(string: Constant.Texts.selectSide, font: font_placeholder!, color: color_search_placeholder!)
        
        mTakePhotoContentV.backgroundColor = color_background
        mTakePhotoLb.textColor = color_navigationBar!
        mCameraImgV.setTintColor(color: color_navigationBar!)
        
        mSelectSideTxtFl.text = ""
        mAddAndTakePhotoContentV.isHidden = false
        mDemageImgContentV.isHidden = true
        mTakePhotoContentV.isHidden = true
        mAddMoreContentV.isHidden = true
        mDemageImgV.image = nil
    }
    
    /// Set cell informaton
    func setCallInfo(itemList: [DamagesSideModel], index: Int) {
        let item = itemList[index]
        mSelectSideTxtFl.tag = index
        mSelectSideBtn.tag = index
        mAddMoreBtn.tag = index
        mSelectSideBtn.addTarget(self, action: #selector(selecteSide(sender: )), for: .touchUpInside)
        mAddMoreBtn.addTarget(self, action: #selector(addMore(sender: )), for: .touchUpInside)
        
        mTakePhotoContentV.isHidden = !item.isTakePhoto

        if let side = item.damageSide {
            mSelectSideTxtFl.text = side
        }
        
        if let img = item.damageImg {
            mDemageImgV.image = img
            mDemageImgContentV.isHidden = false
            if index == itemList.count - 1 {
                mAddAndTakePhotoContentV.isHidden = false
                mAddMoreContentV.isHidden = false
            } else {
                mAddAndTakePhotoContentV.isHidden = true
            }
        }
        
        
    }

    
    @IBAction func takePhoto(_ sender: UIButton) {
        mTakePhotoContentV.backgroundColor = color_navigationBar!
        mCameraImgV.setTintColor(color: .white)
        mTakePhotoLb.textColor = .white
        
        didPressTakePhoto?()
    }
    
    @objc func selecteSide(sender: UIButton) {
        mSelectSideTxtFl.becomeFirstResponder()
    }
    
    @objc func addMore(sender: UIButton) {
        didPressAddMore?()
    }
    
    //MARK: -- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        willOpenPicker?(textField)
    }
}
