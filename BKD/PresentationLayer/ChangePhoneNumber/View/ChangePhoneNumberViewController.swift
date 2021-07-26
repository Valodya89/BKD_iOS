//
//  ChangePhoneNumberViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit
import SwiftMaskTextfield
import PhoneNumberKit

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
                mChangeNumberBtn.enable()
                setToPhoneNumberActiveColor(color_email!)
            } else {
                mSendBtn.disable()
                mChangeNumberBtn.disable()
                setToPhoneNumberActiveColor(color_navigationBar!)
            }
                
        }
    }
    
    var selectedCountry: PhoneCodeModel? = PhoneCodeData.phoneCodeModel[0]
    let test_phoneNumber = "15 234 6077"

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
        self.tabBarController?.tabBar.isHidden = true
        mRightBarBtn.image = img_bkd
        mSendBtn.layer.cornerRadius = 8
        mChangeNumberBtn.layer.cornerRadius = 8
        mPhoneNumberContentV.setBorder(color: color_email!, width: 1)
        mDropDownImgV.setTintColor(color: color_email!)
        mNumberTxtFl.text = test_phoneNumber
        mNumberTxtFl.delegate = self
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
    
    func didUpdateStatus(_ isActive: Bool)  {
        if isActive {
            mSendBtn.enable()
            mChangeNumberBtn.enable()
        } else {
            mSendBtn.disable()
            mChangeNumberBtn.disable()
        }
        setToPhoneNumberActiveColor(isActive ? color_email! : color_navigationBar!)
    }
    
    // MARK: - Actions
    @IBAction func didChangeFiled() {
        didUpdateStatus(mNumberTxtFl.text?.count == selectedCountry?.validFormPattern)
       // didUpdateStatus?(phoneTextField.text?.count == valida)
    }
    
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


extension ChangePhoneNumberViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let fullText = textField.text! + string
        return fullText.count <= selectedCountry?.validFormPattern ?? 0

    }
}



//MARK: - SearchPhoneCodeViewControllerDelegate
//MARK: --------------------------------------
extension ChangePhoneNumberViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCodeModel) {
        selectedCountry = country
        mFlagImgV.image = country.flag
        mCodeLb.text = country.code
    }
    
}