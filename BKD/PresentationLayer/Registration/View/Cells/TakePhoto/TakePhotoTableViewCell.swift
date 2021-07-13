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
        mTackePhotoBackgV.roundCornersWithBorder(corners: [.allCorners], radius: 36.0, borderColor: color_navigationBar!, borderWidth: 1)
        mOpenContentV.roundCornersWithBorder(corners: [.allCorners], radius: 36.0, borderColor: color_navigationBar!, borderWidth: 1)
        mPhotoImgV.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        mTackePhotoBackgV.backgroundColor = .clear
        mPhotoImgV.image = nil
        mPhotoImgV.isHidden = true
        mTakePhotoLb.textColor = color_navigationBar!
        mCameraImgV.setTintColor(color: color_navigationBar!)
        self.isUserInteractionEnabled = true
    }
    
    
    /// Set cell info
    func  setCellInfo(item: RegistrationBotModel) {
        if ((item.userRegisterInfo?.isFilled) != nil) && item.userRegisterInfo?.isFilled == true {
            if item.viewDescription != "openDoc" {
                    self.mPhotoImgV.isHidden = false
                    self.mPhotoImgV.image = (item.userRegisterInfo?.photo)!
                isOpenDoc = false
            } else {
                isOpenDoc = true
            }
            fieldFilled()
            
        } else {
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
        self.isUserInteractionEnabled = false
        if isOpenDoc {
            docDidAgree()
        } else {
            mTakePhotoLb.textColor = .white
            mCameraImgV.setTintColor(color: .white)
            mTackePhotoBackgV.removeCAShapeLayer()
            mTackePhotoBackgV.roundCornersWithBorder(corners: [ .allCorners], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
            mTackePhotoBackgV.backgroundColor = color_dark_register!
            mTackePhotoBackgV.layer.cornerRadius = 10
            mTackePhotoBackgV.layer.borderColor = color_dark_register!.cgColor
        }
        
    }
    
    
    private func docDidAgree() {
        mOpenLb.textColor = .white
        mAgreeImgV.setTintColor(color: .white)
        mOpenContentV.backgroundColor = color_dark_register!
        mOpenContentV.layer.borderColor = color_dark_register!.cgColor
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        delegate?.didPressTackePhoto(isOpenDoc: false)
        
    }
    
    @IBAction func open(_ sender: UIButton) {
        delegate?.didPressTackePhoto(isOpenDoc: true)
    }
}
