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
        mCodeTxtFl.configure()
//        mCodeTxtFl.didEnterLastDigit = { [weak self] code in
//            print(code)
//            self?.addChild(self!.emailVerificationVC)
//            self?.emailVerificationVC.view.frame = (self?.view.bounds)!
//            self?.view.addSubview(self!.emailVerificationVC.view)
//            self?.emailVerificationVC.didMove(toParent: self)
//        }
    }
    
    /// Send verification code
    func sendVerification(){
        VerificationCodeViewModel().putVerification(username: email, code: mCodeTxtFl.text!) { (status) in
            
            //            showAlert()

        }
    }
    
    
    func resendVerification(){
        VerificationCodeViewModel().resendVerificationCode(username: email) { (status) in
            self.startTimer()
            //            showAlert()

        }
    }
    
    /// start timer
    private func startTimer(){
        mReserndCodeBtn.isUserInteractionEnabled = false
        counter = 59
        let seconds = 1.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    /// stop timer
    func stopTimer() {
        timer.invalidate()
        mReserndCodeBtn.isUserInteractionEnabled = true
        mTimerLb.textColor = color_navigationBar
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
        self.mAlertV.isHidden = false
        self.mAlertV.popupAnimation()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendCode(_ sender: UIButton) {
    }
    
    @IBAction func verify(_ sender: UIButton) {
        if mCodeTxtFl.text?.count == 6 {
            mAlertContentV.isHidden = false
            mCodeTxtFl.resignFirstResponder()
            sendVerification()
//            addChild(emailVerificationVC)
//            emailVerificationVC.view.frame = view.bounds
//            view.addSubview(emailVerificationVC.view)
//            emailVerificationVC.didMove(toParent: self)
        }
        
    }
    @IBAction func thankYou(_ sender: UIButton) {
        let FaceAndTouchIdVC = FaceAndTouchIdViewController.initFromStoryboard(name: Constant.Storyboards.registration)
        self.navigationController?.pushViewController(FaceAndTouchIdVC, animated: true)
    }
}


