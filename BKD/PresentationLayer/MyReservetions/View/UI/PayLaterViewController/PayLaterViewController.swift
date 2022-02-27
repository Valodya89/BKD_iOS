//
//  PayLaterViewController.swift
//  PayLaterViewController
//
//  Created by Karine Karapetyan on 13-09-21.
//

import UIKit

class PayLaterViewController: BaseViewController {
    
    @IBOutlet weak var mDescriptionLb: UILabel!
    @IBOutlet weak var mDepositCheckBtn: UIButton!
    @IBOutlet weak var mDepositRentalimgV: UIImageView!
    @IBOutlet weak var mdepositimgV: UIImageView!
    @IBOutlet weak var mDepositLb: UILabel!
    @IBOutlet weak var mDepositPriceLb: UILabel!
    
    @IBOutlet weak var mDepositRentalCheckBtn: UIButton!
    @IBOutlet weak var mDepositRentalLb: UILabel!
    @IBOutlet weak var mDepositRentalPriceLb: UILabel!
    
    @IBOutlet weak var mContinueContentV: UIView!
    @IBOutlet weak var mContinueBtn: UIButton!
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: - Variables
    var paymentOption:PaymentOption = .none
    public var currRent: Rent?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mContinueLeading.constant = 0.0
    }
    
    func setUpView()  {
        tabBarController?.tabBar.isHidden = true
        mRightBarBtn.image = img_bkd
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mContinueBtn.layer.cornerRadius = 8
        mContinueBtn.layer.borderColor = color_navigationBar!.cgColor
        mContinueBtn.layer.borderWidth = 1.0
        mDepositRentalCheckBtn.setTitle("", for: .normal)
        mDepositCheckBtn.setTitle("", for: .normal)
        mDepositPriceLb.text = String(currRent?.depositPayment.amount ?? 0.0)
        mDepositRentalPriceLb.text = String(currRent?.depositPayment.amount ?? 0.0) + " + " +  String(currRent?.rentPayment.amount ?? 0.0)
        
    }
    
    //Animate continue
    private func clickContinue() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueContentV.bounds.width - self.mContinueBtn.frame.size.width
            self.mContinueContentV.layoutIfNeeded()
        } completion: { _ in
            
            self.goToAgreement(on: self,
                               agreementType: .payLater, paymentOption: self.paymentOption,
                               vehicleModel: nil,
                               rent: self.currRent,
                               urlString: ApplicationSettings.shared.settings?.metadata.PrivacyPolicyUrl ?? "")
        }
    }
    
    
    
//    ///Open agree Screen
//    private func goToAgreement() {
//
//        let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
//        bkdAgreementVC.isPayLater = true
//        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
//    }
    
    //Uncheck all buttons
    private func resetChecks() {
        isEnableConfirm(enable: false)
        mdepositimgV.image = #imageLiteral(resourceName: "uncheck_box")
        mDepositRentalimgV.image = #imageLiteral(resourceName: "uncheck_box")
    }

    //Set enable or disable to confirm button
    private func isEnableConfirm(enable: Bool) {
        mContinueContentV.isUserInteractionEnabled = enable
        mContinueContentV.alpha = enable ? 1 : 0.8
    }

   //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func depositRentalPrice(_ sender: UIButton) {
        
        resetChecks()
        if paymentOption == .depositRental {
            mDepositRentalimgV.image = #imageLiteral(resourceName: "uncheck_box")
            paymentOption = .none
        } else {
            isEnableConfirm(enable: true)
            mDepositRentalimgV.image = #imageLiteral(resourceName: "check")
            paymentOption = .depositRental
        }
    }
    
    @IBAction func deposite(_ sender: UIButton) {
        
        resetChecks()
        if paymentOption == .deposit {
            mdepositimgV.image = #imageLiteral(resourceName: "uncheck_box")
            paymentOption = .none
        } else {
            isEnableConfirm(enable: true)
            mdepositimgV.image = #imageLiteral(resourceName: "check")
            paymentOption = .deposit
        }
    }
    
    @IBAction func continuewSwipe(_ sender: UISwipeGestureRecognizer) {
        clickContinue()
    }
    
    @IBAction func continueHandler(_ sender: UIButton) {
        clickContinue()
    }
}
