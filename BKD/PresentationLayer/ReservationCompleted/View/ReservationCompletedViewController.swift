//
//  ReservationCompletedViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

enum PaymentOption {
    case deposit
    case rental
    case depositRental
    case payLater
    case none
}

import UIKit

class ReservationCompletedViewController: BaseViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var mPayLaterLb: UILabel!
    @IBOutlet weak var mPayLaterBtn: UIButton!
    @IBOutlet weak var mDepositRentalPriceLb: UILabel!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mDepositRentalLb: UILabel!
    @IBOutlet weak var mDepositRentalCheckBtn: UIButton!
    @IBOutlet weak var mDepositPriceLb: UILabel!
    @IBOutlet weak var mDepositLb: UILabel!
    @IBOutlet weak var mDepositCheckBtn: UIButton!
    @IBOutlet weak var mPaymentOptionInfoLb: UILabel!
    @IBOutlet weak var mPayLaterInfoLb: UILabel!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mPreReservetionTitleLb: UILabel!
    @IBOutlet weak var mConfirmContentV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    @IBOutlet weak var mVisualEffectV: UIVisualEffectView!
    
    //MARK: - Variables
    lazy var reservationCompletedViewModel =  ReservationCompletedViewModel()
    var paymentOption: PaymentOption = .none
    public var vehicleModel: VehicleModel?
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mConfirmBtn.roundCornersWithBorder(corners: .allCorners, radius: 8, borderColor: color_navigationBar!, borderWidth: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mConfirmLeading.constant = 0.0
        mVisualEffectV.isHidden = true
        resetChecks()
    }
    
    func setUpView()  {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        configUI()
    }
    
    
    
    private func configUI() {
        mRightBarBtn.image = img_bkd
        mPreReservetionTitleLb.layer.masksToBounds = true
        mPreReservetionTitleLb.layer.cornerRadius = 8
        mPreReservetionTitleLb.setPadding(8)
        mPreReservetionTitleLb.textAlignment = .center
        mConfirmBtn.layer.cornerRadius = 8
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mDepositPriceLb.text = Constant.Texts.euro + " " + String(vehicleModel?.depositPrice ?? 0.0)
        mDepositRentalPriceLb.text = Constant.Texts.euro + " " + String(vehicleModel?.depositPrice ?? 0.0) + " + " + String(format: "%.2f",PriceManager.shared.totalPrice ?? 0.0)
        vehicleModel?.totalPrice = PriceManager.shared.totalPrice ?? 0.0
    }
    
    
    ///Pay later
    private func payLater() {
        reservationCompletedViewModel.payLater { [weak self] (status, result) in
            if status == .countLimited {
                self?.goToFreeReservationOverScreen()
            } else if result != nil {
                self?.showAlertOfPayLater(message: self?.reservationCompletedViewModel.getFreeReservationMessage(payLaterCount: result?.payLaterCount ?? 0))
            }
       // print (result)

        }
    }
    
    //Animate confirm
    private func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmContentV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmContentV.layoutIfNeeded()
        } completion: { _ in
            self.goToSelectPayment(vehicleModel: self.vehicleModel ?? VehicleModel(), rent: nil,
                                   paymentOption: self.paymentOption)
        }
    }
    
    //Open freeReservationOver  screen
     func goToFreeReservationOverScreen() {
        let freeReservationCompletedVC = FreeReservationOverViewController.initFromStoryboard(name: Constant.Storyboards.reservationCompleted)
         freeReservationCompletedVC.vehicleModel = vehicleModel
        self.navigationController?.pushViewController(freeReservationCompletedVC, animated: true)
    }
    
    //Uncheck all buttons
    private func resetChecks() {
        isEnableConfirm(enable: false)
        mDepositCheckBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
        mDepositRentalCheckBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
        mPayLaterBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
    }

    //Set enable or disable to confirm button
    private func isEnableConfirm(enable: Bool) {
        mConfirmContentV.isUserInteractionEnabled = enable
        mConfirmContentV.alpha = enable ? 1 : 0.8
    }
    
    private func showAlertOfPayLater(message: String?) {
        self.mVisualEffectV.isHidden = false
        let bkdAlert = BKDAlert()
        bkdAlert.backgroundView.isHidden = true
        bkdAlert.showAlert(on: self, title: nil, message: message, messageSecond: nil, cancelTitle: Constant.Texts.gotIt, okTitle: Constant.Texts.payNow) {
            self.mVisualEffectV.isHidden = true
        } okAction: {
            self.goToSelectPayment(vehicleModel: self.vehicleModel ?? VehicleModel(), rent: nil,
                                   paymentOption: self.paymentOption)
        }
    }
    
    
   //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        clickConfirm()
    }
    
    @IBAction func confirmSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        clickConfirm()
    }
    
    @IBAction func deposit(_ sender: UIButton) {
        resetChecks()
        if paymentOption == .deposit {
            sender.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
            paymentOption = .none
        } else {
            isEnableConfirm(enable: true)
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            paymentOption = .deposit
        }
            
    }
    
    @IBAction func depositRental(_ sender: UIButton) {
        resetChecks()
        if paymentOption == .depositRental {
            sender.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
            paymentOption = .none
        } else {
            isEnableConfirm(enable: true)
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            paymentOption = .depositRental
        }
    }
    
    @IBAction func payLater(_ sender: UIButton) {
        
        resetChecks()
        if paymentOption == .payLater {
            sender.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
            paymentOption = .none
        } else {
            isEnableConfirm(enable: true)
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            paymentOption = .payLater
            payLater()
        }
        
    }
}
