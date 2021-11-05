//
//  FaceAndTouchIdViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit
import LocalAuthentication

class FaceAndTouchIdViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlet
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mAgreeBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mRightBarBtn.image = img_bkd
        signIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    
    func setUpView() {
        mAgreeBtn.backgroundColor = .clear
        mCancelBtn.backgroundColor = .clear
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1)
        mAgreeBtn.layer.cornerRadius = 8
        mAgreeBtn.setBorder(color: color_menu!, width: 1)
    }
    
    ///Sigin user for get token
    func signIn()  {
        let keychainManager = KeychainManager()
        SignInViewModel().signIn(username: keychainManager.getUsername() ?? "", password: keychainManager.getPasswor() ?? "") { [weak self] (status) in
            guard let self = self else { return }
            switch status {
            case .success:
                break
            default:
                self.showAlertMessage(Constant.Texts.errToken)
                break
            }
        }
    }
    
    ///Go to registartion bot screen
    private func goToRegistartaionBot(){
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = [RegistrationBotData.registrationBotModel[0]]
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
   
    ///Open Face Id/ Touch id 
    private func clickAgree() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = Constant.Texts.touchIdNotice
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    
                    guard  success, error == nil else {
                        //failed
                        BKDAlert.init().showAlertOk(on: self, message: Constant.Texts.touchIdFailed, okTitle: Constant.Texts.ok) {
                        }
                        return
                    }
                    // success
                    self.goToRegistartaionBot()
                }
            }
        } else { // cant´t open
            BKDAlert.init().showAlertOk(on: self, message: Constant.Texts.touchIdError, okTitle: Constant.Texts.ok, okAction: nil)
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constant.Texts.ok, style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: ACTIONS
    @IBAction func cancel(_ sender: UIButton) {
        
        self.goToRegistartaionBot()
    }
    
    @IBAction func agree(_ sender: UIButton) {
        
        sender.setClickColor(color_menu!, titleColor: sender.titleColor(for: .normal)! )
        
        clickAgree()    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        navigationController?.popToViewController(ofClass: RegistrationViewController.self)
        
    }
}
