//
//  AccidentFormTableViewCell.swift
//  AccidentFormTableViewCell
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit

class AccidentFormTableCell: UITableViewCell {

    static let identifier = "AccidentFormTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    
    @IBOutlet weak var mFormPhotoContentV: UIView!
    @IBOutlet weak var mAddAndTakePhotoContentV: UIView!
    @IBOutlet weak var mFormPhotoImgV: UIImageView!
    
    //Take photo
    @IBOutlet weak var mTakePhotoContentV: UIView!
    @IBOutlet weak var mTakePhotoLb: UILabel!
    @IBOutlet weak var mCameraImgV: UIImageView!
    @IBOutlet weak var mTakePhotoBtn: UIButton!
    
    //Add more
    @IBOutlet weak var mAddMoreContentV: UIView!
    @IBOutlet weak var mPluseImgV: UIImageView!
    @IBOutlet weak var mAddMoreLb: UILabel!
    @IBOutlet weak var mAddMoreBtn: UIButton!
    
    //MARK: -- Viriables
    var didPressTakePhoto:((Int)->Void)?
    var didPressAddMore:((Int)->Void)?
    
    
    //MARK: --Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    
    func setupView() {
        
        mTakePhotoContentV.layer.cornerRadius = mTakePhotoContentV.frame.height/2
        mTakePhotoContentV.setBorder(color: color_navigationBar!, width: 1.0)
        mAddMoreContentV.layer.cornerRadius = 8
        mAddMoreContentV.setBorder(color: color_menu!, width: 1.0)
        mFormPhotoImgV.layer.cornerRadius = 3
        mFormPhotoContentV.isHidden = true

    }
    
    override func prepareForReuse() {
      ///Take photo
        mTakePhotoContentV.backgroundColor = color_background
        mTakePhotoLb.textColor = color_navigationBar!
        mCameraImgV.setTintColor(color: color_navigationBar!)

        mAddAndTakePhotoContentV.isHidden = false
        mFormPhotoContentV.isHidden = true
        mTakePhotoContentV.isHidden = true
        mAddMoreContentV.isHidden = true
        mFormPhotoImgV.image = nil
    }
    

    
    /// Set cell informaton
    func setCallInfo(itemList: [AccidentFormModel], index: Int) {
        let item = itemList[index]
        mTakePhotoBtn.tag = index
        mAddMoreBtn.tag = index
        mAddMoreBtn.addTarget(self, action: #selector(addMore(sender: )), for: .touchUpInside)
        mTakePhotoBtn.addTarget(self, action: #selector(takePhoto(sender: )), for: .touchUpInside)
        
        mTakePhotoContentV.isHidden = !item.isTakePhoto
        
        if let img = item.accidentFormImg {
            mFormPhotoImgV.image = img
            mFormPhotoContentV.isHidden = false
            if index == itemList.count - 1 {
                mAddAndTakePhotoContentV.isHidden = false
                mAddMoreContentV.isHidden = false
            } else {
                mAddAndTakePhotoContentV.isHidden = true
            }
        }
        updateTakePhoto(isError: item.isError!)
    }

    ///Update take photo button style
    private func updateTakePhoto(isError: Bool) {
        
        let color:UIColor = isError ? color_error! : color_navigationBar!
        mTakePhotoLb.textColor = color
        mTakePhotoContentV.layer.borderColor = color.cgColor
        mCameraImgV.setTintColor(color: color)
    }
    
    
    /// pressed take photo button
    @objc func takePhoto(sender: UIButton) {
        mTakePhotoContentV.backgroundColor = color_navigationBar!
        mTakePhotoContentV.layer.borderColor = color_navigationBar!.cgColor
        mCameraImgV.setTintColor(color: .white)
        mTakePhotoLb.textColor = .white
        
        didPressTakePhoto?(sender.tag)
    }
    
    /// pressed add more button
    @objc func addMore(sender: UIButton) {
      
        didPressAddMore?(sender.tag)
    }
    
}
