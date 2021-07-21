//
//  VerificationCodeViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-07-21.
//

import UIKit

class VerificationCodeViewController: UIViewController, StoryboardInitializable {

   //MARK: Outlets
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
//    @IBOutlet weak var mCodeTxtFl: OneTimeCodeTextFiled!
    @IBOutlet weak var mCodeTxtFl: OneTimeCodeTextField!
    @IBOutlet weak var mReserndCodeBtn: UIButton!
    @IBOutlet weak var mVerifyBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    
    @IBOutlet weak var mTimerContentV: UIView!
    @IBOutlet weak var mTimerLb: UILabel!
    @IBOutlet weak var mAlertContentV: UIView!
    @IBOutlet weak var mTimerTitleLb: UILabel!
    @IBOutlet weak var mAlertV: UIView!
    
    @IBOutlet weak var mThankBtn: UIButton!
    //MARK: Variables
    lazy var verificationCodeViewModel =         VerificationCodeViewModel()
    var email:String = ""
    private var timer = Timer()
    private var counter = 59
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configtextFiledUI()
        setUpView()
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        mReserndCodeBtn.layer.cornerRadius = 8
        mVerifyBtn.layer.cornerRadius = 8
        mAlertV.layer.cornerRadius = 8
        mAlertContentV.backgroundColor = color_background?.withAlphaComponent(0.5)
        startTimer()
    }

    func configtextFiledUI() {
        mCodeTxtFl.setBorder(color: color_navigationBar!, width: 1)
        mCodeTxtFl.defaultCharacter = "-"
        mCodeTxtFl.configure(with: 5)
    }
    
    /// Send verification code
    func sendVerification(){
        VerificationCodeViewModel().putVerification(username: email, code: mCodeTxtFl.text!) { [self] (status) in
            
            switch status {
            case .success:
                self.showAlert()
            case .error:
                showError()
            default: break
            }
        }
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
        mReserndCodeBtn.disable()
        mTimerLb.isHidden = false

        counter = 59
        let seconds = 1.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    /// stop timer
    func stopTimer() {
        timer.invalidate()
        mVerifyBtn.disable()
        mReserndCodeBtn.enable()
        mTimerLb.textColor = color_navigationBar
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
    
    func showAlert() {
        mAlertContentV.isHidden = false
        self.mAlertV.isHidden = false
        self.mAlertV.popupAnimation()
    }
    
    
    func showError() {
        //failedRequest
        mTimerTitleLb.text = Constant.Texts.failedRequest
        mTimerTitleLb.textColor = color_error
        mTimerLb.isHidden = true
        mCodeTxtFl.text = ""
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
    
    @IBAction func thankYou(_ sender: UIButton) {
        let FaceAndTouchIdVC = FaceAndTouchIdViewController.initFromStoryboard(name: Constant.Storyboards.registration)
        self.navigationController?.pushViewController(FaceAndTouchIdVC, animated: true)
    }
}


