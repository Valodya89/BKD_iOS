//
//  DetailsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit
import CoreLocation

enum Search {
    case date
    case time
    case location
    case customLocation
}


class DetailsViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: -- Outlet
    
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
    @IBOutlet weak var mCompareTop: NSLayoutConstraint!
    
    //MARK: -- Varables

    private lazy  var tariffSlideVC = TariffSlideViewController.initFromStoryboard(name: Constant.Storyboards.details)
    
    let detailsViewModel:DetailsViewModel = DetailsViewModel()
    var settings: Settings?
    var startFlexibleTimeList: [String]?
    var endFlexibleTimeList: [String]?
    var tariffSlideList:[TariffSlideModel]?
    var currentTariffOption: TariffSlideModel?
    var flexibleTariffOption: TariffSlideModel?
    var containerViewForFariffSlide: UIView = UIView()
    
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
    
    private var staringScrollContentHeight: CGFloat = 0
    private let scrollPadding: CGFloat = 60
    private let tableAnimationDuration = 0.5
    private var tariffSlideY: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var previousContentPosition: CGPoint?
    private var scrollContentHeight: CGFloat = 0.0
    private var isScrolled = false
    private var isTariffSlide = true
    private var isFlexibleSelected = false
    private var isSetScrollFrame = false
    private var accessoriesEditList: [AccessoriesEditModel]?

    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTariffSlideViewFrame()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        print ("viewDidLayoutSubviews")
        print ("self.tariffSlideVC.view.frame.origin.y = \(self.tariffSlideVC.view.frame.origin.y)")
        setTableViewsHeight()
        setTariffSlideViewFrame()
        if isSearchEdit {
            mCompareTop.constant = mSearchV.isHidden ? 70 : height200
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mReserveLeading.constant = -50.0
        mSearchV.animateLocationList(isShow: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureReserveView(isActive: mReserveBckgV.isUserInteractionEnabled)
    }
    
    //MARK: -- Set
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        settings = ApplicationSettings.shared.settings
        mCompareContentV.layer.cornerRadius = 8

        staringScrollContentHeight = height1055 + 50
        
        if isSearchEdit {
            mSearchWithValueStackV.searchModel = searchModel
            mSearchWithValueStackV.setupView()
            animateSearchEdit(isShow: true)
        }
        self.mTariffCarouselV.alpha = 0.0
        configureViews()
        setDetailDatas()
        configureTransparentView()
        configureDelegates()
        addTariffSliedView()
        goToLocationController()
        getTariffList()
        
        
        self.reloadTariffCarusel(tariffSlideList: self.tariffSlideList)
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
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            bottomPadding = window.safeAreaInsets.bottom
        }
        if UIScreen.main.nativeBounds.height <= 1334 {
            bottomPadding = 22
        }
       // if !isSetScrollFrame {
        isSetScrollFrame = true
        tariffSlideY = (self.view.bounds.height * 0.742574) - bottomPadding
        tariffSlideVC.view.frame = CGRect(x: 0,
                                          y: 0,
                                          width: self.view.bounds.width,
                                          height: height170 )
        containerViewForFariffSlide.frame = CGRect(x: 0,
                                                   y: tariffSlideY,
                                                   width: self.view.bounds.width,
                                                   height: height170 )
        
       // }
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
        getCarImagesList()
    }
    
    ///Set  values to vehicle model
     func setVehicleModel(){
        let tariffIndex = detailsViewModel.getTariffIndex(tariff: currentTariff)
        vehicleModel?.vehicleName = mCarNameLb.text
        vehicleModel?.additionalAccessories = accessoriesEditList
        vehicleModel?.searchModel = searchModel
        vehicleModel?.depositPrice = (tariffSlideList?[tariffIndex].tariff?[currentTariffOptionIndex].deposit) ?? 0.0
     }
    
//MARK: -- Get
    ///get car´s images List
    private func getCarImagesList() {
        detailsViewModel.getCarImageList(item: vehicleModel ?? VehicleModel()) { (imagesRetsult) in
            self.carPhotosView.carImagesList = imagesRetsult ?? []
            self.carPhotosView.mScrollRightBtn.isHidden =  self.carPhotosView.carImagesList.count > 1 ? false : true
            self.carPhotosView.mImagePagingCollectionV.reloadData()
            self.carPhotosView.mImagesBottomCollectionV.reloadData()
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
            self.tariffSlideList = self.detailsViewModel.changeTariffListForUse(tariffs: result!, vehicleModel: self.vehicleModel ?? VehicleModel())
            self.tariffSlideVC.tariffSlideList = self.tariffSlideList
            self.tariffSlideVC.mTariffSlideCollectionV.reloadData()
            if isSearchEdit {
                  self.detailsViewModel.getCurrentTariff(search: searchModel,
                                                         vehicleModel: vehicleModel!,
                                                         tariffSlideList: self.tariffSlideList,
                                                         completion: { slideList, tariffState in
                      tariffSlideList = slideList
                      currentTariff = tariffState
                      self.reloadTariffCarusel(tariffSlideList: self.tariffSlideList)
                      self.mTariffCarouselV.tariffCarousel.currentItemIndex = TariffSlideViewModel().getTariffStateIndex(tariffState: currentTariff)
                      
                })
            } else {
                self.reloadTariffCarusel(tariffSlideList: self.tariffSlideList)

            }
                self.mTariffCarouselV.vehicleModel = self.vehicleModel
        }
    }
  
    
    //MARK: -- Configure
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
        
        startFlexibleTimeList = detailsViewModel.getStartFlexibleTimes(flexibleTimes: ApplicationSettings.shared.flexibleTimes)
        endFlexibleTimeList = detailsViewModel.getEndFlexibleTimes(flexibleTimes: ApplicationSettings.shared.flexibleTimes)
        if !isClickMore {
            configureReserveView(isActive: isSearchEdit)
        }
            
    }
    
    ///configure reserve view
    private func configureReserveView(isActive: Bool) {
        mReserveBckgV.removeCAShapeLayer()
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
        self.containerViewForFariffSlide.backgroundColor = .clear.withAlphaComponent(0.0)
        self.view.addSubview(self.containerViewForFariffSlide)
        addChild(tariffSlideVC)
        self.containerViewForFariffSlide.addSubview(tariffSlideVC.view)
        tariffSlideVC.didMove(toParent: self)
        self.view.bringSubviewToFront(mReserveBckgV)

    }
    
//    ///Reset view
//    func resetView() {
//
//        if isSearchEdit {
//            mCompareTop.constant = 70
//            animateSearchEdit(isShow: true)
//        }
//        mCompareContentV.alpha = 1
//        mCompareContentV.isHidden = false
//        mSearchV.isHidden = true
//        mScrollV.contentSize = CGSize(width: mScrollV.contentSize.width, height: staringScrollContentHeight)
//    }
    
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
    private func scrollToBottom() {
        mScrollV.contentSize.height = mSearchV.isHidden ? staringScrollContentHeight + 30 :  staringScrollContentHeight + height50
        //(mScrollV.contentSize.height + mSearchV.bounds.height)
        scrollToBottom(y: mScrollV.contentSize.height - mScrollV.bounds.size.height + mScrollV.contentInset.bottom)
    }
    
    /// ScrollView will scroll to bottom
    private func scrollToBottom(y: CGFloat?) {
        previousContentPosition = mScrollV.contentOffset
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
                self.mScrollV.contentOffset.y = y!
            }, completion: nil)
        }
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
            updateFlexiblePrice(search: searchModel)
            
        } else { // date
        dayBtn?.setTitle(String(datePicker.date.getDay()), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
            updateSearchDates()
        }
        isActiveReserve()
    }
    
    /// will update date fields depend on tariff option
        func updateSearchDates() {
            var newSearchModel = SearchModel()
            if currentTariff != .flexible {
                search = .date
                searchModel.pickUpDate = datePicker.date
                newSearchModel = detailsViewModel.updateSearchInfo(tariffSlideList: tariffSlideList!,
                                                                       tariff:
                                                                        currentTariff,
                                                                       search: search,
                                                                       optionIndex: currentTariffOptionIndex, currSearchModel: searchModel)
                mSearchV.updateSearchDate(tariff: currentTariff, searchModel:newSearchModel)
            } else {
                newSearchModel = detailsViewModel.updateSearchInfoForFlexible(search: search,
                                                                              currSearchModel: searchModel)
                mSearchV.updateSearchDate(tariff: currentTariff,
                                          searchModel: newSearchModel)
                updateFlexiblePrice(search: newSearchModel)
            }
            searchModel = newSearchModel

    }
    
    ///Will update time fields depend on tariff option
    func updateSearchTimes() {
        var newSearchModel = SearchModel()
        if currentTariff != .flexible {
            search = .time
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            searchModel.pickUpTime = timeStr.stringToDate()
            mSearchV.mReturnTimeTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)
            
            newSearchModel = detailsViewModel.updateSearchInfo(tariffSlideList: tariffSlideList!,
                                                               tariff:
                                                                currentTariff,
                                                               search: search,
                                                               optionIndex: currentTariffOptionIndex, currSearchModel: searchModel)
            mSearchV.updateSearchTimes(searchModel: newSearchModel,
                                       tariff: currentTariff)
            
        } else {
            newSearchModel = detailsViewModel.updateSearchInfoForFlexible(search: search,
                                                                          currSearchModel: searchModel)
            mSearchV.updateSearchDate(tariff: currentTariff,
                                      searchModel: newSearchModel)
        }
        searchModel = newSearchModel
        
    }
    
   
    ///Update flexible price
    func updateFlexiblePrice(search: SearchModel) {
        if search.pickUpDate != nil && search.returnDate != nil &&  search.pickUpTime != nil &&
            search.returnTime != nil &&
            currentTariff == .flexible &&
            currentTariffOption != nil  {
            flexibleTariffOption = detailsViewModel.getFlexiblePrice(search: search, option: currentTariffOption!, vehicle: vehicleModel!, isSelected: isFlexibleSelected)
            
            guard let tariffSlideList = mTariffCarouselV.tariffSlideList else {return}
            
            mTariffCarouselV.tariffSlideList![tariffSlideList.count - 1] = flexibleTariffOption!
            mTariffCarouselV.tariffCarousel.reloadData()
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
        reserve.currentTariffOption  = currentTariffOption
        self.navigationController?.pushViewController(reserve, animated: true)
    }
    
    
    private func isActiveReserve() {
        detailsViewModel.isReserveActive(searchModel: searchModel) { [self] (isActive) in
            //remove CAGradientLayer
            self.mReserveBckgV.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            configureReserveView(isActive: isActive)
        }
    }
    
    //MARK: -- Animations
    ///Will animate reserve
    func animationReserve() {
        self.mReserveLeading.constant = self.view.bounds.width - self.mReserveBckgV.bounds.width + 25
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
    }
    
    ///Will show or hide SearchEdit view with animation
    func animateSearchEdit(isShow: Bool) {
        let alphaValue = isShow ? 1.0 : 0.0
        if isShow {
            self.mSearchWithValueStackV.isHidden = !isShow
            self.mSearchV.isHidden = isShow
        }
        UIView.animate(withDuration: 0.5) { [self] in
            self.mSearchWithValueStackV.alpha = CGFloat(alphaValue)
        } completion: {[self] _ in
            if !isShow {
                self.mSearchWithValueStackV.isHidden = !isShow
                self.mCompareTop.constant = height200
            }
        }
    }
    
    
    ///Animate search content view
    private func animateSearchView(isShow: Bool) {
            UIView.animate(withDuration: 0.5) {
                self.mSearchV.alpha = isShow ? 1.0 : 0.0
            } completion: { _ in
                if isShow {
                    self.mSearchV.isHidden = !isShow
                }
        }
    }
    
    ///Update compare view posittion
    private func updateCompareView() {
        
            UIView.animate(withDuration: 0.5) {
                self.mCompareContentV.alpha = 0.0
                self.mCompareTop.constant = height200
            } completion: { _ in
                self.mCompareContentV.alpha = 1.0
            }
        view.layoutIfNeeded()
    }
    
    
//    private func updateCompareView(isShow: Bool) {
//        if !isShow {
//            UIView.animate(withDuration: 0.5) {
//                if isShow {
//                    self.mCompareContentV.isHidden = !isShow
//                    self.mCompareContentV.alpha = 1.0
//                    self.mSearchV.alpha = 0.0
//                } else {
//                    self.mCompareContentV.alpha = 0.0
//                    self.mSearchV.isHidden = isShow
//                    self.mSearchV.alpha = 1.0
//                }
//            } completion: { _ in
//                if !isShow {
//                    self.mCompareContentV.isHidden = !isShow
//                } else {
//                    self.mSearchV.isHidden = isShow
//                }
//            }
//        }
//    }
    
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
    
    ///Reload Tariff cells
    private func reloadTariffCarusel(tariffSlideList: [TariffSlideModel]?) {
        mTariffCarouselV.tariffSlideList = tariffSlideList
        mTariffCarouselV.tariffCarousel.reloadData()
    }
    
    //MARK: -- Alerts
    ///Alert for custom location
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
    
    ///Alert for no working hours
    func showAlertWorkingHours() {
        BKDAlert().showAlert(on: self,
                             title:String(format: Constant.Texts.titleWorkingTime, timePrice),
                             message: Constant.Texts.messageWorkingTime + "(\(settings?.workStart ?? "") -  \(settings?.workEnd ?? "")).",
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction:nil,
                             
                             okAction: { [self] in
                                showSelectedDate(dayBtn: nil, monthBtn: nil, timeStr: pickerList![ pickerV.selectedRow(inComponent: 0)])

                             })
    }
 
    ///Alert for more then a month
    func showAlertMoreThanMonth(optionIndex: Int, options: [TariffSlideModel]?) {

        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.messageMoreThanMonth,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,
                             cancelAction: { [self] in
                                mTariffCarouselV.tariffCarousel.reloadData()

                             }, okAction: { [self] in
                                 self.confirmPressed(optionIndex: optionIndex, options: options)
                             })
    }
    
    ///Alert for change tariff
    func showAlertChangeTariff(optionIndex: Int,
                               option: String,
                               options: [TariffSlideModel]?)  {
        
        let pickup = searchModel.pickUpDate!.getDay() + searchModel.pickUpDate!.getMonthAndWeek(lng: "en") + "/" + searchModel.pickUpTime!.getHour()
        let retrunDate = searchModel.returnDate!.getDay() + searchModel.returnDate!.getMonthAndWeek(lng: "en") + "/" + searchModel.returnTime!.getHour()
        BKDAlert().showAlert(on: self,
                             title: pickup + "   " + retrunDate,
                             message: Constant.Texts.messageChangeTariff + option + " ? " + Constant.Texts.messageChangeTariffSeconst,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.change,
                             cancelAction: { [self] in
                                mTariffCarouselV.tariffCarousel.reloadData()

                             }, okAction: { [self] in
                                if currentTariff == .monthly {
                                    showAlertMoreThanMonth(optionIndex: 0,options: options)
                                } else {
                                    self.confirmPressed(optionIndex: optionIndex, options: options)
                                    mCompareTop.constant = 0
                                }
                             })
    }
    
    //MARK: -- Checked
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
    
    ///check if reservation date more than 90 days
  private  func checkIfReservationMoreThan90Days() -> Bool {
        if  MainViewModel().isReservetionMore90Days(search: searchModel) && currentTariff == .flexible {
                BKDAlert().showAlertOk(on: self, message: Constant.Texts.max90Days, okTitle: Constant.Texts.ok) {
                    self.mSearchV.resetReturnDate()
                    self.mSearchV.resetReturnTime()
                    self.searchModel.returnDate = nil
                    self.searchModel.returnTime = nil

            }
            return true
        }
        return false
    }
    
    //MARK: -- Hendler Methodes
    /// Confirm button pressed
    private func confirmPressed(optionIndex: Int,
                                options: [TariffSlideModel]?) {
        isScrolled = true
        currentTariffOptionIndex = optionIndex
        currentTariffOption = options?[optionIndex]
        isFlexibleSelected = (currentTariff == .flexible) ? true : false
        if currentTariff != .flexible &&  flexibleTariffOption != nil {
            flexibleTariffOption = detailsViewModel.getFlexiblePrice(search: searchModel, option: flexibleTariffOption!, vehicle: vehicleModel!, isSelected: false)
            mTariffCarouselV.tariffSlideList![tariffSlideList!.count - 1] = flexibleTariffOption!
        }

        tariffSlideList = detailsViewModel.updateTariffSlideList(tariffSlideList: tariffSlideList,
                                                                 optionIndex: optionIndex,
                                                                 options: options,
                                                                 tariff: currentTariff)
        reloadTariffCarusel(tariffSlideList: tariffSlideList)
        
        if isSearchEdit {
            animateSearchEdit(isShow: !isSearchEdit)
        }
            isSearchEdit = false
        
        updateSearchFields(optionIndex: optionIndex)
        mSearchV.configureSearchPassiveFields(tariff: currentTariff)
        isActiveReserve()
        if mSearchV.isHidden  {
            mSearchV.isHidden = false
            mScrollV.frame.size = CGSize(width: mScrollV.bounds.width, height: mScrollV.contentSize.height)

            scrollToBottom()
            animateSearchView(isShow: true)
            updateCompareView()
        }
    }
    
    
    ///Handler done button of toolBar
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
            searchModel.pickUpDate = datePicker.date
            if !checkIfReservationMoreThan90Days() {
                showSelectedDate(dayBtn: mSearchV!.mDayPickUpBtn,
                                 monthBtn: mSearchV!.mMonthPickUpBtn, timeStr: nil)
            }

                        
        case .returnDate:
            mSearchV.showDateInfoViews(dayBtn: mSearchV!.mDayReturnDateBtn,
                         monthBtn: mSearchV!.mMonthReturnDateBtn,
                         txtFl: responderTxtFl)
            searchModel.returnDate = datePicker.date
            if !checkIfReservationMoreThan90Days() {
                showSelectedDate(dayBtn: mSearchV!.mDayReturnDateBtn,
                                 monthBtn: mSearchV!.mMonthReturnDateBtn, timeStr: nil)
            }
            

        default:
            var timeStr = ""
           if currentTariff != .flexible {
                timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
                chanckReservationTime(timeStr: timeStr)
           } else {
               timeStr = detailsViewModel.getTimeOfFlexible(time: pickerList![ pickerV.selectedRow(inComponent: 0)])
           }

            
            if pickerState == .pickUpTime {
                searchModel.pickUpTime = timeStr.stringToDate()
            } else{
                searchModel.returnTime = timeStr.stringToDate()
            }
            
            if currentTariff == .flexible {
                if !checkIfReservationMoreThan90Days() {
                    showSelectedDate(dayBtn: nil, monthBtn: nil, timeStr: pickerList![ pickerV.selectedRow(inComponent: 0)])
                }
            }
            
        }
        
    }
    
    
    //MARK: -- Actions
    
    ///Navigation controller will back to pravius controller
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        self.goToAccessories(on: self,
                             vehicleModel: vehicleModel,
                             isEditReservation: false,
                             accessoriesEditList: accessoriesEditList)
    }
    
    
    @IBAction func additionalDriver(_ sender: UIButton) {
        self.goToAdditionalDriver(on: self,
                                  isEditReservation: false,
                                  additionalDrivers: vehicleModel?.additionalDrivers)
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        animationReserve()
        detailsViewModel.setNoWorkingHoursPrice(search: searchModel, price: timePrice)
        
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


//MARK: -- DetailsAndTailLiftViewDelegate
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        
        if willOpen  {
            scrollToBottom(y: height245)
            mDetailsTbV.detailList = vehicleModel?.detailList ?? []
            mDetailsTbV.reloadData()
           

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
        // will show TailLift tableView
        if willOpen {
            scrollToBottom(y: height170)
            mTailLiftTbV.tailLiftList = vehicleModel?.tailLiftList ?? []
            mTailLiftTbV.reloadData()
            
            showTableView(view: mTailLiftTableBckgV, imgRotate: nil)
        } else if !willOpen { // will hide TailLift tableView
            hideTableView(view: mTailLiftTableBckgV, imgRotate: nil)
        }
    }
}

//MARK: -- TariffSlideViewControllerDelegate
extension DetailsViewController: TariffSlideViewControllerDelegate {
    
    func didPressTariffOption(tariff: TariffState, optionIndex: Int) {
        isTariffSlide = false
        isScrolled = true
        scrollToBottom(y: mScrollV.contentSize.height - mScrollV.bounds.size.height + mScrollV.contentInset.bottom)
        if mSearchV.isHidden {
            self.mCompareTop.constant = 0
        }

        currentTariff = tariff
        if isSearchEdit {
            animateSearchEdit(isShow: true)
        }
        mTariffCarouselV.tariffCarousel.currentItemIndex =         TariffSlideViewModel().getTariffStateIndex(tariffState: tariff)

        tariffSlideList?[mTariffCarouselV.tariffCarousel.currentItemIndex].options?[optionIndex].isOpenOptions = true
        tariffSlideList?[mTariffCarouselV.tariffCarousel.currentItemIndex].segmentIndex = optionIndex
        reloadTariffCarusel(tariffSlideList: tariffSlideList)
    }
}

//MARK: -- TariffCarouselViewDelegate
extension DetailsViewController: TariffCarouselViewDelegate {
  
 
    func didPressConfirm(tariff: TariffState,
                         optionIndex: Int,
                         optionstr: String,
                         options: [TariffSlideModel]? ) {
        currentTariff = tariff
        isScrolled = true
        
        if isSearchEdit {
            showAlertChangeTariff(optionIndex: optionIndex,
                                  option: optionstr, options: options)
        } else {
            if tariff == .monthly {
                showAlertMoreThanMonth(optionIndex: optionIndex,
                                       options: options)
            } else {
                confirmPressed(optionIndex: optionIndex,
                               options: options)
            }
        }
    }
    
    
    func willChangeTariffOption(tariff: TariffState,
                                optionstr: String,
                                optionIndex: Int,
                                options: [TariffSlideModel]? ) {
        
        search = (tariff == .hourly) ? .time : .date
       updateSearchFields(optionIndex: optionIndex)
        currentTariffOptionIndex = optionIndex
        currentTariffOption = options?[optionIndex]
        if isSearchEdit && tariff != .flexible {
            showAlertChangeTariff(optionIndex: optionIndex,
                                  option: optionstr, options: options)
        }
    }

    func didPressMore(tariffIndex:Int, optionIndex: Int) {
        vehicleModel?.depositPrice = (tariffSlideList?[tariffIndex].tariff?[optionIndex].deposit) ?? 0.0
        self.goToMore(vehicleModel: vehicleModel, carModel: nil)
    }
    
    ///update search fields
    private func updateSearchFields(optionIndex: Int) {
        if !isSearchEdit {
        searchModel = detailsViewModel.updateSearchInfo(tariffSlideList:tariffSlideList!,
                                                        tariff: currentTariff,
                                          search: search,
                                          optionIndex: optionIndex,
                                          currSearchModel: searchModel)
        }
       // if isSearchEdit  {
            mSearchV.updateSearchFields(searchModel: searchModel,
                                        tariff: currentTariff)
//        } else {
//            mSearchV.updateSearchFilledFields(tariff: currentTariff,
//                                              searchModel: searchModel,
//                                              isEdit: isSearchEdit)
//        }
    }
    
}

//MARK: -- SearchViewDelegate
extension DetailsViewController: SearchViewDelegate {

    func willOpenPicker(textFl: UITextField, pickerState: DatePicker) {
        self.pickerState = pickerState
        self.view.addSubview(self.backgroundV)
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl
        scrollToBottom(y: height550)

        if pickerState == .pickUpTime || pickerState == .returnTime {
            if currentTariff == .flexible {
                pickerList = (pickerState == .pickUpTime) ? startFlexibleTimeList : endFlexibleTimeList
            } else {
                pickerList = ApplicationSettings.shared.pickerList
            }
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
            self.datePicker.maximumDate =  Date().addMonths(12)

            if let pickUpDate =  searchModel.pickUpDate {
                self.datePicker.minimumDate =  pickUpDate
            }
            
            self.datePicker.timeZone = TimeZone(secondsFromGMT: 0)
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    
    func didSelectLocation(_ parking: Parking, _ tag: Int) {
        if tag == 4 { //pick up location
            searchModel.pickUpLocation = parking.name
            searchModel.pickUpLocationId = parking.id
            searchModel.isPickUpCustomLocation = false
            PriceManager.shared.pickUpCustomLocationPrice = nil
        } else {// return location
            searchModel.returnLocation = parking.name
            searchModel.returnLocationId = parking.id
            searchModel.isRetuCustomLocation = false
            PriceManager.shared.returnCustomLocationPrice = nil
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
            searchModel.pickUpLocationId = nil
            PriceManager.shared.pickUpCustomLocationPrice = nil

        } else {//return custom location
            searchModel.isRetuCustomLocation = false
            searchModel.returnLocation = nil
            searchModel.returnLocationId = nil
            PriceManager.shared.returnCustomLocationPrice = nil
        }
        isActiveReserve()
    }
}

//MARK: -- CustomLocationUIViewControllerDelegate

extension DetailsViewController: CustomLocationViewControllerDelegate {
    func getCustomLocation(_ locationPlace: String, coordinate: CLLocationCoordinate2D, price: Double?) {
         mSearchV.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
                self?.searchModel.pickUpLocationLongitude = coordinate.longitude
                self?.searchModel.pickUpLocationLatitude = coordinate.latitude
                PriceManager.shared.pickUpCustomLocationPrice = price
            } else {
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
                self?.searchModel.returnLocationLongitude = coordinate.longitude
                self?.searchModel.returnLocationLatitude = coordinate.latitude
                PriceManager.shared.returnCustomLocationPrice = price
            }
            self?.isActiveReserve()

        })
    }
}

//MARK: -- SearchWithValueViewDelegate
extension DetailsViewController: SearchWithValueViewDelegate {
    
    func didPressEdit() {
        
       // self.currentTariff = .flexible
        self.mSearchV.searchModel = self.searchModel
        self.mSearchV.setUpView()
        self.mSearchV.configureSearchPassiveFields(tariff: self.currentTariff)
        self.mSearchV.updateSearchFields(searchModel: self.searchModel, tariff: self.currentTariff)
        
        //self.updateCompareView(isShow: false)
        animateSearchView(isShow: true)
        updateCompareView()
        self.animateSearchEdit(isShow: false)
        self.scrollToBottom()
        self.mSearchV.isHidden = false
    }
    
}


//MARK: -- AccessoriesUIViewControllerDelegate
extension DetailsViewController: MyDriversViewControllerDelegate {
    
    func selectedDrivers(_ isSelecte: Bool, additionalDrivers: [MyDriversModel]?) {
        mAdditionalDriverBtn.alpha = isSelecte ? 1.0 : 0.67
        vehicleModel?.ifHasAditionalDriver = isSelecte
        vehicleModel?.additionalDrivers = additionalDrivers
    }
}

//MARK: -- AccessoriesUIViewControllerDelegate
extension DetailsViewController: AccessoriesUIViewControllerDelegate {
    
    func addedAccessories(_ isAdd: Bool,
                          totalPrice: Double,
                          accessoriesEditList: [AccessoriesEditModel]?) {
        
        mAccessoriesBtn.alpha = isAdd ? 1.0 : 0.67
        vehicleModel?.ifHasAccessories = isAdd
        self.accessoriesEditList = accessoriesEditList
    }
}

//MARK: -- CarPhotosViewDeleagte
extension DetailsViewController: CarPhotosViewDeleagte {
    func didChangeCarImage(_ img: UIImage) {
        vehicleModel?.vehicleImg = img
    }
}

//MARK: -- UIScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("ofset y = ",scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= 0 {
            // TariffSlide is showed
            containerViewForFariffSlide.frame.origin.y = tariffSlideY
            self.containerViewForFariffSlide.alpha = 1.0
            self.mTariffCarouselV.alpha = 0.0
            if scrollView.contentOffset.y > -5 {
                if currentTariff == .flexible {
                    isFlexibleSelected = false
                    updateFlexiblePrice(search: searchModel)
                }
//                if !isSearchEdit {
//                    tariffSlideList = detailsViewModel.updateTariffSlideList(tariffSlideList: tariffSlideList, optionIndex: 0, options: nil, tariff: currentTariff)
//                }
//                reloadTariffCarusel(tariffSlideList: tariffSlideList)
                
            }
            isTariffSlide = true
//            if isSearchEdit {
//                self.animateSearchEdit(isShow: true)
//            }
            isScrolled = false
           // self.resetView()
        } else if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= height170 {
            containerViewForFariffSlide.frame.origin.y = tariffSlideY + scrollView.contentOffset.y
            self.containerViewForFariffSlide.alpha = 1 - (scrollView.contentOffset.y / height170)
            self.mTariffCarouselV.alpha = (scrollView.contentOffset.y / height170)
        } else {
            // TariffSlide is hided
            
            self.tariffSlideVC.tariffSlideList = self.tariffSlideList
            self.tariffSlideVC.mTariffSlideCollectionV.reloadData()
            
            containerViewForFariffSlide.frame.origin.y = tariffSlideY + height170
            self.containerViewForFariffSlide.alpha = 0.0
            isScrolled = !isScrolled
            isTariffSlide = true
            //updateCompareView(isShow: true)
           // updateCompareView()
            self.mTariffCarouselV.alpha = 1.0
        }
        print("tariffSlideVC.view.frame.origin.y = \(containerViewForFariffSlide.frame.origin.y)")
        
        self.view.layoutIfNeeded()
        self.containerViewForFariffSlide.layoutIfNeeded()
    }

}


//MARK: -- UIPickerViewDelegate
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
