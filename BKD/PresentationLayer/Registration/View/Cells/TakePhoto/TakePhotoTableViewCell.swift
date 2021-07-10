//
//  TakePhotoTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit


protocol TakePhotoTableViewCellDelegate: AnyObject {
    func didPressTackePhoto(isOpenDoc: Bool)
}
class TakePhotoTableViewCell: UITableViewCell {
    
    static let identifier = "TakePhotoTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK: Outlets
    @IBOutlet weak var mTackePhotoBackgV: UIView!
    @IBOutlet weak var mTakePhotoLb: UILabel!
    @IBOutlet weak var mTakePhotoBtn: UIButton!
    @IBOutlet weak var mCameraImgV: UIImageView!
    @IBOutlet weak var mPhotoImgV: UIImageView!
    
    var isOpenDoc: Bool = false
    weak var delegate:TakePhotoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    func setUpView() {
        mTackePhotoBackgV.roundCornersWithBorder(corners: [.allCorners], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
        mPhotoImgV.layer.cornerRadius = 3
        
    }
    
    override func prepareForReuse() {
        mTackePhotoBackgV.backgroundColor = .clear
        mPhotoImgV.image = nil
        mPhotoImgV.isHidden = true
        mTakePhotoLb.textColor = color_dark_register!
        mCameraImgV.setTintColor(color: color_dark_register!)
        mTakePhotoBtn.isUserInteractionEnabled = true
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel) {
        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
            if item.viewDescription != "openDoc" {
                mPhotoImgV.isHidden = false
                mPhotoImgV.image = (item.userRegisterInfo?.photo)!
            }
            fieldFilled()
            
        } else {
            if item.viewDescription == "openDoc" {
                isOpenDoc = true
                mCameraImgV.image = #imageLiteral(resourceName: "agree")
                mTakePhotoLb.text = Constant.Texts.open
            } else {
                mCameraImgV.image = #imageLiteral(resourceName: "camera")
                mTakePhotoLb.text = Constant.Texts.takePhoto
            }
        }
    }
    
    private func fieldFilled() {
        
        mTakePhotoLb.textColor = .white
        mCameraImgV.setTintColor(color: .white)
        mTakePhotoBtn.isUserInteractionEnabled = false
        mTackePhotoBackgV.backgroundColor = color_dark_register!
        mTackePhotoBackgV.layer.cornerRadius = 10
    }
    
    
    private func docDidAgree(img: UIImage) {
        mTakePhotoLb.textColor = .white
        mCameraImgV.setTintColor(color: .white)
        mTakePhotoBtn.isUserInteractionEnabled = false
        mTackePhotoBackgV.backgroundColor = color_dark_register!
        mTackePhotoBackgV.layer.cornerRadius = 10
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        delegate?.didPressTackePhoto(isOpenDoc: isOpenDoc)
        
    }
    
}
