//
//  FreeReservationOverViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-11-21.
//

import UIKit

class FreeReservationOverViewController: BaseViewController {

    //MARK: -- Outlets
    @IBOutlet weak var mNoticeLb: UILabel!
   //Deposit
    @IBOutlet weak var mDepositCheckBtn: UIButton!
    @IBOutlet weak var mDepositPriceLb: UILabel!
    @IBOutlet weak var mDepositLb: UILabel!
    //Deposit + rental price
    @IBOutlet weak var mDepositRentalPriceCheckBtn: UIButton!
    @IBOutlet weak var mDepositRentalPriceLb: UILabel!
    @IBOutlet weak var mDepositRentalLb: UILabel!
    //Confirm
    @IBOutlet weak var mConfirmV: ConfirmView!
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    public var vehicleModel: VehicleModel?
    var paymentOption:PaymentOption = .none

    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        handlerContinue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mConfirmV.mConfirmBtnLeading.constant = 0.0
        resetChecks()
    }
    
    func configureUI() {
        mRightBarBtn.image = img_bkd
        mDepositPriceLb.text = Constant.Texts.euro + " " +  String(vehicleModel?.depositPrice ?? 0.0)
        mDepositRentalPriceLb.text = Constant.Texts.euro + " " + String(vehicleModel?.depositPrice ?? 0.0) + " + " + String(format: "%.2f",PriceManager.shared.totalPrice ?? 0.0)
    }
    
    //Uncheck all buttons
    private func resetChecks() {
        isEnableConfirm(enable: false)
        mDepositCheckBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
        mDepositRentalPriceCheckBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
    }
    
    //Set enable or disable to confirm button
    private func isEnableConfirm(enable: Bool) {
        mConfirmV.isUserInteractionEnabled = enable
        mConfirmV.alpha = enable ? 1 : 0.8
    }
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)

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
    
    @IBAction func depositRentalPrice(_ sender: UIButton) {
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
    
    func handlerContinue() {
        mConfirmV.didPressConfirm = {
            self.goToSelectPayment()
        }
    }
    
}
