//
//  PhoneVerificationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

import UIKit

class PhoneVerificationViewController: BaseViewController {
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mCodeTxtFl: OneTimeCodeTextField!
    @IBOutlet weak var mTimerTitleLb: UILabel!
    
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mVerifySecondBtn: UIButton!
    @IBOutlet weak var mVerifyBtn: UIButton!
    @IBOutlet weak var mTimerContentV: UIView!
    @IBOutlet weak var mResendCodeBtn: UIButton!
    @IBOutlet weak var mButtonsStackV: UIStackView!
    @IBOutlet weak var mTimerLb: UILabel!
    @IBOutlet weak var mInfoLb: UILabel!
    
    //MARK: Variables
    lazy var phoneVerificationViewModel = PhoneVerificationViewModel()
    var phone:String = ""
    private weak var timer:Timer?
    private var counter = 59
    
    public var phoneNumber: String?
    public var phoneCode: String?
    public var vehicleModel: VehicleModel?

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configtextFiledUI()
    }
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mInfoLb.text = String(format: Constant.Texts.phoneVerificationInfo, phoneCode ?? "", phoneNumber ?? "")
        mVerifySecondBtn.disable()
        startTimer()
    }

    func configtextFiledUI() {
        mRightBarBtn.image = img_bkd
        mResendCodeBtn.layer.cornerRadius = 8
        mVerifyBtn.layer.cornerRadius = 8
        mVerifySecondBtn.roundCornersWithBorder(corners: .allCorners, radius: 8.0, borderColor: color_menu!, borderWidth: 1)
        mCodeTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mCodeTxtFl.defaultCharacter = "-"
        mCodeTxtFl.configure(with: 5)
    }
    
    /// Send verification code
    func sendVerification(){
        phoneVerificationViewModel.verifyPhoneNumber(phoneCode: phoneCode ?? "", number: phoneNumber ?? "", code: mCodeTxtFl.text ?? "") { [weak self] (result, err) in
            if result != nil {
                self?.goToReservationCompleted(vehicleModel: self?.vehicleModel)
            } else {
                self?.showError()
            } 
        }
        
        // self.goToReservationCompleted()

//        VerificationCodeViewModel().putVerification(username: email, code: mCodeTxtFl.text!) { [self] (status) in
//
//            switch status {
//            case .success:
//                self.goToReservationCompleted()
//            case .error:
//                showError()
//            default: break
//            }
//        }
    }
    
    /// Send verification again
    func resendVerification(){
        mCodeTxtFl.defaultCharacter = "-"
       // mCodeTxtFl.text = "_"

        ChangePhoneNumberViewModel().sendCodeSms(phoneCode: phoneCode ?? "", phoneNumber: phoneNumber ?? "") { response, err in
            self.startTimer()
        }
    }
    
    /// start timer
    private func startTimer(){
        
        mTimerLb.textColor = color_navigationBar
        mTimerTitleLb.textColor = color_navigationBar
        mTimerTitleLb.text = Constant.Texts.reciveSms
        mResendCodeBtn.disable()
        mTimerLb.isHidden = false

        counter = 59
        let seconds = 1.0
        if let _ = timer {
            timer?.fire()
        } else {
            timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    /// stop timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        mVerifyBtn.disable()
        mResendCodeBtn.enable()
        mButtonsStackV.isHidden = false
        mVerifySecondBtn.isHidden = true
        mCodeTxtFl.configure()
        
    }
    
   

    /// timer selector function
    @objc private func updateCounter() {
        if counter > 0 {
            counter -= 1
            if counter < 10 {
                mTimerLb.textColor = color_error
                mTimerLb.text = "0:0\(counter)"
            } else {
                mTimerLb.text = "0:\(counter)"
            }
        } else {
            if counter == 0 {
                stopTimer()
            }
        }
    }
    
    
    @IBAction func changeTextFiled(_ sender: OneTimeCodeTextField) {
        if mCodeTxtFl.text?.count == 5 {
            mVerifySecondBtn.enable()
            mVerifyBtn.enable()
        } else {
            mVerifyBtn.disable()
            mVerifySecondBtn.disable()

        }
    }
    
    func showError() {
        //failedRequest
        mErrorLb.isHidden = false
        mTimerTitleLb.text = Constant.Texts.failedRequest
        mCodeTxtFl.layer.borderColor = color_error!.cgColor
        mTimerContentV.isHidden = true
        mCodeTxtFl.text = ""
        mButtonsStackV.isHidden = false
        mVerifySecondBtn.isHidden = true
        self.stopTimer()
    }
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resendCode(_ sender: UIButton) {
        startTimer()
        self.mVerifyBtn.enable()
        resendVerification()
    }
    
    @IBAction func verify(_ sender: UIButton) {
        
        if mCodeTxtFl.text?.count == 5 {
            mCodeTxtFl.resignFirstResponder()
            sendVerification()
        }
    }
    
   
}

