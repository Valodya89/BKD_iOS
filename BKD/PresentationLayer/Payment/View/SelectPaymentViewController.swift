//
//  SelectPaymentViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

import UIKit
import PassKit

final class SelectPaymentViewController: UIViewController, StoryboardInitializable {
    
    //MARK: - Outlet
    @IBOutlet weak var mPaymentTbV: UITableView!
    @IBOutlet weak var mBancontactTypeBottom: NSLayoutConstraint!
    @IBOutlet weak var mBancontactTypeV: BancontactTypeView!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mBancontactV: BancontactView!
    @IBOutlet weak var mBlurV: UIVisualEffectView!
    
    //MARK: - Variables
    private let viewModel = PaymentViewModel()
    let paymentTypes = PaymentTypeData.paymentTypeModel
    //MARK: - Local properties
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.BKD.bkdrental"
        request.supportedNetworks = [.masterCard, .visa, .quicPay]
        request.supportedCountries = paymentSupportedCountriesCode
        request.merchantCapabilities = .capability3DS
        request.countryCode = "AM"
        request.currencyCode = "ARM"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Car rent", amount: 150)]
        return request
    }()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mBlurV.isHidden = true
        mBancontactV.mContentVBottom.constant = -400
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        selectBancontactType()
        selectBancontactCard()
    }
    
    /// Selected bancontact type
    func selectBancontactType() {
        mBancontactTypeV.didPressBancontact = {
            self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactTypeBottom )

            self.animateBancontactTypeView(isShow: true, bottom: self.mBancontactV.mContentVBottom )
        }
        mBancontactTypeV.didPressMobileBancking = {
            self.goToWebScreen(paymentType: .creditCard)

        }
    }
    
    ///Selected bancontact card type
    func selectBancontactCard() {
        mBancontactV.didPressBancontactCard = { cardType in
            switch cardType {
            case .ing:
                self.goToWebScreen(paymentType: .creditCard)
            case .bnp:
            self.goToWebScreen(paymentType: .creditCard)
            case .kbc:
                self.goToWebScreen(paymentType: .creditCard)
            }
        }
    }
    
    
    /// Selected Apple Pay
    func selectApplePay() {
        let applePaymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if applePaymentController != nil  {
            applePaymentController! .delegate = self
            present(applePaymentController!, animated: true)
        }
        
    }
    
    ///Open Payment Web Screen
    private func goToWebScreen(paymentType: PaymentType) {
        let paymentWebVC = PaymentWebViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        paymentWebVC.paymentType = paymentType
        navigationController?.pushViewController(paymentWebVC, animated: true)
    }
    
    ///Open Payment Web Screen
    private func goToWebScreen(urlString: String) {
        let paymentWebVC = PaymentWebViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        paymentWebVC.setData(urlString: urlString)
        navigationController?.pushViewController(paymentWebVC, animated: true)
    }
    
    /// Animate Bancontact Type View
    private func animateBancontactTypeView(isShow: Bool, bottom: NSLayoutConstraint){

        UIView.animate(withDuration: 0.7, animations: {
            bottom.constant = isShow ? 17 : -400
            self.view.layoutIfNeeded()
        })
    }
    
    func getCreditCardURL() {
        viewModel.getAttachedCardURL { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let attachedCardURL):
                self.goToWebScreen(urlString: attachedCardURL)
            case .failure(let error):
                print("ERROR: \(error.message)")
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func swipeBancontactTypeV(_ sender: UISwipeGestureRecognizer) {
        mBlurV.isHidden = true
        //mGradientV.isHidden = true
        self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactTypeBottom )
        self.mPaymentTbV.reloadData()
    }
    
    @IBAction func swipeBancontactV(_ sender: UISwipeGestureRecognizer) {
        self.animateBancontactTypeView(isShow: false, bottom: self.mBancontactV.mContentVBottom )
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
    
    ///
    private func openPaymentScreen(cell: PaymenTypeTableViewCell) {
        cell.didPressPayment = { [self] paymentType in
            switch paymentType {
            case .creditCard:
                self.getCreditCardURL()
            case .bancontact:
                mBlurV.isHidden = false
                //mGradientV.isHidden = false
                self.animateBancontactTypeView(isShow: true, bottom: self.mBancontactTypeBottom)
            case .applePay:
                self.selectApplePay()
            case .payPal:
                self.goToWebScreen(paymentType: .payPal)
            case .kaartlazer:
                self.goToWebScreen(paymentType: .kaartlazer)
            case .officeTerminal:
                self.goToWebScreen(paymentType: .officeTerminal)
            }
        }
    }
}


extension SelectPaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let paymentTocken = payment.token
        sendBackendServiceToProcessPayment(tocken: paymentTocken) { (success) in
            completion(PKPaymentAuthorizationResult(status: success ? .success : .failure, errors: nil))
            //[NSError(domain: "com.ali", code: 12, userInfo: nil)]
        }
       // completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func sendBackendServiceToProcessPayment(tocken: PKPaymentToken, complition: (Bool) -> Void ) {
        complition(true)
    }
    
}
