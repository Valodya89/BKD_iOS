//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class MyReservetionAdvancedViewController: BaseViewController {

    
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
    
    ///Switch driver
    @IBOutlet weak var mSwitchDriverTbV: SwitchDriversTableView!
    @IBOutlet weak var mSwitchDriversBottom: NSLayoutConstraint!
    @IBOutlet weak var mSwitchDriversTbHeight: NSLayoutConstraint!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mVissualEffectV: UIVisualEffectView!
    
    //MARK: - Variables
    public var vehicleModel: VehicleModel?
    public var myReservationState: MyReservationState?
    public var paymentStatusArr: [PaymentStatusModel]?
    public var onRideArr: [OnRideModel]?
    public var driversArr:[MyDriversModel]?
    public var registerNumberArr:[String]?
    public var currRent: Rent?
    
    lazy var myReservAdvancedViewModel = MyReservetionAdvancedViewModel()
    lazy var myReservationViewModel = MyReservationViewModel()
    var reserveViewModel = ReserveViewModel()
    var currentTariff: TariffState = .hourly
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

        if mSwitchDriverTbV.contentSize.height > 260 {
            mSwitchDriversTbHeight.constant = 260
        } else {
            mSwitchDriversTbHeight.constant = mSwitchDriverTbV.contentSize.height
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       // configureStartRideView(isActive: false)
    }
    
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mEditBtn.layer.cornerRadius = 8
        mEditBtn.setBorder(color: color_menu!, width: 1.0)
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1.0)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mSwitchDriverTbV.switchDriversDelegate = self
        
        configureUI()
        configureOnRide()
        configureTotalPriceSteckView()
        handlerTotalPrice()
        
    }
    
  ///Configure UI
    func configureUI() {
        //Car info
        let currCar: CarsModel? = ApplicationSettings.shared.allCars?.filter( {$0.id == (currRent?.carDetails.id ?? "")}).first
        if currCar != nil {
            mCarImgV.sd_setImage(with:  currCar!.image.getURL() ?? URL(string: ""), placeholderImage: nil)
            mTowBarBckgV.isHidden = !currCar!.towbar
            mFiatImgV.sd_setImage(with:  currCar!.logo?.getURL() ?? URL(string: ""), placeholderImage: nil)
            
            mCarMarkLb.text = currCar!.name
            mCarDescriptionlb.text = (ApplicationSettings.shared.carTypes?.filter( {$0.id == currCar!.type} ).first)?.name
        }
        
        //Pick up location
        if currRent?.pickupLocation.type == Constant.Keys.custom,
           let pickupLocation = currRent?.pickupLocation.customLocation {
            mPickUpParkingLb.text = pickupLocation.name
        } else if let pickupParkin = currRent?.pickupLocation.parking {
            mPickUpParkingLb.text = pickupParkin.name
        }
        //Return location
        if currRent?.returnLocation.type == Constant.Keys.custom,
           let returnLocation = currRent?.returnLocation.customLocation {
            mReturnParkingLb.text = returnLocation.name
        } else if let returnParkin = currRent?.returnLocation.parking {
            mReturnParkingLb.text = returnParkin.name
        }
        
        //Date
        let startDate = Date().doubleToDate(doubleDate: currRent?.startDate ?? 0.0)
        let endDate = Date().doubleToDate(doubleDate: currRent?.endDate ?? 0.0)
        mPickUpDateLb.text = startDate.getDay()
        mPickUpMonthLb.text =  startDate.getMonth(lng: "en")
        mPickUpTimeLb.text = startDate.getHour()
        mReturnDateLb.text = endDate.getDay()
        mReturnMonthLb.text = endDate.getMonth(lng: "en")
        mReturnTimeLb.text = endDate.getHour()
       
        //Register number
        mRegisterNumberTableV.registerNumberArr = registerNumberArr
        
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
        
        //Accessories
        if (currRent?.accessories?.count ?? 0) > 0 {
            myReservAdvancedViewModel.getRentAccessories(rent: currRent!, complition: { result in
                
                guard let result = result else {return}
                self.mReserveInfoTableV.accessories = result
                self.mReserveInfoTableV.reloadData()
                self.mReserveTableHeight.constant = self.mReserveInfoTableV.contentSize.height
            })
    }

        //Additional drivers list
        if (currRent?.additionalDrivers?.count ?? 0) > 0 {
            mAdditionalDriverTableV.drivers =  currRent?.additionalDrivers
            mAdditionalDriverTableV.reloadData()
            mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
        }
        
        
        
            
//        //New price
//        mNewPriceTableV.pricesArr = PriceManager.shared.getPrices()
//        mNewPriceTableV.reloadData()
        
    }
    
    ///Configure on ride case
    func configureOnRide() {
        if myReservationState == .stopRide {
            mOnRideTableV.rent = currRent
            mOnRideTableV.onRideArr = onRideArr
            mOnRideTableV.reloadData()
            handlerOnRide()
            
            mTotalPriceStackV.mNewTotalPriceContentV.isHidden = true
            mEditBtn.isHidden = true
            mCancelBtn.isHidden = true
            mExtendReservationBtn.isHidden = false
            mStartRideBtn.setTitle(Constant.Texts.stopRide, for: .normal)
        }
    }
    
    
    ///Configure pay dstance price
    func configurePayDistancePrice() {
        
        if myReservationState == .payDistancePrice {
            mStartRideContentV.isHidden = true
            mEditContentV.isHidden = true
        }
    }
    
    func configureReservationStatus() {
        switch myReservationState {
        case .startRide: break
        case .payRentalPrice:break
        case .payDistancePrice:break
        case .maykePayment:break
        case .stopRide: break
        default : break
        }
    }
    
    func configureTotalPriceSteckView() {
        //Total price
        totalPrice = PriceManager.shared.getTotalPrice(totalPrices: mNewPriceTableV.pricesArr)
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
    
    ///Switch driver
    func changeDriver(driverId: String ) {
        myReservationViewModel.changeDriver(rentId: currRent?.id ?? "", driverId: driverId) { result in
            guard let rent =  result else {return}
            self.hideSwitchTable()
            self.currRent = rent
            
        }
    }
    
    ///Handel Total price View
    func handlerTotalPrice() {
        
        mTotalPriceStackV.willCloseNewTotalPrice = { [weak self] in
            
            self?.mNewPriceTableHeight.constant = 0.0
            UIView.animate(withDuration: 0.3) {
                self?.mNewPriceTableV.isHidden = true
                self?.view.layoutIfNeeded()
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
        BKDAlert().showAlert(on: self,
                             message: message,
                             cancelTitle: Constant.Texts.back,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
            
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
    private func goToEditReservation(isExtendReservation: Bool, accessories: [AccessoriesEditModel]?) {
        
        let editReservationVC = EditReservationViewController.initFromStoryboard(name: Constant.Storyboards.editReservation)
        editReservationVC.isExtendReservation = isExtendReservation
        editReservationVC.currRent = currRent
        editReservationVC.accessories = accessories
        self.navigationController?.pushViewController(editReservationVC, animated: true)
    }
    
    
    
    ///Update start ride button
    private func updateStartRide(isActive: Bool) {
        
        if isActive && registerNumberArr?.count ?? 0 > 0 {
            mStartRideContentV.isUserInteractionEnabled = isActive
            mStartRideContentV.alpha = isActive ? 1 : 0.75
            
        }
    }
    
    //MARK: -- Switch driver methods
    ///Show switch drivers table view
    private func animateSwitchDriversTable(additionalDrivers: [DriverToRent] ) {

        self.mSwitchDriverTbV.switchDriversList = additionalDrivers
        self.mSwitchDriverTbV.reloadData()
        self.mSwitchDriverTbV.isScrollEnabled = false
        mVissualEffectV.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = 10
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.mSwitchDriverTbV.contentSize.height >  self.mSwitchDriversTbHeight.constant {
                self.mSwitchDriverTbV.isScrollEnabled = true
            }
        }
    }

    ///Hide switch drivers table view
    private func hideSwitchTable(){
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = -500
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        } completion: { _ in
            self.mVissualEffectV.isHidden = true
        }
    }
    
    //MARK: -- Alerts
    ///Show alert for switch driver
    private func showAlertForSwitchDriver(driver: DriverToRent?) {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.confirmSwitchDriver, driver?.getFullName() ?? ""),
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
            self.changeDriver(driverId: driver?.id ?? "")
        }
    }
        
        ///Show alert for inactive start ride
        private func showAlertForInactiveStartRide() {
            BKDAlert().showAlert(on: self, message: Constant.Texts.activeStartRide, cancelTitle: nil, okTitle: Constant.Texts.gotIt, cancelAction: nil) {
            }
    }
    
    
//MARK: - Actions
//MARK: -------------------
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func startRideSwipe(_ sender: UISwipeGestureRecognizer) {
        animationStartRide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            self.goToVehicleCheck(rent: nil)
        }
    }
    
    @IBAction func startRide(_ sender: UIButton) {
        animationStartRide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            self.goToVehicleCheck(rent: nil)
        }
    }
    
    @IBAction func agreement(_ sender: UIButton) {
        self.goToAgreement(on: self,
                           agreementType: .none,
                           vehicleModel: nil,
                           urlString: nil)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mCancelBtn.backgroundColor = .clear
        goToEditReservation(isExtendReservation: false, accessories: self.mReserveInfoTableV.accessories)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        mEditBtn.backgroundColor = .clear
        showAlert(message: Constant.Texts.cancelWithoutRefaund)
    }
    
    @IBAction func extentReservation(_ sender: UIButton) {
        sender.setClickColor(color_menu!, titleColor: sender.titleColor(for: .normal)!)
        sender.backgroundColor = color_menu!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            goToEditReservation(isExtendReservation: true, accessories: self.mReserveInfoTableV.accessories)
        }
    }
    
    @IBAction func switchDriverSwipe(_ sender: UISwipeGestureRecognizer) {
        hideSwitchTable()
    }
    
    ///Handler payment tableCell´s button
    func handlerPayment() {
        mPaymentStatusTableV.didPressPayment = { isPayLater in
            if isPayLater {
                self.goToPayLater()
            } else {
                self.goToAgreement(on: self,
                                   agreementType: .advanced,
                                   vehicleModel: nil,
                                   urlString: nil)
            }
        }
    }
    
    ///Handler on ride tableCell´s buttons
    func handlerOnRide() {
        mOnRideTableV.didPressAddDamage = {
            self.goToAddDamage(rent: nil)
        }
         
        mOnRideTableV.didPressSwitchDriver = {
            let driversList =  self.myReservationViewModel.getAdditionalDrives(rent: self.currRent!)
            if driversList.count == 1 {
                self.showAlertForSwitchDriver(driver: driversList[0])
            } else {
                self.animateSwitchDriversTable(additionalDrivers: driversList)
            }
        }
        
        mOnRideTableV.didPressMap = { index in
            self.goToSeeMap(parking: self.currRent?.returnLocation.parking, customLocation: self.currRent?.returnLocation.customLocation)
           
        }
    }
}

 

//MARK: -- BkdAgreementViewControllerDelegate
extension MyReservetionAdvancedViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
        if registerNumberArr?.count ?? 0 > 0 {
            updateStartRide(isActive: true)
        }
    }
}


//MARK: -- SwitchDriversTableViewDelegate
extension MyReservetionAdvancedViewController: SwitchDriversTableViewDelegate {
    
    func didPressCell(index: Int, item: DriverToRent) {
        showAlertForSwitchDriver(driver: item)
    }
}

