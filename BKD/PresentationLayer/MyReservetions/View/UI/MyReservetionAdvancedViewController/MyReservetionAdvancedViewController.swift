//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class MyReservetionAdvancedViewController: UIViewController {
    //MARK: - Outlet
    //Car
    @IBOutlet weak var mCarBckgV: UIView!
    @IBOutlet weak var mTowBarBckgV: UIView!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mTowBarBtn: UIButton!
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mCarImgBckgV: UIView!
    
    @IBOutlet weak var mCarMarkBckgV: UIView!
    @IBOutlet weak var mFiatImgV: UIImageView!
    @IBOutlet weak var mCarDescriptionlb: UILabel!
    @IBOutlet weak var mCarMarkLb: UILabel!
    
   //PickUP
    @IBOutlet weak var mPickUpLb: UILabel!
    @IBOutlet weak var mRentLb: UILabel!
    @IBOutlet weak var mRentInfoBckgV: UIView!
    @IBOutlet weak var mPickUpParkingLb: UILabel!
    @IBOutlet weak var mPickUpDateLb: UILabel!
    @IBOutlet weak var mPickUpMonthLb: UILabel!
    @IBOutlet weak var mPickUpTimeLb: UILabel!
    
 //return
    @IBOutlet weak var mReturnParkingLb: UILabel!
    @IBOutlet weak var mReturnDateLb: UILabel!
    @IBOutlet weak var mReturnMonthLb: UILabel!
    @IBOutlet weak var mReturnTimeLb: UILabel!
    
   //Confirm
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet var mConfirmSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    //Navigation
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mNavigationItem: UINavigationItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mReserveInfoTableV: ReserveTableView!
    @IBOutlet weak var mReserveTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mStartRideVLeading: NSLayoutConstraint!
    
    ///Payment status TableView
    @IBOutlet weak var mPaymentStatusTableV: PaymentStatusUITableView!
    @IBOutlet weak var mPaymentStatusTableHeight: NSLayoutConstraint!
    
    /// Register Number TableView
    @IBOutlet weak var mRegisterNumberTableV: RegisterNumberUITableView!
    @IBOutlet weak var mRegisterNumberTableHeight: NSLayoutConstraint!
    
    ///Additional driver
    @IBOutlet weak var mAdditionalDriverTableV: AdditionalDriverTableView!
    @IBOutlet weak var mAdditionalDriverTableHeight: NSLayoutConstraint!
    
   ///Total price
    @IBOutlet weak var mTotalPriceStackV: TotalPriceStackView!
    @IBOutlet weak var mNewPriceTableV: PriceTableView!
    @IBOutlet weak var mNewPriceTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mOldPriceTableV: PriceTableView!
    @IBOutlet weak var mOldPriceTableHeight: NSLayoutConstraint!
    
    ///Buttons
    @IBOutlet weak var mAgreementBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    
    ///Start ride
    @IBOutlet weak var mStartRideContentV: UIView!
    @IBOutlet weak var mStartRideBtn: UIButton!
    
    
    //MARK: - Variables
    var reserveViewModel = ReserveViewModel()
    public var vehicleModel: VehicleModel?
    var currentTariff: Tariff = .hourly
    var lastContentOffset:CGFloat = 0.0
    var totalPrice: Double = 0.0
    var isEdited: Bool = false
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mConfirmLeading.constant = 0.0
        self.tabBarController?.tabBar.isHidden = true
        
        mStartRideVLeading.constant = -50.0
        mStartRideContentV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height
        mPaymentStatusTableHeight.constant = mPaymentStatusTableV.contentSize.height
       
        mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
        
        mRegisterNumberTableHeight.constant = mRegisterNumberTableV.contentSize.height
        
        mCarImgV.layer.cornerRadius = 16
        mCarImgV.setShadow(color: color_shadow!)
        mCarImgBckgV.layer.borderColor = color_shadow!.cgColor
        mCarImgBckgV.layer.borderWidth = 0.5
        mCarImgBckgV.layer.cornerRadius = 16
        mCarImgBckgV.setShadow(color: color_shadow!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
    }
    
    func setupView() {
        
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mEditBtn.layer.cornerRadius = 8
        mEditBtn.setBorder(color: color_menu!, width: 1.0)
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1.0)

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        configureView()
        configureTotalPriceSteckView()
        configureReserveView(isActive: false)
        handlerTotalPrice()
    }
    
    
    func configureView() {
        
        mCarImgV.image = vehicleModel?.vehicleImg?.resizeImage(targetSize: CGSize(width:self.view.bounds.width * 0.729, height:self.view.bounds.height * 0.173))

        mCarDescriptionlb.text = vehicleModel?.vehicleType
        mFiatImgV.image = vehicleModel?.vehicleLogo
        mCarMarkLb.text = vehicleModel?.vehicleName
        
        mTowBarBckgV.isHidden = !((vehicleModel?.ifHasTowBar) == true)
        mPickUpParkingLb.text = vehicleModel?.searchModel?.pickUpLocation
        mReturnParkingLb.text = vehicleModel?.searchModel?.returnLocation
        
        mPickUpMonthLb.text = String((vehicleModel?.searchModel?.pickUpDate?.getMonth(lng: "en"))!)
        mReturnMonthLb.text = String((vehicleModel?.searchModel?.returnDate?.getMonth(lng: "en"))!)
        mPickUpTimeLb.text = vehicleModel?.searchModel?.pickUpTime?.getHour()
        mReturnTimeLb.text = vehicleModel?.searchModel?.returnTime?.getHour()
        if currentTariff == .hourly{
            mPickUpDateLb.text = String((vehicleModel?.searchModel?.pickUpTime?.getDay())!)
            mReturnDateLb.text = String((vehicleModel?.searchModel?.returnTime?.getDay())!)
        } else {
            mPickUpDateLb.text = String((vehicleModel?.searchModel?.pickUpDate?.getDay())!)
            mReturnDateLb.text = String((vehicleModel?.searchModel?.returnDate?.getDay())!)
        }
        
        
        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel!) as? [AccessoriesModel]
        mReserveInfoTableV.reloadData()
        
        mPaymentStatusTableV.statusArr = PaymentStatusData.paymentStatusModel
        mPaymentStatusTableV.reloadData()
        
        mAdditionalDriverTableV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel!) as? [MyDriversModel]
        mAdditionalDriverTableV.reloadData()
    
        mRegisterNumberTableV.reloadData()
        
        mNewPriceTableV.pricesArr = reserveViewModel.getPrices(vehicleModel: vehicleModel!) as! [PriceModel]
        mNewPriceTableV.reloadData()
    }
    
    
    func configureTotalPriceSteckView() {
        //Total price
        totalPrice = reserveViewModel.getTotalPrice(totalPrices: mNewPriceTableV.pricesArr)
        mTotalPriceStackV.mNewTotalPriceLb.text = String(format: "%.2f",totalPrice)
        if isEdited {
            mTotalPriceStackV.showOldAndNewTotalPrices(oldPrice: totalPrice, newPrice: 00.0)
        }
    }
    
    ///configure reserve view
    private func configureReserveView(isActive: Bool) {
        mStartRideContentV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:isActive ? color_reserve_start! : color_reserve_inactive_start!,
                                                  endColor:isActive ? color_reserve_end!: color_reserve_inactive_end! )
        mStartRideContentV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
        mStartRideContentV.isUserInteractionEnabled = isActive
    }
    
    func handlerTotalPrice() {
        
        mTotalPriceStackV.willCloseOldTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.7) {
                self?.mOldPriceTableHeight.constant = 0.0
            } completion: { _ in
                self?.mOldPriceTableV.isHidden = true
            }
        }
        mTotalPriceStackV.willCloseNewTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.7) {
                self?.mNewPriceTableHeight.constant = 0.0
            } completion: { _ in
                self?.mNewPriceTableV.isHidden = true
            }
        }
        mTotalPriceStackV.willOpenOldTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.7) {
                self?.mOldPriceTableV.isHidden = false
                self?.mOldPriceTableHeight.constant = self?.mOldPriceTableV.contentSize.height ?? 0.0
            }
        }
        
        mTotalPriceStackV.willOpenNewTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.7) {
                self?.mNewPriceTableV.isHidden = false
                self?.mNewPriceTableHeight.constant = self?.mNewPriceTableV.contentSize.height ?? 0.0
            }

        }
    }
    
    private func showAlert(message: String) {
        BKDAlert().showAlert(on: self, title: nil, message: message, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.confirm) { [self] in
            self.mCancelBtn.backgroundColor = .clear
        } okAction: {
            
        }
    }
    /// Animate Confirm click
    private func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()

        } completion: { _ in
           // self.checkIsUserSignIn()
        }
    }
    
    ///Will animate start ride View
    func animationStartRide() {
        self.mStartRideVLeading.constant = self.view.bounds.width - self.mStartRideContentV.bounds.width + 25
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    

    
//  /// Check user is loged in or not, and get languages if loged in
//    private func checkIsUserSignIn() {
//        reserveViewModel.isUserSignIn { [weak self] isUserSignIn in
//            guard let self = self else { return }
//
//            //WARNING:
//            self.goToPhoneVerification()
////            if !isUserSignIn {
////                self.goToSignInPage()
////            } else {
////                if self.checkPhoneNumberVerification() {
////                    self.goToResrvetionCompletedPage()
////                } else {
////
////                }
////            }
//        }
//    }
//
//    private func checkPhoneNumberVerification() -> Bool {
//        return false
//    }
    
//    /// Go to Sign in screen
//    private func goToSignInPage() {
//          let signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
//        self.navigationController?.pushViewController(signInVC, animated: true)
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
//    /// Go to reservation completed screen
//    private func goToResrvetionCompletedPage() {
//          let signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
//        self.navigationController?.pushViewController(signInVC, animated: true)
//    }
//
//    private func goToPhoneVerification() {
//        let changePhoneNumberVC = ChangePhoneNumberViewController.initFromStoryboard(name: Constant.Storyboards.changePhoneNumber)
//      self.navigationController?.pushViewController(changePhoneNumberVC, animated: true)
//    }
    
//MARK: - Actions
//MARK: -------------------
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        clickConfirm()
    }
    
    @IBAction func confirmSwipe(_ sender: UISwipeGestureRecognizer) {
        clickConfirm()
    }
    
    @IBAction func startRide(_ sender: UIButton) {
        animationStartRide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
           // self.goToReserveController()
        }
    }
    
    @IBAction func agreement(_ sender: UIButton) {
        let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
        bkdAgreementVC.delegate = self
        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mCancelBtn.backgroundColor = .clear
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mEditBtn.backgroundColor = .clear
        showAlert(message: Constant.Texts.cancelWithoutRefaund)
    }
}

 

//MARK: - BkdAgreementViewControllerDelegate
//MARK: ----------------------------
extension MyReservetionAdvancedViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
        
    }
}
