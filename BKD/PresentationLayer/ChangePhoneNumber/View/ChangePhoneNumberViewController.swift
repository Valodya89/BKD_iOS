//
//  ChangePhoneNumberViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit
import SwiftMaskTextfield
import PhoneNumberKit

let test_phoneNumber = "155 234 60"
class ChangePhoneNumberViewController: UIViewController, StoryboardInitializable {
    
    //MARK: - Outlets
    @IBOutlet weak var mInfoLb: UILabel!
    @IBOutlet weak var mSendBtn: UIButton!
    @IBOutlet weak var mChangeNumberBtn: UIButton!
    @IBOutlet weak var mNumberTxtFl: SwiftMaskTextfield!
    @IBOutlet weak var mCodeLb: UILabel!
    @IBOutlet weak var mSearchCountryBtn: UIButton!
    @IBOutlet weak var mFlagImgV: UIImageView!
        @IBOutlet weak var mDropDownImgV: UIImageView!
    @IBOutlet weak var mPhoneNumberContentV: UIView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    var phoneNumber:String? {
        didSet {
            if let _ = phoneNumber {
                mSendBtn.enable()
                mChangeNumberBtn.disable()
                setToPhoneNumberActiveColor(color_email!)
            } else {
                mSendBtn.disable()
                mChangeNumberBtn.enable()
                setToPhoneNumberActiveColor(color_navigationBar!)
            }
                
        }
    }
    
    var selectedCountry: PhoneCodeModel?
    let phoneNumberKit = PhoneNumberKit()
    
//    var phoneNumber: String? {
//        get {
//            return "\(selectedCountry?.code ?? "NULL") \(mNumberTxtFl.text ?? "NULL")".replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
//        } set {
//            guard let newValue = newValue else {
//                return
//            }
//            guard !newValue.isEmpty else {
//                mNumberTxtFl.text = ""
//                return
//            }
//
//            guard let phoneNumber = try? phoneNumberKit.parse(newValue, ignoreType: true) else { return }
//            
//            mCodeLb.text = "+" + String(phoneNumber.countryCode)
//            mNumberTxtFl.text = String(phoneNumber.nationalNumber)
//        }
//    }
    
    var isValid: Bool {
        return mNumberTxtFl.text?.count == selectedCountry?.validFormPattern
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber = test_phoneNumber
        setUpView()
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        mSendBtn.layer.cornerRadius = 8
        mChangeNumberBtn.layer.cornerRadius = 8
        mPhoneNumberContentV.setBorder(color: color_email!, width: 1)
        mDropDownImgV.setTintColor(color: color_email!)
        mChangeNumberBtn.disable()
        mNumberTxtFl.text = test_phoneNumber
    }
    
    private func setToPhoneNumberActiveColor(_ color: UIColor) {
        mDropDownImgV.setTintColor(color: color)
        mCodeLb.textColor = color
        mPhoneNumberContentV.layer.borderColor = color.cgColor
        mNumberTxtFl.textColor = color
    }
    
    ///Open search phoneCode screen
    private func goToSearchPhoneCode() {
        let searchPhoneCodeVC = SearchPhoneCodeViewController.initFromStoryboard(name: Constant.Storyboards.searchPhoneCode)
        searchPhoneCodeVC.delegate = self
        self.present(searchPhoneCodeVC, animated: true, completion: nil)
    }

    ///Open phone verification screen
    private func goToPhoneVerification() {
        let phoneVerification = PhoneVerificationViewController.initFromStoryboard(name: Constant.Storyboards.phoneVerification)
        self.navigationController?.pushViewController(phoneVerification, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        //WARNING:
        goToPhoneVerification()
        
    }
    
    @IBAction func changeNumber(_ sender: UIButton) {
        
    }
    
    @IBAction func searchCountry(_ sender: UIButton) {
        goToSearchPhoneCode()
    }
}



//MARK: - SearchPhoneCodeViewControllerDelegate
//MARK: --------------------------------------
extension ChangePhoneNumberViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCodeModel) {
        mFlagImgV.image = country.flag
        mCodeLb.text = country.code
    }
    
}
