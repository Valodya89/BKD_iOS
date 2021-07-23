//
//  PhoneVerificationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

import UIKit

class PhoneVerificationViewController: UIViewController, StoryboardInitializable {
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
    
    
    //MARK: Variables
    lazy var verificationCodeViewModel =         VerificationCodeViewModel()
    var email:String = ""
    private var timer = Timer()
    private var counter = 59
    
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configtextFiledUI()
    }
    
    func setUpView() {
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
        //WARNING:
        self.goToReservationCompleted()

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
        VerificationCodeViewModel().resendVerificationCode(username: email) { (status) in
            self.startTimer()

        }
    }
    
    /// start timer
    private func startTimer(){
        mTimerTitleLb.textColor = color_navigationBar
        mTimerTitleLb.text = Constant.Texts.reciveEmail
        mResendCodeBtn.disable()
        mTimerLb.isHidden = false

        counter = 59
        let seconds = 1.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    /// stop timer
    func stopTimer() {
        timer.invalidate()
        mVerifyBtn.disable()
        mResendCodeBtn.enable()
        mTimerLb.textColor = color_navigationBar
        mButtonsStackV.isHidden = false
        mVerifySecondBtn.isHidden = true
        mCodeTxtFl.configure()
        
    }
    
    ///Open Reservation completed screen
    private func goToReservationCompleted() {
        let reservationCompletedVC = ReservationCompletedViewController.initFromStoryboard(name: Constant.Storyboards.reservationCompleted)
        self.navigationController?.pushViewController(reservationCompletedVC, animated: true)
        
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

