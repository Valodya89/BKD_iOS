//
//  SelectPaymentViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

import UIKit
import SafariServices

//import PassKit

let kCustomURLScheme = "kitefasterCustomUrlScheme://"


final class SelectPaymentViewController: UIViewController, StoryboardInitializable {
    
    //MARK: - Outlet
    @IBOutlet weak var mPaymentTbV: UITableView!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mMaskePaymentLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mDepositInfoLb: UILabel!
    @IBOutlet weak var mDepositLbHeight: NSLayoutConstraint!
    @IBOutlet weak var mBlurV: UIVisualEffectView!
    @IBOutlet weak var mBancontactTypeV: BancontactTypeView!
    @IBOutlet weak var mBancontactV: BancontactView!
    @IBOutlet weak var mBancontactTypeBottom: NSLayoutConstraint!
    
    //MARK: - Variables
    private let viewModel = PaymentViewModel()
    var paymentTypes = PaymentTypeData.paymentTypeModel
    var paymentType: PaymentTypesResponse?
    var userWallet: UserWallet?
    public var vehicleModel: VehicleModel?
    public var paymentOption: PaymentOption?
    public var isDeposit:Bool = false
    
//    //MARK: - Local properties
//    private var paymentRequest: PKPaymentRequest = {
//        let request = PKPaymentRequest()
//        request.merchantIdentifier = "merchant.com.BKD.bkdrental"
//        request.supportedNetworks = [.masterCard, .visa, .quicPay]
//        request.supportedCountries = paymentSupportedCountriesCode
//        request.merchantCapabilities = .capability3DS
//        request.countryCode = "AM"
//        request.currencyCode = "ARM"
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Car rent", amount: 150)]
//        return request
//    }()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mBlurV.isHidden = true
        paymentTypes = PaymentTypeData.paymentTypeModel
        mPaymentTbV.reloadData()
        self.view.setNeedsLayout()
        mDepositInfoLb.isHidden = !isDeposit

    }
    
    override func viewDidLayoutSubviews() {
        mDepositLbHeight.constant =  isDeposit ? 100 : 0
        if mBlurV.isHidden {
            mBancontactV.mContentVBottom.constant = -400
            mBancontactTypeV.mContentVBottom.constant = -400
            
        }
    }
    
    func setUpView() {
        configureUI()
        configureDelegate()
        selectBancontactType()
        selectBancontactCard()
        getUserWallet()
    }
    
    ///configure UI
    func configureUI() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mMaskePaymentLb.text = String(format: Constant.Texts.makePayment, paymentOption == .depositRental ? ((vehicleModel?.depositPrice ?? 0.0) + (vehicleModel?.totalPrice ?? 0.0) ) : vehicleModel?.depositPrice ?? 0.0 )
    }
    
    ///configure delegate
    func configureDelegate() {
        mPaymentTbV.delegate = self
        mPaymentTbV.dataSource = self
    }

    
    /// Selected bancontact type
    func selectBancontactType() {
        mBancontactTypeV.didPressBancontact = {
            self.getPaymentUrl(isBancontact: true,
                               bancontactType: .bancontact,
                               otherPaymentType: nil)
        }
        
        mBancontactTypeV.didPressMobileBancking = {
            
            self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactTypeBottom )

            self.animateBancontactTypeView(isShow: true, bottom: self.mBancontactV.mContentVBottom )
        }
    }
    
    ///Selected bancontact card type
    func selectBancontactCard() {
        mBancontactV.didPressBancontactCard = { cardType in
            self.getPaymentUrl(isBancontact: true,
                               bancontactType: cardType,
                               otherPaymentType: nil)
        }
    }
    
    
    ///Test of url scheme

    class func openCustomApp(by urlScheme: String) {
        if openCustomURLScheme(customURLScheme: urlScheme) {
            print("app was opened successfully")
           } else {
            print("handle unable to open the app, perhaps redirect to the App Store")
           }
       }


       class func openCustomURLScheme(customURLScheme: String) -> Bool {
           let customURL = URL(string: customURLScheme)!
           if UIApplication.shared.canOpenURL(customURL) {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(customURL)
               } else {
                   UIApplication.shared.openURL(customURL)
               }
               return true
           }

           return false
       }
    
    
    
// ///TEST
//    /// Selected Apple Pay
//    func selectApplePay() {
//        let applePaymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//        if applePaymentController != nil  {
//            applePaymentController! .delegate = self
//            present(applePaymentController!, animated: true)
//        }
//
//    }
    
    ///Open Payment Web Screen
    private func goToWebScreen(paymentType: PaymentType) {
        let paymentWebVC = PaymentWebViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        paymentWebVC.paymentType = paymentType
        navigationController?.pushViewController(paymentWebVC, animated: true)
    }
    
    ///Open Payment Web Screen
    private func goToWebScreen(urlString: String, paymentType: PaymentType?) {
        
        let paymentWebVC = PaymentWebViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        paymentWebVC.setData(urlString: urlString)
        paymentWebVC.paymentType = paymentType
        navigationController?.pushViewController(paymentWebVC, animated: true)
    }
    
    ///Open safari
    private func openSafari(urlString: String) {
        let safariVC = SFSafariViewController(url: URL(string:urlString)!)
        self.present(safariVC, animated: false, completion: nil)
        
    }
    

    ///Get payment type list
    func getPaymentTypes() {
        
        viewModel.getPaymentTypes { response in
            guard let response = response else {return}
            self.paymentType = response
        }
    }
    
    ///Get user wallet
    func getUserWallet() {
        
        viewModel.getWallet { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userWallet):
                self.userWallet = userWallet
            case .failure(let error):
                print("ERROR: \(error.message)")
            }
        }
    }
   
    ///Get payment url
    func getPaymentUrl(isBancontact:  Bool,
                       bancontactType: BancontactCard?,
                       otherPaymentType: PaymentType?) {
        
        viewModel.getPaymentUrl(isBancontact:  isBancontact,
                                bancontactType: bancontactType,
                                otherPaymentType: otherPaymentType,
                                paymentOption: paymentOption ?? .none,
                                vehicleModel: vehicleModel ?? VehicleModel()) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let attachedCardURL):
                print (attachedCardURL)
                if otherPaymentType == .applePay {
                    self.openSafari(urlString: attachedCardURL)
                } else {
                    self.goToWebScreen(urlString: attachedCardURL, paymentType: otherPaymentType)
                }
            case .failure(let error):
                print("ERROR: \(error.message)")
//                self.goToWebScreen(urlString: "https://www.mollie.com/checkout/wallets/apple-pay/reference/N6FJKAQcG3", paymentType: otherPaymentType)
            }
        }
    }
    
    
    ///Gret pay pal url
    func getPayPalUrl() {
        viewModel.getPayPalUrl(paymentOption: paymentOption ?? .none,
                               vehicleModel: vehicleModel ?? VehicleModel()) {  [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let attachedCardURL):
                self.goToWebScreen(urlString: attachedCardURL, paymentType: nil)
            case .failure(let error):
                print("ERROR: \(error.message)")
            }
        }
    }
    

    ///Hide Bancontact view
    private func hideBancontact() {
        mBlurV.isHidden = true
        self.paymentTypes = PaymentTypeData.paymentTypeModel
        self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactTypeBottom )
        self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactV.mContentVBottom )
        self.mPaymentTbV.reloadData()
        
    }
    
    //MARK: - Actions
    @IBAction func swipeBancontact(_ sender: UISwipeGestureRecognizer) {
        hideBancontact()
    }
    
    @IBAction func TapGesture(_ sender: UITapGestureRecognizer) {
        hideBancontact()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymenTypeTableViewCell.identifier, for: indexPath) as! PaymenTypeTableViewCell
        
        cell.setCellInfo(item: paymentTypes[indexPath.row], index: indexPath.row)
        openPaymentScreen(cell: cell)
          return cell
    }
    
    /// Animate Bancontact Type View
    private func animateBancontactTypeView(isShow: Bool, bottom: NSLayoutConstraint){

        UIView.animate(withDuration: 0.7, animations: {
            bottom.constant = isShow ? 17 : -400
            self.view.layoutIfNeeded()
        })
    }
    
    /// Open web page for payment
    private func openPaymentScreen(cell: PaymenTypeTableViewCell) {
        cell.didPressPayment = { [self] paymentType, index in
            
            self.paymentTypes = PaymentTypeData.paymentTypeModel
            self.paymentTypes[index].isClicked = true
            self.mPaymentTbV.reloadData()
            
            switch paymentType {
            case .creditCard,
                 .applePay,
                 .kaartlazer:
                
                getPaymentUrl(isBancontact: false,
                              bancontactType: nil,
                              otherPaymentType: paymentType)
                
            case .payPal:
                getPayPalUrl()

            case .bancontact:
                mBlurV.isHidden = false
                self.animateBancontactTypeView(isShow: true, bottom: self.mBancontactTypeBottom)
                break
           
            }
            
        }
    }
}


//extension SelectPaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//        self.paymentTypes = PaymentTypeData.paymentTypeModel
//        self.mPaymentTbV.reloadData()
//    }
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        let paymentTocken = payment.token
//        sendBackendServiceToProcessPayment(tocken: paymentTocken) { (success) in
//            completion(PKPaymentAuthorizationResult(status: success ? .success : .failure, errors: nil))
//            //[NSError(domain: "com.ali", code: 12, userInfo: nil)]
//        }
//       // completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//    
//    func sendBackendServiceToProcessPayment(tocken: PKPaymentToken, complition: (Bool) -> Void ) {
//        complition(true)
//    }
//    
//}
