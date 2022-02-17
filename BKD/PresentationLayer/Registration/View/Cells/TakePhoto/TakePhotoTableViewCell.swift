//
//  TakePhotoTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit


protocol TakePhotoTableViewCellDelegate: AnyObject {
    func didPressTackePhoto(isOpenDoc: Bool, index: Int)
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
    @IBOutlet weak var mOpenContentV: UIView!
    
    @IBOutlet weak var mOpenLb: UILabel!
    @IBOutlet weak var mAgreeImgV: UIImageView!
    @IBOutlet weak var mStackV: UIStackView!
    @IBOutlet weak var mOpenBtn: UIButton!
    
    
    
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
        
        mTackePhotoBackgV.layer.cornerRadius = mTackePhotoBackgV.frame.height/2
        mTackePhotoBackgV.setBorder(color: color_navigationBar!, width: 1.0)
        mOpenContentV.layer.cornerRadius = mTackePhotoBackgV.frame.height/2
        mOpenContentV.setBorder(color: color_navigationBar!, width: 1.0)
        mPhotoImgV.layer.cornerRadius = 3
          
    }
    
    override func prepareForReuse() {
        mTackePhotoBackgV.setBorder(color: color_navigationBar!, width: 1.0)
        mOpenContentV.setBorder(color: color_navigationBar!, width: 1.0)

        mTackePhotoBackgV.backgroundColor = .clear
        mPhotoImgV.image = nil
        mPhotoImgV.isHidden = true
        mTakePhotoLb.textColor = color_alert_txt!
        mOpenLb.textColor = color_alert_txt!
        self.isUserInteractionEnabled = true

    }
    
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel, index: Int) {
        
        mTakePhotoBtn.tag = index
        mOpenBtn.tag = index
        
        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
            mTakePhotoLb.textColor = .white
            mCameraImgV.image = UIImage(named: "camera_white")
            mAgreeImgV.setTintColor(color: color_alert_txt!)
            
            if item.viewDescription != "openDoc" {
                    self.mPhotoImgV.isHidden = false
                if item.userRegisterInfo?.imageURL != nil {
                    self.mPhotoImgV.image = UIImage()
                    self.mPhotoImgV.sd_setImage(with: item.userRegisterInfo?.imageURL, placeholderImage: nil)
                } else {
                    self.mPhotoImgV.image = (item.userRegisterInfo?.photo)!
                }
                isOpenDoc = false
            } else {
                isOpenDoc = true
            }
            fieldFilled()
            
        } else {
            mCameraImgV.image = UIImage(named: "camera")

            if item.viewDescription == "openDoc" {
                isOpenDoc = true
                mOpenContentV.isHidden = false
                mStackV.isHidden = true
            }
        }
    }
    
    
    private func fieldFilled() {
        
        mOpenContentV.isHidden = !isOpenDoc
        mStackV.isHidden = isOpenDoc
        
        if isOpenDoc {
            mOpenLb.textColor = .white
            mAgreeImgV.setTintColor(color: .white)
            mOpenContentV.layer.borderWidth = 0.0
            mOpenContentV.backgroundColor = color_navigationBar! // color_dark_register!
        } else {
            mTakePhotoLb.textColor = .white
            mCameraImgV.image = UIImage(named: "camera_white")
            mTackePhotoBackgV.layer.borderWidth = 0.0
            mTackePhotoBackgV.backgroundColor = color_navigationBar!
        }
    }
    

    @IBAction func takePhoto(_ sender: UIButton) {
        delegate?.didPressTackePhoto(isOpenDoc: false, index: sender.tag)
    }
    
    @IBAction func open(_ sender: UIButton) {
        delegate?.didPressTackePhoto(isOpenDoc: true, index: sender.tag)
    }
}



