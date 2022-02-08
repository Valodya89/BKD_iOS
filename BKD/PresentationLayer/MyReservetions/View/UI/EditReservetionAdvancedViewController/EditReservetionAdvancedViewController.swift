//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class EditReservetionAdvancedViewController: BaseViewController {
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
    @IBOutlet weak var mConfirmV: ConfirmView!
    @IBOutlet weak var mConfirmHeight: NSLayoutConstraint!
    
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


    //MARK: - Variables
    lazy var editReservAdvancedVM = EditReservetionAdvancedViewModel()
    public var currRent: Rent?
    public var accessories: [AccessoriesEditModel]?
    public var myReservationState: MyReservationState?
    public var paymentStatusArr: [PaymentStatusModel]?
    public var searchModel: SearchModel?
    //public var onRideArr: [OnRideModel]?
    //public var driversArr:[MyDriversModel]?
   // public var registerNumberArr:[String]?
    public var editReservationModel = EditReservationModel()
    
    var reserveViewModel = ReserveViewModel()
   // var currentTariff: TariffState = .hourly
    //var lastContentOffset:CGFloat = 0.0
    //var totalPrice: Double = 0.0
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mConfirmV.initConfirm()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height
        mPaymentStatusTableHeight.constant = mPaymentStatusTableV.contentSize.height
       
        mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
        
        mRegisterNumberTableHeight.constant = mRegisterNumberTableV.contentSize.height
        
        mOnRideTableHeight.constant = mOnRideTableV.contentSize.height
        mConfirmHeight.constant = height42
        mCarImgV.layer.cornerRadius = 16
        mCarImgV.setShadow(color: color_shadow!)
        mCarImgBckgV.layer.borderColor = color_shadow!.cgColor
        mCarImgBckgV.layer.borderWidth = 0.5
        mCarImgBckgV.layer.cornerRadius = 16
        mCarImgBckgV.setShadow(color: color_shadow!)
        mTotalPriceStackV.mOldTotalPriceContentV.isHidden = false
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       // configureStartRideView(isActive: false)
    }
    
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mRentInfoBckgV.setShadow(color: color_shadow!)
                
        configureView()
        handlerTotalPrice()
        handlerConfirm()
        configureUI()
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
//        if registerNumberArr != nil {
//            mRegisterNumberTableV.registerNumberArr =  registerNumberArr
//            mRegisterNumberTableV.reloadData()
//        }

        if paymentStatusArr != nil {
            mPaymentStatusTableV.statusArr = paymentStatusArr
            mPaymentStatusTableV.reloadData()
            handlerPayment()
        }
        

//        guard let vehicleModel = vehicleModel else {
//            return
//        }
//
//        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel) as? [AccessoriesEditModel]
//        mReserveInfoTableV.reloadData()
                
//        //Additional drivers list
//        if (currRent?.additionalDrivers?.count ?? 0) > 0 {
//            mAdditionalDriverTableV.drivers =  currRent?.additionalDrivers
//            mAdditionalDriverTableV.reloadData()
//        }
            
        mNewPriceTableV.pricesArr = PriceManager.shared.getPrices()
        mNewPriceTableV.reloadData()
        
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
          let pickUpLocation = editReservationModel.pickupLocation
          if pickUpLocation?.type == Constant.Keys.custom,
             let pickupCustomLocation = pickUpLocation?.customLocation {
              mPickUpParkingLb.text = pickupCustomLocation.name
          } else if let pickupParkin = pickUpLocation?.parking {
              mPickUpParkingLb.text = pickupParkin.name
          }
          //Return location
          let returnLocation = editReservationModel.returnLocation
          if returnLocation?.type == Constant.Keys.custom,
             let returnCustomLocation = returnLocation?.customLocation {
              mReturnParkingLb.text = returnCustomLocation.name
          } else if let returnParking = returnLocation?.parking {
              mReturnParkingLb.text = returnParking.name
          }
          
          //Date
          let startDate = Date().doubleToDate(doubleDate: editReservationModel.startDate ?? 0.0)
          let endDate = Date().doubleToDate(doubleDate: editReservationModel.endDate ?? 0.0)
          mPickUpDateLb.text = startDate.getDay()
          mPickUpMonthLb.text =  startDate.getMonth(lng: "en")
          mPickUpTimeLb.text = startDate.getHour()
          mReturnDateLb.text = endDate.getDay()
          mReturnMonthLb.text = endDate.getMonth(lng: "en")
          mReturnTimeLb.text = endDate.getHour()
         
          //Register number
         // mRegisterNumberTableV.registerNumberArr = registerNumberArr
          //Reservation informations
//          if registerNumberArr != nil {
//              mRegisterNumberTableV.registerNumberArr =  registerNumberArr
//              mRegisterNumberTableV.reloadData()
//          }
          if paymentStatusArr != nil {
              mPaymentStatusTableV.statusArr = paymentStatusArr
              mPaymentStatusTableV.reloadData()
              handlerPayment()
          }
          
          //Accessories
          if editReservationModel.accessories != nil {
                  accessories = editReservAdvancedVM.getEditedAccessories(editAccessories: editReservationModel.accessories ?? [])
          }
          if accessories != nil {
              self.mReserveInfoTableV.accessories = accessories
              self.mReserveInfoTableV.reloadData()
              self.mReserveTableHeight.constant = self.mReserveInfoTableV.contentSize.height
          }

          //Additional drivers list
          if editReservationModel.additionalDrivers == nil {
              if (currRent?.additionalDrivers?.count ?? 0) > 0 {
                  mAdditionalDriverTableV.drivers =  currRent?.additionalDrivers
              }
          } else {
              mAdditionalDriverTableV.drivers =  editReservationModel.additionalDrivers
          }
          mAdditionalDriverTableV.reloadData()
          mAdditionalDriverTableHeight.constant = mAdditionalDriverTableV.contentSize.height
      }
   
   
//    ///Configure reservation status
//    func configureReservationStatus() {
//        switch myReservationState {
//        case .startRide: break
//        case .payRentalPrice:break
//        case .payDistancePrice:break
//        case .maykePayment:break
//        case .stopRide: break
//        default : break
//        }
//    }
    
    ///Update reservation
//    func updateReservation() {
//        editReservAdvancedVM.updateRent(rentId: currRent?.id ?? "", editReservationModel: editReservationModel, searchModel: searchModel ?? SearchModel()) { result in
//            guard let rent = result else {return}
//            
//        }
//    }
    
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
    
    
    
    //MARK: -- Alerts
    private func showAlert(message: String) {
        BKDAlert().showAlert(on: self,
                             message: message,
                             cancelTitle: Constant.Texts.back,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
            
        }
    }
    
    
    ///Show alert for switch driver
    private func showAlertForSwitchDriver() {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.confirmSwitchDriver, "Name Surname"),
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
            
        }
        
    }
    
//MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func handlerConfirm() {
        mConfirmV.didPressConfirm = { [self] in
         
            let bkdAgreementVC = BkdAgreementViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
            bkdAgreementVC.agreementType = .editAdvanced
            bkdAgreementVC.currRent = currRent
            bkdAgreementVC.searchModel = searchModel
            bkdAgreementVC.editReservationModel = editReservationModel
            self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
        }
    }
    
    
    ///Handler payment tableCell´s button
    func handlerPayment() {
        mPaymentStatusTableV.didPressPayment = { isPayLater in
            if isPayLater {
                self.goToPayLater(rent: self.currRent )
            } else {
                self.goToAgreement(on: self,
                                   agreementType: .editAdvanced,
                                   vehicleModel: nil,
                                   rent: self.currRent,
                                   urlString: nil)
            }
        }
    }
    

}


 
////MARK: - EditReservationDelegate0
////MARK: ----------------------------
//extension MyReservetionAdvancedViewController: EditReservationDelegate {
//    func didPressCheckPrice(isEdit: Bool) {
//        mTotalPriceStackV.mOldTotalPriceContentV.isHidden = !isEdit
//        mConfirmBckgV.isHidden = !isEdit
//        mStartRideContentV.isHidden = isEdit
//        mEditContentV.isHidden = isEdit
//        
//        if isEdit {
//            mTotalPriceStackV.mNewTotalPriceTitleLb.text = Constant.Texts.newTotalPrice
//        } else {
//            mTotalPriceStackV.mNewTotalPriceTitleLb.text = Constant.Texts.totalPrice
//        }
//    }
//}

