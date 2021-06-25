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

class DetailsViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: Outlet
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
    
    @IBOutlet weak var mDetailsTbVHeight: NSLayoutConstraint!
    @IBOutlet weak var mTailLiftTbVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mSearchWithValueStackV: SearchWithValueView!
    @IBOutlet weak var mSearchV: SearchView!
    @IBOutlet weak var mReserveBckgV: UIView!
    @IBOutlet weak var mReserveBtn: UIButton!
    
    //MARK: Varables
    private lazy  var tariffSlideVC = TariffSlideViewController.initFromStoryboard(name: Constant.Storyboards.details)
    let detailsViewModel:DetailsViewModel = DetailsViewModel()
    var searchModel:SearchModel = SearchModel()
    var isSearchEdit = false
    var currentTariff: Tariff = .hourly
    var search: Search = .date
    var currentTariffOptionIndex: Int = 0
    
    let datePicker = UIDatePicker()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    
    private let scrollPadding: CGFloat = 60
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
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        if isSearchEdit {
            mSearchWithValueStackV.searchModel = searchModel
            mSearchWithValueStackV.setupView()
            mTariffCarouselV.tariffCarousel.currentItemIndex = 4
            mTariffCarouselV.tariffCarousel.reloadData()
            currentTariff = .flexible
        }
        configureViews()
        configureTransparentView()
        configureDelegates()
        addTariffSliedView()
        showLocation()
        
    }
    
    
    private func configureTransparentView()  {
        backgroundV.frame = self.view.bounds
        backgroundV.backgroundColor = .black
        backgroundV.alpha = 0.6
    }
    
    /// set height of scroll view
    func setScrollVoiewHeight() {
        if scrollContentHeight == 0.0 {
            // will show only tariff cards
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height
        }
        if self.isSearchEdit && self.mSearchV.isHidden  {// will show tariff cards and search edit view
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchWithValueStackV.bounds.height
        } else if !self.mSearchV.isHidden { // will show tariff cards and search view
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchV.bounds.height
        }
        mScrollV.contentSize.height = scrollContentHeight
    }
    
    
    /// set height to details or tailLift tableView
    func  setTableViewsHeight() {
        if DetailsData.detailsModel.count > 11{
            mDetailsTbVHeight.constant = 11 * detail_cell_height
        } else {
            mDetailsTbVHeight.constant = CGFloat(DetailsData.detailsModel.count) * detail_cell_height
        }
        mDetailsTbV.frame.size = CGSize(width: mDetailsTbV.frame.size.width, height: mDetailsTbVHeight.constant)
        self.view.layoutIfNeeded()
        if TailLiftData.tailLiftModel.count > 10 {
            mTailLiftTbVHeight.constant = 10 * tailLift_cell_height
        } else {
            mTailLiftTbVHeight.constant = CGFloat(TailLiftData.tailLiftModel.count) * tailLift_cell_height
        }
    }
    
    ///set frame to Tariff Slide View
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
    
    ///configure Views
    private func configureViews () {
        mDetailsTbV.setShadow(color: color_shadow!)
        mDetailsTbV.layer.cornerRadius = 3
        mTailLiftTableBckgV.setShadow(color: color_shadow!)
        mTailLiftTableBckgV.layer.cornerRadius = 3
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mReserveBckgV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:color_Offline_bckg!, endColor:color_Offline_bckg!.withAlphaComponent(0.85) )
        mReserveBckgV.roundCorners(corners: [.topRight], radius: 20)
        
    }
    ///configure Delegates
    func configureDelegates() {
        mDetailsAndTailLiftV.delegate = self
        mTariffCarouselV.delegate = self
        mSearchV.delegate = self
        mScrollV.delegate = self
        mSearchWithValueStackV.delegate = self
        tariffSlideVC.delegate = self
        
    }
    
    /// Add child view
    func addTariffSliedView() {
        addChild(tariffSlideVC)
        self.view.addSubview(tariffSlideVC.view)
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
    }
    
    ///Scroll view will back to previous position
    private func scrollToBack() {
        mScrollV.setContentOffset(previousContentPosition ?? CGPoint.zero, animated: true)
    }
    
    
    ///will show or hide SearchEdit view with animation
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
    
    /// will be hidden search view
    private func hideSearchView() {
        UIView.animate(withDuration: 1) { [self] in
            self.mSearchV.alpha = 0.0
        } completion: { [self]  _ in
            self.mSearchV.isHidden = true
        }
    }
    
    ///will show tariff cards
    private func showTariffCards () {
        mTariffCarouselV.isHidden = false
        UIView.animate(withDuration: 1.0) { [self] in
            self.mTariffCarouselV.alpha = 1
            self.tariffSlideVC.view.frame.origin.y += 500
            self.tariffSlideVC.view.layoutIfNeeded()
        } completion: { [self] _ in
            if isSearchEdit {
                self.animateSearchEdit(isShow: true)
            }
        }
    }
   
    /// will hide tariff cards
    private func hideTariffCards() {
        UIView.animate(withDuration: 1.0) { [self] in
            self.tariffSlideVC.view.frame.origin.y -= 500
            mTariffCarouselV.alpha = 0.0
            mSearchV.alpha = 0.0
            self.tariffSlideVC.view.layoutIfNeeded()
        } completion: { [self]_ in
            self.mTariffCarouselV.isHidden = true
            mSearchV.isHidden = true
            scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height
        }
    }
    ///Will put new values from pickerDate
    func showSelectedDate(dayBtn : UIButton?, monthBtn: UIButton?) {
        if responderTxtFl.tag > 1 { //Time
            
            responderTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)
            responderTxtFl.text = datePicker.date.getHour()
            responderTxtFl.textColor = color_entered_date
            updateSearchTimes()
            
        } else { // date
            dayBtn?.setTitle(String(datePicker.date.get(.day)), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
            updateSearchDates()
        }
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
    
    /// will update time fields depend on tariff option
    func updateSearchTimes() {
        if currentTariff != .flexible {
            
            search = .time
            searchModel.pickUpTime = datePicker.date
            mSearchV.mReturnTimeTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)

            
            let newSearchModel = detailsViewModel.updateSearchInfo(tariff:
                                                                    currentTariff,
                                                                   search: search,
                                                                   optionIndex: currentTariffOptionIndex, currSearchModel: searchModel)
            mSearchV.updateSearchTimes(searchModel: newSearchModel)
            searchModel = newSearchModel
        }
    }
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        mSearchV!.mLocationDropDownView.didSelectSeeMap = { [weak self]  in
            let seeMapContr = UIStoryboard(name: Constant.Storyboards.seeMap, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.seeMap) as! SeeMapViewController
            self?.navigationController?.pushViewController(seeMapContr, animated: true)
        }
    }
    ///will be show the custom location map controller
    func showCustomLocationMap() {
        let customLocationContr = UIStoryboard(name: Constant.Storyboards.customLocation, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.customLocation) as! CustomLocationViewController
        customLocationContr.delegate = self
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    
    func showAlertCustomLocation(checkedBtn: UIButton) {
        BKDAlert().showAlert(on: self,
                             title:Constant.Texts.titleCustomLocation,
                             message: Constant.Texts.messageCustomLocation,
                             messageSecond: Constant.Texts.messageCustomLocation2,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: {
                                checkedBtn.setImage(img_uncheck_box, for: .normal)
                             }, okAction: { [self] in
                                self.showCustomLocationMap()
                             })
    }
    
    func showAlertWorkingHours() {
        BKDAlert().showAlert(on: self,
                             title:Constant.Texts.titleWorkingTime,
                             message: Constant.Texts.messageWorkingTime,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction:nil,
                             
                             okAction: { [self] in
                                showSelectedDate(dayBtn: nil, monthBtn: nil)

                             })
    }
    
    @objc func donePressed() {
        responderTxtFl.resignFirstResponder()
        scrollToBack()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        
        if responderTxtFl.tag == 0 { // PickUpDate
            
            mSearchV.showDateInfoViews(dayBtn: mSearchV!.mDayPickUpBtn,
                              monthBtn: mSearchV!.mMonthPickUpBtn,
                              txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayPickUpBtn,
                             monthBtn: mSearchV!.mMonthPickUpBtn)
            
        } else if responderTxtFl.tag == 1 { // ReturnDate
            mSearchV.showDateInfoViews(dayBtn: mSearchV!.mDayReturnDateBtn,
                         monthBtn: mSearchV!.mMonthReturnDateBtn,
                         txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayReturnDateBtn,
                             monthBtn: mSearchV!.mMonthReturnDateBtn)
            
        } else { // Time
            //check time
            detailsViewModel.isReservetionInWorkingHours(time: datePicker.date ) { [self] (result) in
                if !result {
                    self.showAlertWorkingHours()
                } else {
                    showSelectedDate(dayBtn: nil, monthBtn: nil)
                }
            }
        }
    }
    
    
    
    //MARK: ACTIONS
    //MARK: --------------------
    
    ///Navigation controller will back to pravius controller
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    @IBAction func additionalDriver(_ sender: UIButton) {
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        let recerve = UIStoryboard(name: Constant.Storyboards.reserve, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.reserve) as! ReserveViewController
        self.navigationController?.pushViewController(recerve, animated: true)
    }
}


//MARK: DetailsAndTailLiftViewDelegate
//MARK: ----------------------------------
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        if willOpen  {
            scrollToBottom(distance: 0.0)
            if self.mTailLiftTableBckgV.alpha == 1 {
                // will show Details tableView and close TailLift tableView
                UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                    
                    self.mDetailsAndTailLiftV.mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                    self.mTailLiftTableBckgV.alpha = 0
                }, completion: { [self]_ in
                    self.mTailLiftTableBckgV.isHidden = true
                    UIView.transition(with: self.mDetailsTbV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                        self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                        self.mDetailsTbV.alpha = 1
                        self.mDetailsTbV.isHidden = false
                    }, completion: nil)
                })
                
            } else { // will show Details tableView
                
                UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                    self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                    self.mDetailsTableBckgV.alpha = 1
                    self.mDetailsTableBckgV.isHidden = false
                }, completion: nil)
            }
            
        } else if !willOpen { // will hide Details tableView
            
            UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                self.mDetailsTableBckgV.alpha = 0
            }, completion: {_ in
                self.mDetailsTableBckgV.isHidden = true
            })
        }
    }
    
    func didPressTailLift(willOpen: Bool) {
        scrollToBottom(distance: 0.0)
        
        // will show TailLift tableView
        if willOpen {
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 1
                self.mTailLiftTableBckgV.isHidden = false
            }, completion: nil)
        } else if !willOpen { // will hide TailLift tableView
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 0
            }, completion: {_ in
                self.mTailLiftTableBckgV.isHidden = true
            })
        }
    }
    
}

//MARK: TariffSlideViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: TariffSlideViewControllerDelegate {
    
    func didPressTariffOption(tariff: Tariff, optionIndex: Int) {
        scrollToBottom(distance: 0.0)
        currentTariff = tariff
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
    
    func didPressConfirm(isSelect: Bool,  tariff: Tariff, optionIndex: Int) {
        currentTariff = tariff
        currentTariffOptionIndex = optionIndex
        updateSearchFields(optionIndex: optionIndex)
        mSearchV.configureSearchPassiveFields(tariff: currentTariff)
        if isSearchEdit {
            animateSearchEdit(isShow: !isSearchEdit)
        }
        if mSearchV.isHidden  {
            mSearchV.isHidden = false
            mScrollV.contentSize.height = mScrollV.contentSize.height + mSearchV.bounds.height
            UIView.animate(withDuration: 1.5) { [self] in
                self.scrollToBottom(distance: 0.0)
                self.mSearchV.alpha = 1
            }
        }
    }
    
    func willChangeTariffOption(optionIndex: Int) {
       updateSearchFields(optionIndex: optionIndex)
    }

    func didPressMore() {
        let moreVC = UIStoryboard(name: Constant.Storyboards.more, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.more) as! MoreViewController
        self.navigationController?.pushViewController(moreVC, animated: true)
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
    
    func willOpenPicker(textFl: UITextField) {
        
        self.view.addSubview(self.backgroundV)
        textFl.inputView = self.datePicker
        textFl.inputAccessoryView = creatToolBar()
        self.responderTxtFl = textFl
        scrollToBottom(distance: mSearchV.bounds.height)
        
        if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if textFl.tag > 1 { // time
            self.datePicker.datePickerMode = .time
            self.datePicker.minimumDate = nil

        } else { // date
            self.datePicker.datePickerMode = .date
            self.datePicker.minimumDate =  Date()
            
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    
    func didSelectLocation(_ text: String, _ tag: Int) {
        if tag == 0 { //pick up location
        } else {// return location
           
        }
            
    }
    
    func didSelectCustomLocation(_ btn: UIButton, location: Location) {
        self.showAlertCustomLocation(checkedBtn: btn)
    }
    
}

//MARK: CustomLocationUIViewControllerDelegate
//MARK: ----------------------------
extension DetailsViewController: CustomLocationViewControllerDelegate {
    func getCustomLocation(_ locationPlace: String) {
        mSearchV.updateLocationFields(place: locationPlace)
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
        mSearchV.updateSearchFields(searchModel: searchModel)
        
        self.mSearchV.isHidden = false
        UIView.animate(withDuration: 1.0) { [self] in
            self.scrollToBottom(distance: self.mSearchV.bounds.height - self.mSearchWithValueStackV.bounds.height)
            self.mSearchV.alpha = 1
            self.mSearchWithValueStackV.alpha = 0.0
        } completion: { _ in
            self.mSearchWithValueStackV.isHidden = true
            
        }
    }
    
}

//MARK: UIScrollViewDelegate
//MARK: ----------------------------
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ( scrollView.contentOffset.y == 0) {
            // move up
            if isScrolled {
                isScrolled = !isScrolled
                if isSearchEdit {
                    self.animateSearchEdit(isShow: false)
                }
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
