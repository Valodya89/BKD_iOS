//
//  ChangePhoneNumberViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit
import SwiftMaskTextfield
import PhoneNumberKit


protocol  ChangePhoneNumberViewControllerDelegate: AnyObject {
    func didChangeNumber(phone: String)
}

final class ChangePhoneNumberViewController: BaseViewController {
    
    //MARK: -- Outlets
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
    

    //MARK: -- Variables
    weak var delegate:  ChangePhoneNumberViewControllerDelegate?
    lazy var changePhoneNumberViewModel = ChangePhoneNumberViewModel()
    public var vehicleModel: VehicleModel?
    public var newPhoneNumber: String?
    private var selectedCountry: PhoneCode?
    private var validFormPattern: Int = 0
    private let phoneNumberKit = PhoneNumberKit()
    private var phoneNumber: String? {
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
    
//    var isValid: Bool {
//        return mNumberTxtFl.text?.count == selectedCountry?.validFormPattern
//    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    private func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        self.tabBarController?.tabBar.isHidden = true
        mRightBarBtn.image = img_bkd
        mSendBtn.layer.cornerRadius = 8
        mChangeNumberBtn.layer.cornerRadius = 8
        mPhoneNumberContentV.setBorder(color: color_email!, width: 1)
        mDropDownImgV.setTintColor(color: color_email!)
        mNumberTxtFl.delegate = self
        
    }
    
    ///Configure UI
    func configureUI() {
        selectedCountry = changePhoneNumberViewModel.getPhoneCode()
        if let _ = selectedCountry {
            setPhoneCode(selectedCountry!)
        } else if let phoneCode = ApplicationSettings.shared.phoneCodes?.first {
            setPhoneCode(phoneCode)
        }
        
        phoneNumber =  changePhoneNumberViewModel.getPhoneNumber()?.replacingOccurrences(of: selectedCountry?.code ?? "", with: "")
        mNumberTxtFl.text = phoneNumber
        mInfoLb.text = String(format: Constant.Texts.phoneVerificationInfo, selectedCountry?.code ?? "", phoneNumber ?? "")

    }
   
    ///Send Code SMS
    private func sendPhoneCode() {
        phoneNumber = mNumberTxtFl.text
        changePhoneNumberViewModel.sendCodeSms(phoneCode: selectedCountry?.code ?? "", phoneNumber: phoneNumber ?? "") { response, err in
            guard let _ = response else {return}
            self.goToPhoneVerification()
        }
    }
    
    private func setToPhoneNumberActiveColor(_ color: UIColor) {
        mDropDownImgV.setTintColor(color: color)
        mCodeLb.textColor = color
        mPhoneNumberContentV.layer.borderColor = color.cgColor
        mNumberTxtFl.textColor = color
    }
    
    ///Open phone verification screen
    private func goToPhoneVerification() {
        let phoneVerification = PhoneVerificationViewController.initFromStoryboard(name: Constant.Storyboards.phoneVerification)
        phoneVerification.phoneCode = selectedCountry?.code
        phoneVerification.phoneNumber = phoneNumber
        phoneVerification.vehicleModel = vehicleModel
        self.navigationController?.pushViewController(phoneVerification, animated: true)
    }
    
    private func didUpdateStatus(_ isActive: Bool)  {
        if isActive {
            mSendBtn.enable()
            mChangeNumberBtn.enable()
        } else {
            mSendBtn.disable()
            mChangeNumberBtn.disable()
        }
        setToPhoneNumberActiveColor(isActive ? color_email! : color_navigationBar!)
    }
    
    private func setPhoneCode(_ phoneCode: PhoneCode) {
        selectedCountry = phoneCode
        mFlagImgV.image = phoneCode.imageFlag
        mCodeLb.text = phoneCode.code
        mNumberTxtFl.formatPattern = phoneCode.mask ?? ""
        validFormPattern = (selectedCountry?.mask!.count)!
        mInfoLb.text = String(format: Constant.Texts.phoneVerificationInfo, selectedCountry?.code ?? "", phoneNumber ?? "")
    }
    
    // MARK: -- Actions
    @IBAction func didChangeFiled() {
    phoneNumber = mNumberTxtFl.text
        mInfoLb.text = String(format: Constant.Texts.phoneVerificationInfo, selectedCountry?.code ?? "", phoneNumber ?? "")
        didUpdateStatus(mNumberTxtFl.text?.count == validFormPattern)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        delegate?.didChangeNumber(phone: (selectedCountry?.code ?? "") + (phoneNumber ?? ""))
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        sendPhoneCode()
    }
    
    @IBAction func changeNumber(_ sender: UIButton) {
        self.goToSearchPhoneCode(viewCont: self)
    }
    
    @IBAction func searchCountry(_ sender: UIButton) {
        self.goToSearchPhoneCode(viewCont: self)
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
        return fullText.count <= validFormPattern
    }
}


//MARK: - SearchPhoneCodeViewControllerDelegate
//MARK: --------------------------------------
extension ChangePhoneNumberViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCode) {
        setPhoneCode(country)
    }
}
