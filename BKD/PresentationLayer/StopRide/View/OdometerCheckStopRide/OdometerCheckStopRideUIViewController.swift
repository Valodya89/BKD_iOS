//
//  OdometerCheckStopRideUIViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-12-21.
//

import UIKit

class OdometerCheckStopRideUIViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mStepTwoLb: UILabel!
    @IBOutlet weak var mOdometerCheckLb: UILabel!
    @IBOutlet weak var mOneKmLb: UILabel!
    @IBOutlet weak var mKmPriceLb: UILabel!
     
    @IBOutlet weak var mInfo1Lb: UILabel!
    @IBOutlet weak var mInfo2: UILabel!
    @IBOutlet weak var mOdometerTxtFl: TextField!
    //Take phote
    @IBOutlet weak var mTakePhotoCotentV: UIView!
    @IBOutlet weak var mCameraButtonLb: UILabel!
    @IBOutlet weak var mCameraImgV: UIImageView!
    @IBOutlet weak var mTakePhotBtn: UIButton!
    @IBOutlet weak var mOdometerImgV: UIImageView!
    @IBOutlet weak var mAdditionalInfoLb: UILabel!
    @IBOutlet weak var mFinishRideBtn: UIButton!
    @IBOutlet weak var mRightBarbtn: UIBarButtonItem!
    
    public var currRentModel: Rent?
    
    lazy var stopRideViewModel = StopRideViewModel()
    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mFinishRideBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
        configureOdometerInfo()

    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       configureUI()
    }
    
    func setupView() {}
    
    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        mRightBarbtn.image = img_bkd
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mTakePhotoCotentV.layer.cornerRadius = view.bounds.height * 0.0235149
        mTakePhotoCotentV.setBorder(color: color_navigationBar!, width: 2.0)
        mCameraImgV.setTintColor(color: color_alert_txt!)
        mOdometerTxtFl.setBorder(color: color_navigationBar!, width: 2.0)
        mTakePhotoCotentV.disableView()
        mFinishRideBtn.disable()
    }
    
    func configureOdometerInfo() {
       let rentCar = ApplicationSettings.shared.allCars?.filter( {$0.id == currRentModel?.carDetails.id}).first
        mKmPriceLb.text = String(format: "%.2f", rentCar?.priceForKm ?? 0.0)
        
        if (RentState.init(rawValue: currRentModel?.state ?? "") == .END_DEFECT_CHECK || RentState.init(rawValue: currRentModel?.state ?? "") == .END_ODOMETER_CHECK) && currRentModel?.endOdometer != nil {
            mOdometerTxtFl.text = currRentModel?.endOdometer?.value
            mOdometerImgV.isHidden = false
            mTakePhotoCotentV.isHidden = true
            mFinishRideBtn.enable()
            if let img =  currRentModel?.endOdometer?.image {
                mOdometerImgV.sd_setImage(with:  img.getURL() ?? URL(string: ""), placeholderImage: nil)
            }
            
            if RentState.init(rawValue: currRentModel?.state ?? "") == .END_ODOMETER_CHECK {
                finishRideAlert()
            }
        }
    }
    
    ///Add Odometer
    func addOdometer(image: UIImage) {
        stopRideViewModel.addOdometerToFinish(image: image,
                                           id: currRentModel?.id ?? "",
                                              description: mOdometerTxtFl.text!) { result, err in
            guard let _ = result else {return}
            self.mTakePhotoCotentV.isHidden = true
            self.mOdometerImgV.isHidden = false
            self.mOdometerImgV.image = image
            self.enableFinishRide()
        }
    }
    
    ///Check odometer
    func checkOdometer() {
        stopRideViewModel.checkOdometerToFinish(id: currRentModel?.id ?? "") { result, err in
            guard let rent = result else {return}
            if RentState.init(rawValue: rent.state ?? "") == .END_ODOMETER_CHECK {
                self.finishRideAlert()

            }
        }
    }
    
    ///Finish ride
    func finishRide() {
        stopRideViewModel.finishRide(id: currRentModel?.id ?? "") { result, err in
            guard let rent = result else {return}
            if RentState.init(rawValue: rent.state ?? "") == .FINISHED {
                self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
            }
        }
    }
    
    /// Call Alert to finish ride
    private func finishRideAlert() {
        BKDAlert().showAlert(on: self, title: nil, message: Constant.Texts.finishRide_alert, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.finishRide) {
            self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
        } okAction: {
            self.finishRide()
        }
    }
    
    ///Open camera
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    ///Enable finish ride button
    private func enableFinishRide() {
        if (mOdometerTxtFl.text?.count ?? 0) > 0 && mOdometerImgV.image != nil {
            mFinishRideBtn.enableView()
        } else {
            mFinishRideBtn.disableView()
        }
    }

    ///Enable open camera button
    private func enableOdometerPhoto(txt: String?) {
        mTakePhotoCotentV.isUserInteractionEnabled = (txt?.count ?? 0) > 0
        mTakePhotoCotentV.alpha = ((txt?.count ?? 0) > 0) ? 1.0 : 0.75
    }
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction func finishRide(_ sender: UIButton) {
        checkOdometer()
    }
}


//MARK: - UIImagePickerControllerDelegate
//MARK: --------------------------------
extension OdometerCheckStopRideUIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        addOdometer(image: image)
    }
}

//MARK: -- UITextFieldDelegate
extension OdometerCheckStopRideUIViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        let updatingString = text.replacingCharacters(in: textRange, with: string)
        enableOdometerPhoto(txt: updatingString)
        return true
    }
    

}
