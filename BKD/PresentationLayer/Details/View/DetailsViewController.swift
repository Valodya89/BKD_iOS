//
//  DetailsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

enum Search {
    case date
    case time
    case location
    case customLocation
}

var additionalAccessories: [AccessoriesModel] = AccessoriesData.accessoriesModel
var additionalDrivers: [MyDriversModel] = MyDriversData.myDriversModel

class DetailsViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Outlet
    
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarLogoImgV: UIImageView!
    @IBOutlet weak var mCarDetailLb: UILabel!
    @IBOutlet weak var carPhotosView: CarPhotosView!
    @IBOutlet weak var mCarInfoV: CarInfoView!

    @IBOutlet weak var mDetailsAndTailLiftV: DetailsAndTailLiftView!
    
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mDetailsTbV: DetailsTableView!
    @IBOutlet weak var mTariffCarouselV: TariffCarouselView!
    @IBOutlet weak var mDetailsTableBckgV: UIView!
    @IBOutlet weak var mTailLiftTbV: TailLiftTableView!
    @IBOutlet weak var mTailLiftTableBckgV: UIView!
    
    @IBOutlet weak var mTailLiftBckgV: UIView!
    @IBOutlet weak var mDetailsTbVHeight: NSLayoutConstraint!
    @IBOutlet weak var mTailLiftTbVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mTailLiftBottom: NSLayoutConstraint!
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mSearchWithValueStackV: SearchWithValueView!
    @IBOutlet weak var mSearchV: SearchView!
    @IBOutlet weak var mReserveBckgV: UIView!
    @IBOutlet weak var mReserveBtn: UIButton!
 
    @IBOutlet weak var mDetailAndTailLiftBottom: NSLayoutConstraint!
    @IBOutlet weak var mReserveLeading: NSLayoutConstraint!
    @IBOutlet weak var mDetailHeight: NSLayoutConstraint!
    
    ///Compare
    @IBOutlet weak var mCompareContentV: UIView!
    
    //MARK: - Varables
    private lazy  var tariffSlideVC = TariffSlideViewController.initFromStoryboard(name: Constant.Storyboards.details)
    
    let detailsViewModel:DetailsViewModel = DetailsViewModel()
    var workingTimes: WorkingTimes?
    var tariffSlideList:[TariffSlideModel]?
    var tariffs: [Tariff]?

    
    var pickerState: DatePicker?
    var pickerList: [String]?
    let pickerV = UIPickerView()    

    var searchModel:SearchModel = SearchModel()
    var vehicleModel:VehicleModel?
    
    var isSearchEdit = false
    var isClickMore = false
    var currentTariff: TariffState = .hourly
    var search: Search = .date
    var currentTariffOptionIndex: Int = 0
    
    var datePicker = UIDatePicker()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    
    private let scrollPadding: CGFloat = 60
    private let tableAnimationDuration = 0.5

    private  var tariffSlideY: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var previousContentPosition: CGPoint?
    private var scrollContentHeight: CGFloat = 0.0
    private var isScrolled = false
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setScrollVoiewHeight()
        setTableViewsHeight()
        setTariffSlideViewFrame()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mReserveLeading.constant = -50.0
        mReserveBckgV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
        mSearchV.animateLocationList(isShow: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureReserveView(isActive: mReserveBckgV.isUserInteractionEnabled)
    }
    
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        workingTimes = ApplicationSettings.shared.workingTimes
        mCompareContentV.layer.cornerRadius = 8

        if isSearchEdit {
            mSearchWithValueStackV.searchModel = searchModel
            mSearchWithValueStackV.setupView()
            mTariffCarouselV.vehicleModel = vehicleModel
            mTariffCarouselV.tariffCarousel.currentItemIndex = 4
            mTariffCarouselV.tariffCarousel.reloadData()
            currentTariff = .flexible
        }
        
        configureViews()
        setDetailDatas()
        configureTransparentView()
        configureDelegates()
        addTariffSliedView()
        goToLocationController()
        getTariffList()

        
    }
    
    /// Set height of scroll view
    func setScrollVoiewHeight() {
        if scrollContentHeight == 0.0 {
            // will show only tariff cards
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height
            mCompareContentV.isHidden = false
        }
        if isSearchEdit && self.mSearchV.isHidden  {// will show tariff cards and search edit view
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchWithValueStackV.bounds.height
            mCompareContentV.isHidden = true

        } else if !self.mSearchV.isHidden { // will show tariff cards and search view
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchV.bounds.height
            mCompareContentV.isHidden = true

        }
        mScrollV.contentSize.height = scrollContentHeight
    }
    
    
    /// set height to details or tailLift tableView
    func  setTableViewsHeight() {
        if (vehicleModel?.detailList?.count) ?? 0 > 11{
            mDetailsTbVHeight.constant = 11 * detail_cell_height
        } else {
            mDetailsTbVHeight.constant = CGFloat(vehicleModel?.detailList?.count ?? 0) * detail_cell_height
        }
        mDetailsTbV.frame.size = CGSize(width: mDetailsTbV.frame.size.width, height: mDetailsTbVHeight.constant)
        self.view.layoutIfNeeded()
        if vehicleModel?.tailLiftList?.count ?? 0 > 10 {
            mTailLiftTbVHeight.constant = 10 * tailLift_cell_height
        } else {
            mTailLiftTbVHeight.constant = CGFloat(vehicleModel?.tailLiftList?.count ?? 0) * tailLift_cell_height
        }
    }
    
    
    ///Set frame to Tariff Slide View
    func setTariffSlideViewFrame() {
        var bottomPadding:CGFloat  = 0
        let tariffSlideHeight = self.view.bounds.height * 0.08168
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            bottomPadding = window.safeAreaInsets.bottom
        }
        if UIScreen.main.nativeBounds.height <= 1334 {
            bottomPadding = 22
        }
        if !isScrolled {
            tariffSlideY = (self.view.bounds.height * 0.742574) - bottomPadding
            tariffSlideVC.view.frame = CGRect(x: 0,
                                              y: tariffSlideY,
                                              width: self.view.bounds.width,
                                              height: tariffSlideHeight)
        }
    }
    
    ///Set full Detail datas
    func setDetailDatas()  {

        mCarNameLb.text = vehicleModel?.vehicleName
        mCarDetailLb.text = vehicleModel?.vehicleType
        mCarLogoImgV.image = vehicleModel?.vehicleLogo
        carPhotosView.mTowBarBckgV.isHidden = vehicleModel?.ifHasTowBar != nil ? !vehicleModel!.ifHasTowBar : true
        mCarInfoV.mCardLb.text = vehicleModel?.drivingLicense
        mCarInfoV.mKgLb.text = vehicleModel?.vehicleWeight
        mCarInfoV.mMeterCubeLb.text = vehicleModel?.vehicleCube
        mCarInfoV.mSizeLb.text = vehicleModel?.vehicleSize
        mAccessoriesBtn.alpha = vehicleModel?.ifHasAccessories ?? false ? 1.0 : 0.67
        mAdditionalDriverBtn.alpha = vehicleModel?.ifHasAditionalDriver ?? false ? 1.0 : 0.67
        mDetailsAndTailLiftV.mTailLiftV.isHidden = !(vehicleModel?.ifTailLift ?? false)!
        if !(vehicleModel?.ifTailLift ?? false) {
            mDetailAndTailLiftBottom.constant = -mDetailsAndTailLiftV.mTailLiftBtn.bounds.height
            mDetailHeight.constant = self.view.bounds.height * 0.0185644
            self.view.layoutIfNeeded()
        }
        detailsViewModel.getCarImageList(item: vehicleModel ?? VehicleModel()) { (imagesRetsult) in
            self.carPhotosView.carImagesList = imagesRetsult ?? []
            self.carPhotosView.mScrollRightBtn.isHidden =  self.carPhotosView.carImagesList.count > 1 ? false : true
            self.carPhotosView.mImagePagingCollectionV.reloadData()
            self.carPhotosView.mImagesBottomCollectionV.reloadData()
        }
    }
    
    
    ///Set  values to vehicle model
     func setVehicleModel(){
        //var vehicleModel = VehicleModel()
        vehicleModel?.vehicleName = mCarNameLb.text
        vehicleModel?.additionalAccessories = additionalAccessories
        vehicleModel?.additionalDrivers = additionalDrivers
//        searchModel.pickUpLocation = mSearchV.mPickUpLocationBtn.title(for: .normal)
//        searchModel.returnLocation = mSearchV.mReturnLocationBtn.title(for: .normal)
        vehicleModel?.searchModel = searchModel
        vehicleModel?.noWorkingTimeTotalPrice = detailsViewModel.getNoWorkingTimeTotalPrice(searchModel: searchModel, timePrice: timePrice)
        if !isSearchEdit {
            vehicleModel?.customLocationTotalPrice = detailsViewModel.getCustomLocationTotalPrice(searchV: mSearchV)
        }
     }
    
    
    ///Get tariff list
    private func getTariffList() {
        detailsViewModel.getTariff { [self] result in
            guard let _ = result else {
                BKDAlert().showAlertOk(on: self,
                                       message: Constant.Texts.errorRequest,
                                       okTitle: Constant.Texts.ok, okAction: nil)
                return
            }
            self.tariffs = result!
            self.tariffSlideList = self.detailsViewModel.changeTariffListForUse(tariffs: result!, vehicleModel: self.vehicleModel ?? VehicleModel()) 
            self.tariffSlideVC.tariffSlideList = self.tariffSlideList
            self.tariffSlideVC.mTariffSlideCollectionV.reloadData()
            self.mTariffCarouselV.tariffSlideList = self.tariffSlideList
            self.mTariffCarouselV.vehicleModel = self.vehicleModel
            self.mTariffCarouselV.tariffCarousel.reloadData()
        }
    }
    
    private func configureTransparentView()  {
        backgroundV.frame = self.view.bounds
        backgroundV.backgroundColor = .black
        backgroundV.alpha = 0.6
    }
        
   
    ///configure Views
    private func configureViews () {
        mDetailsTbV.setShadow(color: color_shadow!)
        mDetailsTbV.layer.cornerRadius = 3
        mTailLiftTableBckgV.setShadow(color: color_shadow!)
        mTailLiftTableBckgV.layer.cornerRadius = 3
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mReserveBckgV.isHidden = isClickMore
        if !isClickMore {
            configureReserveView(isActive: isSearchEdit)
        }
            
    }
    
    ///configure reserve view
    private func configureReserveView(isActive: Bool) {
        mReserveBckgV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:isActive ? color_reserve_start! : color_reserve_inactive_start!,
                                                  endColor:isActive ? color_reserve_end!: color_reserve_inactive_end! )
        mReserveBckgV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
        mReserveBckgV.isUserInteractionEnabled = isActive
    }
    
    
    
    ///configure Delegates
    func configureDelegates() {
        mDetailsAndTailLiftV.delegate = self
        mTariffCarouselV.delegate = self
        mSearchV.delegate = self
        mScrollV.delegate = self
        carPhotosView.delegate = self
        mSearchWithValueStackV.delegate = self
        tariffSlideVC.delegate = self
    }
    
    /// Add child view
    func addTariffSliedView() {
        addChild(tariffSlideVC)
        self.view.addSubview(tariffSlideVC.view)
        tariffSlideVC.didMove(toParent: self)
    }
    
    ///creat tool bar
    func creatToolBar() -> UIToolbar {
        //toolBAr
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar Button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        return toolBar
    }
    
    /// ScrollView will scroll to bottom
    private func scrollToBottom(distance: CGFloat) {
        let y = mScrollV.contentSize.height - mScrollV.bounds.height + mScrollV.contentInset.bottom + distance
        previousContentPosition = mScrollV.contentOffset
        scrollContentHeight = mScrollV.contentSize.height
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
                self.mScrollV.contentOffset.y = y
            }, completion: nil)
        }
        showTariffCardWithDelay()
    }
    
    ///Scroll view will back to previous position
    private func scrollToBack() {
        mScrollV.setContentOffset(previousContentPosition ?? CGPoint.zero, animated: true)
    }
    
   
    ///Will put new values from pickerDate
    func showSelectedDate(dayBtn : UIButton?, monthBtn: UIButton?, timeStr: String?) {
        if pickerState == .pickUpTime || pickerState == .returnTime { //Time
            
            responderTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)
            responderTxtFl.text = timeStr
            responderTxtFl.textColor = color_entered_date
            updateSearchTimes()
            
        } else { // date
        dayBtn?.setTitle(String(datePicker.date.getDay()), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
            updateSearchDates()
        }
        isActiveReserve()
    }
    
    /// will update date fields depend on tariff option
        func updateSearchDates() {
            if currentTariff != .flexible {
                search = .date
                searchModel.pickUpDate = datePicker.date
                let newSearchModel = detailsViewModel.updateSearchInfo(tariff:
                                                                        currentTariff, search: search,
                                                                       optionIndex: currentTariffOptionIndex, currSearchModel: searchModel)
                mSearchV.updateSearchDate(searchModel:newSearchModel)
                searchModel = newSearchModel
            }
    }
    
    ///Will update time fields depend on tariff option
    func updateSearchTimes() {
        if currentTariff != .flexible {
            search = .time
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            searchModel.pickUpTime = timeStr.stringToDate()
            mSearchV.mReturnTimeTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)
            
            let newSearchModel = detailsViewModel.updateSearchInfo(tariff:
                                                                    currentTariff,
                                                                   search: search,
                                                                   optionIndex: currentTariffOptionIndex, currSearchModel: searchModel)
            mSearchV.updateSearchTimes(searchModel: newSearchModel,
                                       tariff: currentTariff)
            searchModel = newSearchModel
        }
    }
    
    ///Will open  location controller
    func goToLocationController() {
        mSearchV!.mLocationDropDownView.didSelectSeeMap = { [weak self] result  in
            self?.goToSeeMap(parking: result)
        }
    }
    
    ///Will open  custom location map controller
    func goToReserveController() {
        
        let reserve = UIStoryboard(name: Constant.Storyboards.reserve, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.reserve) as! ReserveViewController
        setVehicleModel()
        reserve.vehicleModel = vehicleModel
        reserve.currentTariff = currentTariff
        self.navigationController?.pushViewController(reserve, animated: true)
    }
    
    
    private func isActiveReserve() {
        detailsViewModel.isReserveActive(searchModel: searchModel) { [self] (isActive) in
            //remove CAGradientLayer
            self.mReserveBckgV.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            configureReserveView(isActive: isActive)
        }
    }
    
    ///MARK: ANTIMATION METHODS
    ///
    ///Will animate reserve
    func animationReserve() {
        self.mReserveLeading.constant = self.view.bounds.width - self.mReserveBckgV.bounds.width + 25
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
           // self.mReserveBckgV.roundCorners(corners: [.topLeft], radius: 20)
        }
    }
    
    ///Will show or hide SearchEdit view with animation
    func animateSearchEdit(isShow: Bool) {
        let alphaValue = isShow ? 1.0 : 0.0
        if isShow {
            self.mSearchWithValueStackV.isHidden = !isShow
        }
        UIView.animate(withDuration: 0.5) { [self] in
            self.mSearchWithValueStackV.alpha = CGFloat(alphaValue)
        } completion: {[self] _ in
            if !isShow {
                self.mSearchWithValueStackV.isHidden = !isShow
            }
        }
    }
    
    ///Will be hidden search view
    private func hideSearchView() {
        UIView.animate(withDuration: 0.7) { [self] in
            self.mSearchV.alpha = 0.0
        } completion: { [self]  _ in
            self.mSearchV.isHidden = true
        }
    }
    
    ///Will show tariff cards
    private func showTariffCards () {
            self.mTariffCarouselV.tariffCarousel.reloadData()
        self.tariffSlideVC.tariffSlideList = self.tariffSlideList
            self.tariffSlideVC.mTariffSlideCollectionV.reloadData()
            UIView.animate(withDuration: 0.5) { [self] in
                self.tariffSlideVC.view.frame.origin.y += 500
                self.tariffSlideVC.view.layoutIfNeeded()
            } completion: { [self] _ in
                if isSearchEdit && currentTariff == .flexible {
                    self.animateSearchEdit(isShow: true)
                }
            }
        showTariffCardWithDelay()
    }
   
    private func showTariffCardWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.mTariffCarouselV.isHidden = false
            self.mCompareContentV.isHidden = (self.mSearchV.isHidden && self.mSearchWithValueStackV.isHidden) ? false : true
            UIView.animate(withDuration: 0.5) { [self] in
                self.mTariffCarouselV.alpha = 1.0
                self.mCompareContentV.alpha = (self.mSearchV.isHidden && self.mSearchWithValueStackV.isHidden) ? 1.0 : 0.0
            }
        }
    }
    
    ///Will hide tariff cards
    private func hideTariffCards() {
            UIView.animate(withDuration: 0.5) { [self] in
                self.tariffSlideVC.view.frame.origin.y -= 500
                mTariffCarouselV.alpha = 0.0
                self.mCompareContentV.alpha = 0.0
                mSearchV.alpha = 0.0
                self.tariffSlideVC.view.layoutIfNeeded()
            } completion: { [self]_ in
                self.mTariffCarouselV.isHidden = true
                self.mCompareContentV.isHidden = true
                mSearchV.isHidden = true
                scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height
            }
    }
    
    ///Show Tarif lift or Detail tableView
    private func showTableView(view: UIView, imgRotate: UIImageView?) {
            UIView.transition(with: view, duration: tableAnimationDuration, options: [.transitionCurlDown,.allowUserInteraction], animations: {
                if let _ = imgRotate {
                    imgRotate!.rotateImage(rotationAngle: CGFloat(Double.pi))
                }
                view.alpha = 1
                view.isHidden = false
            }, completion: nil)
    }
    
    ///Close Tarif lift or Detail tableView
    private func hideTableView(view: UIView, imgRotate: UIImageView?) {
        UIView.transition(with: view, duration: tableAnimationDuration, options: [.transitionCurlUp,.allowUserInteraction], animations: {
            if let _ = imgRotate {
                imgRotate!.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            }
            view.alpha = 0
        }, completion: {_ in
            view.isHidden = true
        })
    }
    
    
    //MARK: ALERT
    //MARK: -------------------
    
    func showAlertCustomLocation(checkedBtn: UIButton) {
        BKDAlert().showAlert(on: self,
                             title: String(format: Constant.Texts.titleCustomLocation, customLocationPrice),
                             message: Constant.Texts.messageCustomLocation,
                             messageSecond: Constant.Texts.messageCustomLocation2,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: {
                                checkedBtn.setImage(img_uncheck_box, for: .normal)
                             }, okAction: { [self] in
                                self.goToCustomLocationMapController(on: self, isAddDamageAddress: false)
                             })
    }
    
    func showAlertWorkingHours() {
        BKDAlert().showAlert(on: self,
                             title:String(format: Constant.Texts.titleWorkingTime, timePrice),
                             message: Constant.Texts.messageWorkingTime + "(\(workingTimes?.workStart ?? "") -  \(workingTimes?.workEnd ?? "")).",
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction:nil,
                             
                             okAction: { [self] in
                                showSelectedDate(dayBtn: nil, monthBtn: nil, timeStr: pickerList![ pickerV.selectedRow(inComponent: 0)])

                             })
    }
    
    func showAlertMoreThanMonth(optionIndex: Int) {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.messageMoreThanMonth,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,
                             cancelAction: { [self] in
                                mTariffCarouselV.tariffCarousel.reloadData()

                             }, okAction: { [self] in
                                if isSearchEdit {
                                    isSearchEdit = false
                                }
                                self.confirmPressed(optionIndex: optionIndex)
                             })
        
    }
    func showAlertChangeTariff(optionIndex: Int, option: String)  {
        BKDAlert().showAlert(on: self,
                             title: Constant.Texts.titleChangeTariff,
                             message: Constant.Texts.messageChangeTariff + option + " ? " + Constant.Texts.messageChangeTariffSeconst,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.change,
                             cancelAction: { [self] in
                                mTariffCarouselV.tariffCarousel.reloadData()

                             }, okAction: { [self] in
                                if currentTariff == .monthly {
                                    showAlertMoreThanMonth(optionIndex: 0)
                                } else {
                                    self.confirmPressed(optionIndex: optionIndex)
                                    isSearchEdit = false
                                }
                             })
    }
    
    
    //MARK: - Hendler Methodes
    /// Confirm button pressed
    private func confirmPressed(optionIndex: Int) {
        currentTariffOptionIndex = optionIndex
        updateSearchFields(optionIndex: optionIndex)
        mSearchV.configureSearchPassiveFields(tariff: currentTariff)
        if isSearchEdit {
            animateSearchEdit(isShow: !isSearchEdit)
        }  else {
            isSearchEdit = false
        }
        if mSearchV.isHidden  {
            mSearchV.isHidden = false
            mCompareContentV.isHidden = true

            mScrollV.contentSize.height = mScrollV.contentSize.height + mSearchV.bounds.height
            UIView.animate(withDuration: 0.7) { [self] in
                self.scrollToBottom(distance: 0.0)
                self.mSearchV.alpha = 1
            }
        }
    }
    
    @objc func donePressed() {
        responderTxtFl.resignFirstResponder()
        scrollToBack()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        
        switch pickerState {
        case .pickUpDate:
            mSearchV.showDateInfoViews(dayBtn: mSearchV!.mDayPickUpBtn,
                              monthBtn: mSearchV!.mMonthPickUpBtn,
                              txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayPickUpBtn,
                             monthBtn: mSearchV!.mMonthPickUpBtn, timeStr: nil)
            
                searchModel.pickUpDate = datePicker.date
                        
        case .returnDate:
            mSearchV.showDateInfoViews(dayBtn: mSearchV!.mDayReturnDateBtn,
                         monthBtn: mSearchV!.mMonthReturnDateBtn,
                         txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayReturnDateBtn,
                             monthBtn: mSearchV!.mMonthReturnDateBtn, timeStr: nil)
            searchModel.returnDate = datePicker.date

        default:
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            chanckReservationTime(timeStr: timeStr)
            
            if pickerState == .pickUpTime {
                searchModel.pickUpTime = timeStr.stringToDate()
            } else{
                searchModel.returnTime = timeStr.stringToDate()
            }
            
        }
        
    }
    
    ///check is reservation time during working time
    private func chanckReservationTime(timeStr: String?) {
        detailsViewModel.isReservetionInWorkingHours(time: timeStr?.stringToDate()) { [self] (result) in
            if !result {
                self.showAlertWorkingHours()
            } else {
                showSelectedDate(dayBtn: nil, monthBtn: nil, timeStr: timeStr)
            }
        }
        
    }
    
    
    //MARK: -Actions
    //MARK: --------------------
    
    ///Navigation controller will back to pravius controller
    @IBAction func back(_ sender: UIBarButtonItem) {
        additionalAccessories = AccessoriesData.accessoriesModel
        additionalDrivers = MyDriversData.myDriversModel
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        self.goToAccessories(on: self,
                             vehicleModel: vehicleModel,
                             isEditReservation: false)
    }
    
    
    @IBAction func additionalDriver(_ sender: UIButton) {
        self.goToAdditionalDriver(on: self, isEditReservation: false)
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        animationReserve()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            self.goToReserveController()
        }
    }
    
    @IBAction func compare(_ sender: UIButton) {
        let compareVC = CompareViewController.initFromStoryboard(name: Constant.Storyboards.compare)
        compareVC.vehicleModel = vehicleModel
      self.navigationController?.pushViewController(compareVC, animated: true)
    }
}







//MARK: DetailsAndTailLiftViewDelegate
//MARK: ----------------------------------
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        
        if willOpen  {
            mDetailsTbV.detailList = vehicleModel?.detailList ?? []
            mDetailsTbV.reloadData()
            scrollToBottom(distance: (vehicleModel?.ifTailLift ?? false) ? 0.0 : -(self.view.bounds.height * 0.247))
            if self.mTailLiftTableBckgV.alpha == 1 {
                hideTableView(view: mTailLiftTableBckgV, imgRotate: self.mDetailsAndTailLiftV.mTailLiftDropDownImgV)
                // will show Details tableView and close TailLift tableView
                showTableView(view: mDetailsTableBckgV, imgRotate: self.mDetailsAndTailLiftV.mDetailsDropDownImgV)

            } else { // will show Details tableView
                showTableView(view: mDetailsTableBckgV, imgRotate: self.mDetailsAndTailLiftV.mDetailsDropDownImgV)
            }
        } else if !willOpen { // will hide Details tableView
            hideTableView(view: mDetailsTableBckgV, imgRotate: self.mDetailsAndTailLiftV.mDetailsDropDownImgV)
        }
    }
    
    func didPressTailLift(willOpen: Bool) {
        scrollToBottom(distance: 0.0)
        // will show TailLift tableView
        if willOpen {
            mTailLiftTbV.tailLiftList = vehicleModel?.tailLiftList ?? []
            mTailLiftTbV.reloadData()
            showTableView(view: mTailLiftTableBckgV, imgRotate: nil)
        } else if !willOpen { // will hide TailLift tableView
            hideTableView(view: mTailLiftTableBckgV, imgRotate: nil)
        }
    }
}

//MARK: TariffSlideViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: TariffSlideViewControllerDelegate {
    
    func didPressTariffOption(tariff: TariffState, optionIndex: Int) {
        
        scrollContentHeight = 0.0
        setScrollVoiewHeight()
        scrollToBottom(distance: 0.0)
        currentTariff = tariff
        if isSearchEdit {
            animateSearchEdit(isShow: true)
        }
        switch tariff {
        case .hourly:
            mTariffCarouselV.tariffCarousel.currentItemIndex = 0
            break
        case .daily:
            mTariffCarouselV.tariffCarousel.currentItemIndex = 1
            break
        case .weekly:
            mTariffCarouselV.tariffCarousel.currentItemIndex = 2
            break
        case .monthly:
            mTariffCarouselV.tariffCarousel.currentItemIndex = 3
            break
        case .flexible:
            mTariffCarouselV.tariffCarousel.currentItemIndex = 4
            break
        }
        mTariffCarouselV.selectedSegmentIndex = optionIndex
        mTariffCarouselV.tariffCarousel.reloadData()
    }
}

//MARK: TariffCarouselViewDelegate
//MARK: ----------------------------
extension DetailsViewController: TariffCarouselViewDelegate {
    func didPressFuelConsuption(isCheck: Bool) {
        
    }
 
    func didPressConfirm(tariff: TariffState, optionIndex: Int, optionstr: String) {
        currentTariff = tariff
        if isSearchEdit && tariff != .flexible {
            showAlertChangeTariff(optionIndex: optionIndex, option: optionstr)
        } else {
            if tariff == .monthly {
                showAlertMoreThanMonth(optionIndex: optionIndex)
            } else {
                confirmPressed(optionIndex: optionIndex)
            }
        }
    }
    
    
    func willChangeTariffOption(tariff: TariffState, optionIndex: Int) {
        search = (tariff == .hourly) ? .time : .date
       updateSearchFields(optionIndex: optionIndex)
        currentTariffOptionIndex = optionIndex
    }

    func didPressMore(tariffIndex:Int, optionIndex: Int) {
        self.goToMore(vehicleModel: vehicleModel, carModel: nil)
    }
    
    ///update search fields
    private func updateSearchFields(optionIndex: Int) {
        searchModel = detailsViewModel.updateSearchInfo(tariff: currentTariff,
                                          search: search,
                                          optionIndex: optionIndex,
                                          currSearchModel: searchModel)
        mSearchV.updateSearchFilledFields(tariff: currentTariff,
                                          searchModel: searchModel)
    }
    
}

//MARK: SearchViewDelegate
//MARK: --------------------
extension DetailsViewController: SearchViewDelegate {

    func willOpenPicker(textFl: UITextField, pickerState: DatePicker) {
        self.pickerState = pickerState
        self.view.addSubview(self.backgroundV)
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl
        scrollToBottom(distance: mSearchV.bounds.height)

        if pickerState == .pickUpTime || pickerState == .returnTime {
            
            pickerList = ApplicationSettings.shared.pickerList
            textFl.inputView = pickerV
            textFl.inputAccessoryView = creatToolBar()

            pickerV.delegate = self
            pickerV.dataSource = self
        } else {
            self.datePicker = UIDatePicker()
            textFl.inputView = self.datePicker

            if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            } else {
                       // Fallback on earlier versions
            }
            self.datePicker.datePickerMode = .date
            self.datePicker.minimumDate =  Date()
            self.datePicker.timeZone = TimeZone(secondsFromGMT: 0)
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    
    func didSelectLocation(_ text: String, _ tag: Int) {
        if tag == 4 { //pick up location
            searchModel.pickUpLocation = text
        } else {// return location
            searchModel.returnLocation = text
        }
        isActiveReserve()
    }
    
    func didSelectCustomLocation(_ btn: UIButton) {
        self.showAlertCustomLocation(checkedBtn: btn)
    }
    
    func didDeselectCustomLocation(tag: Int) {
        if tag == 6 { //pick up custom location
            searchModel.isPickUpCustomLocation = false
            searchModel.pickUpLocation = nil
        } else {//return custom location
            searchModel.isRetuCustomLocation = false
            searchModel.returnLocation = nil
        }
        isActiveReserve()
    }
}

//MARK: CustomLocationUIViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: CustomLocationViewControllerDelegate {
    func getCustomLocation(_ locationPlace: String) {
         mSearchV.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
            } else {
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
            }
            self?.isActiveReserve()

        })
    }
}

//MARK: SearchWithValueViewDelegate
//MARK: ----------------------------
extension DetailsViewController: SearchWithValueViewDelegate {
    func didPressEdit() {
        currentTariff = .flexible
        mSearchV.searchModel = searchModel
        mSearchV.setUpView()
        mSearchV.configureSearchPassiveFields(tariff: currentTariff)
        mSearchV.updateSearchFields(searchModel: searchModel, tariff: currentTariff)
        
        self.mSearchV.isHidden = false
        mCompareContentV.isHidden = true

        UIView.animate(withDuration: 0.7) { [self] in
            self.scrollToBottom(distance: self.mSearchV.bounds.height - self.mSearchWithValueStackV.bounds.height)
            self.mSearchV.alpha = 1
            self.mSearchWithValueStackV.alpha = 0.0
        } completion: { _ in
            self.mSearchWithValueStackV.isHidden = true
            
        }
    }
    
}


//MARK: AccessoriesUIViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: MyDriversViewControllerDelegate {
    func selectedDrivers(_ isSelecte: Bool, totalPrice: Double) {
        mAdditionalDriverBtn.alpha = isSelecte ? 1.0 : 0.67
        vehicleModel?.ifHasAditionalDriver = isSelecte
        vehicleModel?.driversTotalPrice = totalPrice

    }
}

//MARK: AccessoriesUIViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: AccessoriesUIViewControllerDelegate {
    func addedAccessories(_ isAdd: Bool, totalPrice: Double) {
        mAccessoriesBtn.alpha = isAdd ? 1.0 : 0.67
        vehicleModel?.ifHasAccessories = isAdd
        vehicleModel?.accessoriesTotalPrice = totalPrice
    }
}

//MARK: CarPhotosViewDeleagte
//MARK: ----------------------------
extension DetailsViewController: CarPhotosViewDeleagte {
    func didChangeCarImage(_ img: UIImage) {
        vehicleModel?.vehicleImg = img
    }
}

//MARK: UIScrollViewDelegate
//MARK: ----------------------------
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if ( scrollView.contentOffset.y == 0) {
            // move up
            if isScrolled {
                isScrolled = !isScrolled
                if isSearchEdit && currentTariff == .flexible {
                    self.animateSearchEdit(isShow: false)
                }
               // hideTableViewIfOpen()
                hideTariffCards()
            }
        } else if (scrollView.contentOffset.y > 0) {
            // move down
            if !isScrolled {
                isScrolled = !isScrolled
                showTariffCards()
            }
        }
        
    }
    
}


//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension DetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.selectedRow(inComponent: component))
        
    }
}
