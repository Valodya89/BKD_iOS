//
//  OdometerCheckViewController.swift
//  OdometerCheckViewController
//
//  Created by Karine Karapetyan on 16-09-21.
//

import UIKit

enum OdometerState {
    case inputManually
    case confirmLastCheck
    case none
}

class OdometerCheckViewController: UIViewController, StoryboardInitializable {

    //MARK: -- Outlets
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mStep2Lb: UILabel!
    @IBOutlet weak var mOdometCheckLb: UILabel!
    @IBOutlet weak var mKmLb: UILabel!
    @IBOutlet weak var mKmPriceLb: UILabel!
    @IBOutlet weak var mDescriptionLb: UILabel!
    @IBOutlet weak var mVehicleLastOdometeTitleLb: UILabel!
    @IBOutlet weak var mLastOdometeNumberLb: UILabel!
    @IBOutlet weak var mConfirmLastOdometRadioBtn: UIButton!
    @IBOutlet weak var mConfirmLastOdometeLb: UILabel!
    @IBOutlet weak var mInputManuallyRadioBtn: UIButton!
    @IBOutlet weak var mInputeManuallyLb: UILabel!
    @IBOutlet weak var mOdomateNumberTxtFl: UITextField!
    
    ///Open camera
    @IBOutlet weak var mManualContentV: UIView!
    @IBOutlet weak var mManualContentVHeight: NSLayoutConstraint!
    @IBOutlet weak var mOpenCameraContentV: UIView!
    @IBOutlet weak var mOpenCameraBtn: UIButton!
    @IBOutlet weak var mOdomateImgV: UIImageView!
    @IBOutlet weak var mOdometerImgHeight: NSLayoutConstraint!
    
    ///Start now
   
    @IBOutlet weak var mStartNowV: ConfirmView!
    @IBOutlet weak var mStartNowTop: NSLayoutConstraint!
    @IBOutlet weak var mStartNowHeight: NSLayoutConstraint!
    
    ///Navigation bar
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    
    //MARK: -- Variables
    public var currRent: Rent?
    
    private var rentCar: CarsModel?
    var odometerState: OdometerState = .none
    lazy var odometerCheckVM = OdomoeterCheckViewModel()
    
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureUI()

    }
  
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mStartNowHeight.constant = height42
    }
    
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        mOpenCameraBtn.layer.cornerRadius = view.bounds.height * 0.0235149
        mOpenCameraBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mOdomateNumberTxtFl.setBorder(color: color_navigationBar!, width: 1.0)
        mInputManuallyRadioBtn.setTitle("", for: .normal)
        mConfirmLastOdometRadioBtn.setTitle("", for: .normal)
        mOdomateImgV.layer.cornerRadius = 3
        mOdomateNumberTxtFl.setPlaceholder(string: Constant.Texts.odometerNumber, font: font_search_cell!, color: color_chat_placeholder!)
        mOdomateNumberTxtFl.delegate = self
        handlerStartNoew()
    }

    ///Configure UI
    func configureUI() {
        
        mKmPriceLb.text = odometerCheckVM.getPriceForKm(currRent: currRent)
        guard let odometer = currRent?.startOdometer else {return}
        mLastOdometeNumberLb.text = odometer.value
        if RentState.init(rawValue: currRent?.state ?? "") == .START_ODOMETER_CHECK {
            self.startRideAlert()
        }
    }
    
    
    ///Add Odometer
    func addOdometer() {
        odometerCheckVM.addOdometer(image: mOdomateImgV.image ?? UIImage(),
                                           id: currRent?.id ?? "",
                                           value: mOdomateNumberTxtFl.text!) { result, err in
            guard let rent = result else {return}
            self.checkOdometer()
            print (rent)
        }
    }
    
    ///Check odometer
    func checkOdometer() {
        odometerCheckVM.checkOdometer(id: currRent?.id ?? "") { result, err in
            guard let rent = result else {return}
            if RentState.init(rawValue: rent.state ?? "") == .START_ODOMETER_CHECK {
                self.startRideAlert()
            }
        }
    }
    
    ///Start ride
    func startRide() {
        odometerCheckVM.startRide(id: currRent?.id ?? "") { result, err in
            guard let rent = result else {return}
            if RentState.init(rawValue: rent.state ?? "") == .STARTED {
                self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
            }
        }
    }
    
    ///Enable StartNow button
    private func enableStartNow() {
        if odometerState == .confirmLastCheck || (odometerState == .inputManually && (mOdomateNumberTxtFl.text?.count ?? 0) > 0 && mOdomateImgV.image != nil) {
            mStartNowV.enableView()
        } else {
            mStartNowV.disableView()
        }
    }
    
    ///Enable open camera button
    private func enableOpenCamera() {
        mOpenCameraContentV.isUserInteractionEnabled = (mOdomateNumberTxtFl.text?.count ?? 0) > 0
        mOpenCameraContentV.alpha = ((mOdomateNumberTxtFl.text?.count ?? 0) > 0) ? 1.0 : 0.75

    }
    
    /// show odometer views for fill manually
    private func updateManuallyOdometerView(isShow: Bool) {
        mManualContentV.isHidden = !isShow
        UIView.animate(withDuration: 0.5) {
            if isShow {
                self.mManualContentVHeight.constant = 0
            } else {
                self.mManualContentVHeight.constant = -120
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateOdometerImage(isShow: Bool) {
        
        mOdomateImgV.isHidden = !isShow
        if isShow {
            mOdometerImgHeight.constant = 0
        } else {
            mOdometerImgHeight.constant = -120
        }
        view.setNeedsLayout()

    }
    
    ///Open camera
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    /// Call Alert For confirm start ride
    private func startRideAlert() {
        BKDAlert().showAlert(on: self, title: nil, message: Constant.Texts.startRideAlert, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.startNow) {
            self.mStartNowV.initConfirm()
            self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)

        } okAction: {
            self.startRide()
        }
    }
    
    
    //MARK: -- Actions
    @IBAction func confirmLastOdometer(_ sender: UIButton) {
        mInputManuallyRadioBtn.setImage(img_unselect_RadioBtn, for: .normal)
        if odometerState == .confirmLastCheck {
            sender.setImage(img_unselect_RadioBtn, for: .normal)
            odometerState = .none
        } else {
            sender.setImage(img_select_RadioBtn, for: .normal)
            odometerState = .confirmLastCheck
            updateManuallyOdometerView(isShow: false)
            updateOdometerImage(isShow: false)
            mOdomateNumberTxtFl.text = nil
            mOdomateImgV.image = nil
            enableOpenCamera()
        }
        enableStartNow()
    }
    
    
    
    @IBAction func inputManually(_ sender: UIButton) {
        mConfirmLastOdometRadioBtn.setImage(img_unselect_RadioBtn, for: .normal)
        if odometerState == .inputManually {
            sender.setImage(img_unselect_RadioBtn, for: .normal)
            odometerState = .none
            updateManuallyOdometerView(isShow: false)

        } else {
            sender.setImage(img_select_RadioBtn, for: .normal)
            odometerState = .inputManually
            updateManuallyOdometerView(isShow: true)
        }
        enableStartNow()
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func handlerStartNoew() {
        mStartNowV.didPressConfirm = {
            if self.odometerState == .inputManually {
                self.addOdometer()
            } else {
                self.checkOdometer()
            }
            
        }
    }
}



//MARK: -- UIImagePickerControllerDelegate
extension OdometerCheckViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        mOdomateImgV.image = image
        updateOdometerImage(isShow: true)
        enableStartNow()
       
    }
}


//MARK: -- UITextFieldDelegate
extension OdometerCheckViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enableOpenCamera()
        enableStartNow()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}
