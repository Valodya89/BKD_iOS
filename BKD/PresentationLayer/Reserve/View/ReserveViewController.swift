//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class ReserveViewController: BaseViewController {
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
    
   //Total Price
    @IBOutlet weak var mTotalPriceBackgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mTotalPriceValueLb: UILabel!
    
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
    @IBOutlet weak var mPriceTableV: PriceTableView!
    
    @IBOutlet weak var mPriceTableHeight: NSLayoutConstraint!
    
    //MARK: - Variables

    var reserveViewModel = ReserveViewModel()
    public var vehicleModel: VehicleModel?
    public var currentTariffOption: TariffSlideModel?
    var rent: Rent?
    var currentTariff: TariffState = .hourly
    var lastContentOffset:CGFloat = 0.0
    var totalPrice: Double = 0.0
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mConfirmLeading.constant = 0.0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height
        mPriceTableHeight.constant = mPriceTableV.contentSize.height
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
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mTotalPriceBackgV.layer.cornerRadius = 3
        mTotalPriceBackgV.setShadow(color: color_shadow!)
        mRentInfoBckgV.setShadow(color: color_shadow!)
        configureView()
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
            
        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel!) as? [AccessoriesEditModel]
        
        self.mReserveInfoTableV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel!)
        mReserveInfoTableV.reloadData()
        
        mPriceTableV.pricesArr = PriceManager.shared.getPrices()
        mPriceTableV.reloadData()

        totalPrice = PriceManager.shared.getTotalPrice(totalPrices: mPriceTableV.pricesArr)
        mTotalPriceValueLb.text = String(format: "%.2f",totalPrice)
        vehicleModel?.totalPrice = totalPrice
        
    }
    
    
//    ///Add reservation
//    private func addReservation() {
//        reserveViewModel.addRent(vehicleModel: vehicleModel ?? VehicleModel()) { result, error in
//                if let _ = error {
//                    self.showAlertSignIn()
//                } else if result == nil {
//                    self.showAlert()
//                } else {
//                    self.rent = result
//                    self.vehicleModel?.rent = result!
//                   // self.clickConfirm()
//                }
//        }
//    }
    
    /// Animate Confirm click
    private func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()

        } completion: { _ in
            self.goToAgreement(on: self,
                               agreementType: .reserve,
                               vehicleModel: self.vehicleModel,
                               urlString: ApplicationSettings.shared.settings?.reservationAgreementUrl)
//            self.isAgree ? self.goToPhoneVerification() :         self.addReservation()
        }
    }
    
    
  /// Check user is loged in or not, and get languages if loged in
    private func checkIsUserSignIn() {
        reserveViewModel.isUserSignIn { [weak self] isUserSignIn in
            guard let self = self else { return }
            
            if !isUserSignIn {
                self.goToSignInPage()
            } else {
                self.clickConfirm()
            }
        }
    }
    
    private func checkPhoneNumberVerification() -> Bool {
        return false
    }
    

//MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        checkIsUserSignIn()
        
    }
    
    @IBAction func confirmSwipe(_ sender: UISwipeGestureRecognizer) {
        checkIsUserSignIn()
        
    }

}

//MARK: -- BkdAgreementViewControllerDelegate
extension ReserveViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
    }

}
 
