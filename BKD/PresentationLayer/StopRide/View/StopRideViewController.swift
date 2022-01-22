//
//  StopRideViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-12-21.
//

import UIKit

class StopRideViewController: BaseViewController {

    @IBOutlet weak var mScrollV: UIScrollView!
    //info
    @IBOutlet weak var mStepOneLb: UILabel!
        @IBOutlet weak var mVehicleCheckLb: UILabel!
    @IBOutlet weak var mInfo1Lb: UILabel!
    @IBOutlet weak var minfo2Lb: UILabel!
    //Vehicle photo
    @IBOutlet weak var mVehiclePhotoTbV: StopRideVehicleImageTableView!
    @IBOutlet weak var mVehiclePhotoTbVHeight: NSLayoutConstraint!
    //Take photo
    @IBOutlet weak var mTakePhotoContentV: UIView!
    @IBOutlet weak var mCameraImgV: UIImageView!
    
    //No new damages
    @IBOutlet weak var mNoDamageLb: UILabel!
    @IBOutlet weak var mNoDamageCkeckBtn: UIButton!
    @IBOutlet weak var mNoDamageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var mAdditionalInfo: UILabel!
    @IBOutlet weak var mConfirmV: ConfirmView!
    @IBOutlet weak var mRightbarBtn: UIBarButtonItem!
    
    public var currRentModel: Rent?
    
    lazy var stopRideViewModel = StopRideViewModel()
    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mVehiclePhotoTbVHeight.constant = mVehiclePhotoTbV.contentSize.height
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mConfirmV.mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mTakePhotoContentV.setBorder(color: color_navigationBar!, width: 2.0)
    }
    
    func setupView() {
        mConfirmV.needsCheck = true
        handlerContinue()
    }
    
    ///Configure UI
    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        mRightbarBtn.image = img_bkd
        mNoDamageCkeckBtn.setImage(img_uncheck_box, for: .normal)
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mTakePhotoContentV.layer.cornerRadius = mTakePhotoContentV.frame.height / 2
        mTakePhotoContentV.setBorder(color: color_navigationBar!, width: 2.0)
        mCameraImgV.setTintColor(color: color_alert_txt!)
        mInfo1Lb.setAttributeBold(text: Constant.Texts.stopRideInfo, boldText: Constant.Texts.stopRideInfoBold, color: color_navigationBar!)
        
        if currRentModel?.endDefects.count ?? 0 > 0 {
            mVehiclePhotoTbV.defects = currRentModel?.endDefects ?? []
        }
        
//        mVehiclePhotoTbV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel!)
//        0.reloadData()
    }
    
    ///Add defect to finish
    func addDefectToFinish(image: UIImage) {
        stopRideViewModel.addDefectToFinish(image: image, id: currRentModel?.id ?? "") { result, err in
            guard let rent = result else {return}
            if rent.endDefects.count > 0 {
                self.mVehiclePhotoTbV.defects = rent.endDefects
                self.mVehiclePhotoTbV.reloadData()
                self.mVehiclePhotoTbVHeight.constant = CGFloat(300 * self.mVehiclePhotoTbV.defects.count)
                self.mNoDamageBottom.constant = 205
            }
                    
            print(rent)
        }
    }
    
    ///Check defect to finish
    func checkDefectToFinish() {
        stopRideViewModel.defectCheckToFinish(id: currRentModel?.id ?? "") { result, err in
            guard let rent = result else {
                self.mConfirmV.initConfirm()
                return}
            if RentState.init(rawValue: rent.state ?? "") == .END_DEFECT_CHECK {
                self.goToStopRideOdometereCheck(rent: rent)
            } else {
                self.mConfirmV.initConfirm()
            }
        }
    }
    
    ///Open camera
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmNoNewDamage(_ sender: UIButton) {
        if sender.image(for: .normal) == img_uncheck_box || sender.image(for: .normal) == img_err_uncheck_box  {
            sender.setImage(img_check_box, for: .normal)
            mNoDamageLb.textColor = color_navigationBar!
            self.mNoDamageCkeckBtn.tintColor = color_navigationBar!
            mConfirmV.needsCheck = false
        } else {
            self.mConfirmV.needsCheck = true
            sender.setImage(img_uncheck_box, for: .normal)
        }
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        openCamera()
    }
    
    ///handler Continue button
    private func handlerContinue() {
        mConfirmV.didPressConfirm = {
            self.checkDefectToFinish()
        }
        
        mConfirmV.willCheckConfirm = {
            let isChecked = (self.mNoDamageCkeckBtn.image(for: .normal) == img_check_box)
            if !isChecked {
                self.mNoDamageCkeckBtn.setImage( img_err_uncheck_box, for: .normal)
                self.mNoDamageLb.textColor =  color_error
                self.mNoDamageCkeckBtn.tintColor = color_error
            }
            self.mConfirmV.needsCheck = !isChecked
            
        }
    }

}


//MARK: - UIImagePickerControllerDelegate
//MARK: --------------------------------
extension StopRideViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        addDefectToFinish(image: image)
    }
}
