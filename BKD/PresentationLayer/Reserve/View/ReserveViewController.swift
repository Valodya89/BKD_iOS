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
    @IBOutlet weak var mConfirmV: ConfirmView!
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
        mConfirmV.mConfirmBtnLeading.constant = 0.0
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
    
    }
    
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        mTotalPriceBackgV.layer.cornerRadius = 3
        mTotalPriceBackgV.setShadow(color: color_shadow!)
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mConfirmV.needsCheck = true
        configureView()
        handlerConfirm()

    }
    
    
    func configureView() {
        PriceManager.shared.depositPrice = vehicleModel?.depositPrice

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
        //accessories
        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel!) as? [AccessoriesEditModel]
        //drivers
        self.mReserveInfoTableV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel!)
        mReserveInfoTableV.reloadData()
        
        mPriceTableV.pricesArr = PriceManager.shared.getPrices()
        mPriceTableV.reloadData()

        totalPrice = PriceManager.shared.getTotalPrice(totalPrices: mPriceTableV.pricesArr)
        mTotalPriceValueLb.text = String(format: "%.2f",totalPrice)
        vehicleModel?.totalPrice = totalPrice
        
    }
    
    
  /// Check user is loged in or not, and get languages if loged in
    private func checkIsUserSignIn() {
        reserveViewModel.isUserSignIn { [weak self] isUserSignIn in
            guard let self = self else { return }
            
            if !isUserSignIn {
                self.goToSignInPage()
            } else {
                self.mConfirmV.needsCheck = false
                self.mConfirmV.clickConfirm()
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
    
    ///Handel confirm button
    func handlerConfirm() {
        mConfirmV.willCheckConfirm = {
            self.checkIsUserSignIn()
        }

        mConfirmV.didPressConfirm = {
            self.goToAgreement(on: self,
                               agreementType: .reserve, paymentOption: nil,
                               vehicleModel: self.vehicleModel,
                               rent: nil,
                               urlString: ApplicationSettings.shared.settings?.reservationAgreementUrl)
        }
    }
    
   

}

//MARK: -- BkdAgreementViewControllerDelegate
extension ReserveViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
    }

}
 
