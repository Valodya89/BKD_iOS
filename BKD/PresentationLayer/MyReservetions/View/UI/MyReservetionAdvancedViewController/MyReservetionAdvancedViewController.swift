//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class MyReservetionAdvancedViewController: UIViewController, StoryboardInitializable {
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
    
    ///Payment status TableView
    @IBOutlet weak var mPaymentStatusTableV: PaymentStatusUITableView!
    @IBOutlet weak var mPaymentStatusTableHeight: NSLayoutConstraint!
    
    ///On ride TableView
    @IBOutlet weak var mOnRideTableV: OnRideTableView!
    @IBOutlet weak var mOnRideTableHeight: NSLayoutConstraint!
    
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
    @IBOutlet weak var mEditContentV: UIView!
    @IBOutlet weak var mAgreementBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mEditContentVHeight: UIView!
    @IBOutlet weak var mExtendReservationBtn: UIButton!
    
    ///Start ride
    @IBOutlet weak var mStartRideContentV: UIView!
    @IBOutlet weak var mStartRideBtn: UIButton!
    @IBOutlet weak var mStartRideVLeading: NSLayoutConstraint!

    
    //MARK: - Variables
    public var vehicleModel: VehicleModel?
    public var myReservationState: MyReservationState?
    public var paymentStatusArr: [PaymentStatusModel]?
    public var onRideArr: [OnRideModel]?
    public var driversArr:[MyDriversModel]?

    public var registerNumberArr:[String]?

    
    var reserveViewModel = ReserveViewModel()
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
        mEditBtn.backgroundColor = .clear
        mStartRideVLeading.constant = -50.0
        mExtendReservationBtn.layer.cornerRadius = 8
        mExtendReservationBtn.setBorder(color: color_menu!, width: 1.0)
       // mStartRideContentV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height
        mPaymentStatusTableHeight.constant = mPaymentStatusTableV.contentSize.height
       
        mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
        
        mRegisterNumberTableHeight.constant = mRegisterNumberTableV.contentSize.height
        
        mOnRideTableHeight.constant = mOnRideTableV.contentSize.height
        
        mCarImgV.layer.cornerRadius = 16
        mCarImgV.setShadow(color: color_shadow!)
        mCarImgBckgV.layer.borderColor = color_shadow!.cgColor
        mCarImgBckgV.layer.borderWidth = 0.5
        mCarImgBckgV.layer.cornerRadius = 16
        mCarImgBckgV.setShadow(color: color_shadow!)
        configureStartRideView(isActive: false)

    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
       // configureStartRideView(isActive: false)
    }
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mEditBtn.layer.cornerRadius = 8
        mEditBtn.setBorder(color: color_menu!, width: 1.0)
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1.0)
                
        configureView()
        configureOnRideTableView()
        configureTotalPriceSteckView()
        handlerTotalPrice()
        
    }
    
    
    func configureView() {
//        //Car descriptions
//        mCarImgV.image = vehicleModel?.vehicleImg?.resizeImage(targetSize: CGSize(width:self.view.bounds.width * 0.729, height:self.view.bounds.height * 0.173))
//        mCarDescriptionlb.text = vehicleModel?.vehicleType
//        mFiatImgV.image = vehicleModel?.vehicleLogo
//        mCarMarkLb.text = vehicleModel?.vehicleName
//        mTowBarBckgV.isHidden = !((vehicleModel?.ifHasTowBar) == true)
//        //Rent descriptions
//        mPickUpParkingLb.text = vehicleModel?.searchModel?.pickUpLocation
//        mReturnParkingLb.text = vehicleModel?.searchModel?.returnLocation
//        mPickUpMonthLb.text = String((vehicleModel?.searchModel?.pickUpDate?.getMonth(lng: "en"))!)
//        mReturnMonthLb.text = String((vehicleModel?.searchModel?.returnDate?.getMonth(lng: "en"))!)
//        mPickUpTimeLb.text = vehicleModel?.searchModel?.pickUpTime?.getHour()
//        mReturnTimeLb.text = vehicleModel?.searchModel?.returnTime?.getHour()
//        if currentTariff == .hourly{
//            mPickUpDateLb.text = String((vehicleModel?.searchModel?.pickUpTime?.getDay())!)
//            mReturnDateLb.text = String((vehicleModel?.searchModel?.returnTime?.getDay())!)
//        } else {
//            mPickUpDateLb.text = String((vehicleModel?.searchModel?.pickUpDate?.getDay())!)
//            mReturnDateLb.text = String((vehicleModel?.searchModel?.returnDate?.getDay())!)
//        }
//
        //Reservation informations
        if registerNumberArr != nil {
            mRegisterNumberTableV.registerNumberArr =  registerNumberArr
            mRegisterNumberTableV.reloadData()
        }

        if paymentStatusArr != nil {
            mPaymentStatusTableV.statusArr = paymentStatusArr
            mPaymentStatusTableV.reloadData()
            handlerPayment()
        }
        

        guard let vehicleModel = vehicleModel else {
            return
        }

        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel) as? [AccessoriesModel]
        mReserveInfoTableV.reloadData()
                
        mAdditionalDriverTableV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel) as? [MyDriversModel]
        mAdditionalDriverTableV.reloadData()
            
        mNewPriceTableV.pricesArr = reserveViewModel.getPrices(vehicleModel: vehicleModel) as! [PriceModel]
        mNewPriceTableV.reloadData()
        
    }
    
    ///Configure OnRide table view
    func configureOnRideTableView() {
        if myReservationState == .stopRide {
            mOnRideTableV.onRideArr = onRideArr
            mOnRideTableV.reloadData()
            handlerOnRide()
            
            
            mAdditionalDriverTableV.drivers = [MyDriversModel(fullname: "Name Surname", licenciNumber: "XXXXXXXX", price: 0.0, isSelected: false, totalPrice: 0.0)]
            mAdditionalDriverTableV.reloadData()

            mTotalPriceStackV.mNewTotalPriceContentV.isHidden = true
            mEditBtn.isHidden = true
            mCancelBtn.isHidden = true
            mExtendReservationBtn.isHidden = false
        }
    }
    
    func configureReservationStatus() {
        switch myReservationState {
        case .startRide: break
        case .payRentalPrice:break
        case .payDistancePrice:break
        case .maykePayment:break
        case .stopRide: break
        case .none:
            break
        }
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
    private func configureStartRideView(isActive: Bool) {
//        mStartRideContentV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:isActive ? color_reserve_start! : color_reserve_inactive_start!,
//                                                  endColor:isActive ? color_reserve_end!: color_reserve_inactive_end! )
//        mStartRideContentV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
//        mStartRideContentV.isUserInteractionEnabled = isActive
        
        
        mStartRideContentV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor: color_dark_register!,endColor: color_dark_register!.withAlphaComponent(0.85) )
        mStartRideContentV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    
    ///Handel Total price View
    func handlerTotalPrice() {
        
        mTotalPriceStackV.willCloseOldTotalPrice = { [weak self] in
            self?.mOldPriceTableHeight.constant = 0.0
            UIView.animate(withDuration: 0.3) {
                self?.mOldPriceTableV.isHidden = true
                self?.view.layoutIfNeeded()
            }
        }
        mTotalPriceStackV.willCloseNewTotalPrice = { [weak self] in
            
            self?.mNewPriceTableHeight.constant = 0.0
            UIView.animate(withDuration: 0.3) {
                self?.mNewPriceTableV.isHidden = true
                self?.view.layoutIfNeeded()
            }
        }
        
        mTotalPriceStackV.willOpenOldTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.mOldPriceTableV.isHidden = false
                self?.mOldPriceTableHeight.constant = self?.mOldPriceTableV.contentSize.height ?? 0.0
            }
        }
        
        mTotalPriceStackV.willOpenNewTotalPrice = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.mNewPriceTableV.isHidden = false
                self?.mNewPriceTableHeight.constant = self?.mNewPriceTableV.contentSize.height ?? 0.0
            }

        }
    }
    
    private func showAlert(message: String) {
        BKDAlert().showAlert(on: self, title: message, message: nil, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.confirm) { [self] in
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
            self.goToAgreement(isAdvanced: false)
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
    
    ///Open edit reservation screen
    private func goToEditReservation(isExtendReservation: Bool) {
        
        let editReservationVC = EditReservationViewController.initFromStoryboard(name: Constant.Storyboards.editReservation)
        editReservationVC.delegate = self
        editReservationVC.isextendReservation = isExtendReservation
        self.navigationController?.pushViewController(editReservationVC, animated: true)
    }
    
    
    ///Open start ride screen
    private func goToStartRide() {
        let startRideVC = VehicleCheckViewController.initFromStoryboard(name: Constant.Storyboards.vehicleCheck)
        self.navigationController?.pushViewController(startRideVC, animated: true)
    }

    ///Open agree Screen
    private func goToAgreement(isAdvanced:Bool) {
        
        let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
        bkdAgreementVC.delegate = self
        bkdAgreementVC.isAdvanced = isAdvanced
        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
    }
    
    ///Go to PayLater ViewController
   private func goToPayLater() {
        let payLaterVC = PayLaterViewController.initFromStoryboard(name: Constant.Storyboards.payLater)
        self.navigationController?.pushViewController(payLaterVC, animated: true)
    }
    
    
    ///Go to Add damage ViewController
    private func goToAddDamage() {
        let addDamageVC = AddDamageViewController.initFromStoryboard(name: Constant.Storyboards.addDamage)
        self.navigationController?.pushViewController(addDamageVC, animated: true)
    }
    
    ///Update start ride button
    private func updateStartRide(isActive: Bool) {
        mStartRideContentV.isUserInteractionEnabled = isActive
        mStartRideContentV.alpha = isActive ? 1 : 0.8
    }
    
    
    ///Show alert for switch driver
    private func showAlertForSwitchDriver() {
        BKDAlert().showAlert(on: self, title: String(format: Constant.Texts.confirmSwitchDriver, "Name Surname") ,
                             message: nil,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm, cancelAction: nil) {
            
        }
        
    }
    
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
            self.goToStartRide()
        }
    }
    
    @IBAction func agreement(_ sender: UIButton) {
        goToAgreement(isAdvanced: false)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mCancelBtn.backgroundColor = .clear
        goToEditReservation(isExtendReservation: false)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mEditBtn.backgroundColor = .clear
        showAlert(message: Constant.Texts.cancelWithoutRefaund)
    }
    
    @IBAction func extentReservation(_ sender: UIButton) {
        
        sender.backgroundColor = color_menu!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            goToEditReservation(isExtendReservation: true)
        }
    }
    
    
    ///Handler payment tableCell´s button
    func handlerPayment() {
        mPaymentStatusTableV.didPressPayment = { isPayLater in
            if isPayLater {
                self.goToPayLater()
            } else {
                self.goToAgreement(isAdvanced: true)
            }
        }
    }
    
    ///Handler on ride tableCell´s buttons
    func handlerOnRide() {
        mOnRideTableV.didPressAddDamage = {
            self.goToAddDamage()
        }
         
        mOnRideTableV.didPressSwitchDriver = {
            self.showAlertForSwitchDriver()
        }
    }
}

 

//MARK: - BkdAgreementViewControllerDelegate
//MARK: ----------------------------
extension MyReservetionAdvancedViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
        updateStartRide(isActive: true)
    }
}

//MARK: - EditReservationDelegate
//MARK: ----------------------------
extension MyReservetionAdvancedViewController: EditReservationDelegate {
    func didPressCheckPrice(isEdit: Bool) {
        mTotalPriceStackV.mOldTotalPriceContentV.isHidden = !isEdit
        mConfirmBckgV.isHidden = !isEdit
        mStartRideContentV.isHidden = isEdit
        mEditContentV.isHidden = isEdit
        
        if isEdit {
            mTotalPriceStackV.mNewTotalPriceTitleLb.text = Constant.Texts.newTotalPrice
        } else {
            mTotalPriceStackV.mNewTotalPriceTitleLb.text = Constant.Texts.totalPrice
        }
    }
}
