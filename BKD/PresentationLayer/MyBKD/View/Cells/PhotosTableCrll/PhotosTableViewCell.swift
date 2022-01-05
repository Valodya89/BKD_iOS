//
//  PhotosTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    static let identifier = "PhotosTableViewCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    //MARK: -- Outlets
    @IBOutlet weak var mPhotoTypeLb: UILabel!
    @IBOutlet weak var mPhotoSideLb: UILabel!
    @IBOutlet weak var mPhotoImgV: UIImageView!
    @IBOutlet weak var mChangePhotoBtn: UIButton!
    
    public var isEdit: Bool = false
    var didPressChangePhoto:((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mPhotoImgV.layer.cornerRadius = 8
        mChangePhotoBtn.layer.cornerRadius = mChangePhotoBtn.frame.height / 2
        mChangePhotoBtn.setBorder(color: color_navigationBar!, width: 2)
    }

    //Set cell information
    func setCellInfo(item: MainDriverModel, index: Int) {
        
       mChangePhotoBtn.tag = index
       mChangePhotoBtn.addTarget(self, action: #selector(changePhoto(sender:)), for: .touchUpInside)
       mPhotoTypeLb.isHidden = (item.fieldName == nil)
       if let fieldName = item.fieldName {
           mPhotoTypeLb.text = fieldName
       }
       mPhotoSideLb.text = item.imageSide
       mChangePhotoBtn.isHidden = !isEdit
        if item.fieldName == Constant.Texts.selfieDrivingLic {
            mPhotoSideLb.isHidden = true
        }
        
        if let img = item.editImg {
            mPhotoImgV.image = img
        } else if let url = item.imageURL {
            mPhotoImgV.sd_setImage( with: url,
                               placeholderImage: nil)
        }
    }
    
    ///Handler change photo button
    @objc func changePhoto(sender: UIButton) {
        self.didPressChangePhoto?(sender.tag)
    }

}

