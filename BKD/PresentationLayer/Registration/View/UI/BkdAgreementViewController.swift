//
//  BkdAgreementViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit
import WebKit
import SVProgressHUD


enum AgreementType {
    case advanced
    case editAdvanced
    case myReservationCell
    case payLater
    case reserve
    case none
    
}

protocol BkdAgreementViewControllerDelegate: AnyObject {
    func agreeTermsAndConditions()
}

class BkdAgreementViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mAgreeV: ConfirmView!
    @IBOutlet weak private var mWebV: WKWebView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    
    //MARK: -- Variables
    weak var delegate: BkdAgreementViewControllerDelegate?
    
    private var account: Account?
    private var htmlString = ""
    public var urlString: String? = nil
    public var agreementType: AgreementType?
    public var vehicleModel: VehicleModel?
    public var currRent: Rent?
    public var searchModel: SearchModel?
    public var editReservationModel: EditReservationModel?
    public var paymentOption:PaymentOption?
    
    //MARK: --Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configWebView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mAgreeV.mConfirmBtnLeading.constant = 0
        loadWebView()
    }
    
    //MARK: -- Set
    func setUpView() {
        mRightBarBtn.image = img_bkd
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mAgreeV.mConfirmLb.text = Constant.Texts.agree
        handlerAgree()
    }
    
//    /// Set page data with URL
//    func setData(urlString: String) {
//        self.urlString = urlString
//    }
    
    /// Set page data with htmlString
    func setData(htmlString: String) {
        self.htmlString = htmlString
    }
    
    /// Configure webView
    private func configWebView() {
        mWebV.navigationDelegate = self
    }
    
    /// Load webView with url or htmlString
    private func loadWebView() {
        if let validURL = URL(string: urlString ?? "") {
            let request = URLRequest(url: validURL)
            mWebV.load(request)
        } else {
            mWebV.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    ///Get user account
    private func getAccount(isPayment: Bool,
                            paymentOption: PaymentOption) {
        
        ApplicationSettings.shared.getAccount { account in
            self.account = account
            self.checkPhoneVerification(isPayment: isPayment, paymentOption: paymentOption)
        }
    }
   
    ///Check phone verification to reservation completed
    func checkPhoneVerification(isPayment: Bool, paymentOption: PaymentOption) {
        
        if paymentOption != .none {
            vehicleModel = VehicleModel()
            vehicleModel?.rent = self.currRent
        }
        
        if self.account?.phoneVerified == true {
            if isPayment {
                self.goToSelectPayment(vehicleModel: vehicleModel,
                                           paymentOption: paymentOption)
            } else {
                self.goToReservationCompleted(vehicleModel: self.vehicleModel)
            }
                        
        } else {
            self.goToPhoneVerification(vehicleModel: vehicleModel, phoneNumber: account?.phoneNumber, phoneCode: account?.phoneCode, paymentOption: paymentOption)
        }
    }
    
  //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerAgree() {
        mAgreeV.didPressConfirm  = {
           
            switch self.agreementType {
                
            case .advanced:
                self.getAccount(isPayment: true, paymentOption: .rental)
            case .myReservationCell:
                self.getAccount(isPayment: true, paymentOption: self.paymentOption ?? .none)
            case .payLater:
                self.getAccount(isPayment: true, paymentOption: self.paymentOption ?? .none)
                // if phone verified
//                 self.goToSelectPayment(vehicleModel: vehicleModel,
//                                        paymentOption: self.paymentOption ?? .none)
                break
                
            case .editAdvanced:
                self.updateReservation()
            case .reserve:
                self.addReservation()
            default:
                self.delegate?.agreeTermsAndConditions()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    ///Add reservation
    private func addReservation() {
        ReserveViewModel().addRent(vehicleModel: vehicleModel ?? VehicleModel()) { result, error in
                if let _ = error {
                    self.showAlertSignIn()
                    
                } else if result == nil {
                    self.showAlert()
                    
                } else {
                    self.vehicleModel?.rent = result!
                    self.getAccount(isPayment: false, paymentOption: .none)
                }
        }
    }
    
    ///Update car reservation
    func updateReservation() {
        EditReservetionAdvancedViewModel().updateRent(rentId: currRent?.id ?? "", editReservationModel: editReservationModel!, searchModel: searchModel ?? SearchModel()) { result in
            guard let _ = result else {return}
            self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
            
        }
    }
    
    ///Show alert
    private func showAlert() {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.errRegistrationBot,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.ok,
                             cancelAction: nil) {
            self.goToMyBkd()
        }
    }
    
    ///Go to myBkd screen
    private func goToMyBkd() {
        self.tabBarController?.selectedIndex = 4
        self.navigationController?.popToViewController(ofClass: MyBKDViewController.self, animated: true)
    }
    
}


// MARK: -- WKNavigation Delegate
extension BkdAgreementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
