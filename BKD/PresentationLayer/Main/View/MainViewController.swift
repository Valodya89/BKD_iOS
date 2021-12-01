//
//  MainViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-05-21.
//

import UIKit
import SideMenu
import CoreLocation


let timePrice: Double = 59.99
let customLocationPrice: Double = 42.99


class MainViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mAvalableCategoriesTbV: UITableView!
    @IBOutlet weak var mCarCollectionV: UICollectionView!
    @IBOutlet weak var mChatWithUsBckgV: UIView!
    @IBOutlet weak var mChatWithUsAlphaV: UIView!
    @IBOutlet weak var mChatWithUsBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    //MARK: -- Variables
    private lazy  var carouselVC = CarouselViewController.initFromStoryboard(name: Constant.Storyboards.carousel)
    private let mainViewModel: MainViewModel = MainViewModel()
    lazy var searchModel: SearchModel = SearchModel()
    var menu: SideMenuNavigationController?
    var searchHeaderV: SearchHeaderView?
    var searchResultV: SearchResultView?
    var pickerState: DatePicker?

    private var cars = [CarsModel]()
    private var carTypes:[CarTypes]?
    private var carsList:[String : [CarsModel]?]?
    private var pickerList: [String]?
    var settings: Settings?
    var currentCarType: CarTypes?

    var datePicker = UIDatePicker()
    let pickerV = UIPickerView()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()

    private var collactionViewTop: CGFloat = 0.0
    private var searchHeaderHeight: CGFloat = 0.0
    private var searchResultHeight: CGFloat = 0.0
    private var searchHeaderEditHeight: CGFloat = 0.0

    private var isSearchResultPage: Bool = false
    private var isPressedFilter: Bool = false
    private var isPressedEdit: Bool = false
    private var isNoSearchResult: Bool = false
    private var needsUpdateFilterCell: Bool = false


    //MARK: -- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.setTabBarBackgroundColor(color: color_background!)
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
   }
    
//MARK: -- Set
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_search_title!, NSAttributedString.Key.foregroundColor: UIColor.white]
        backgroundV.frame = self.view.bounds
        backgroundV.backgroundColor = .black
        backgroundV.alpha = 0.6
        mChatWithUsAlphaV.layer.cornerRadius = 8
        mChatWithUsAlphaV.backgroundColor = mChatWithUsAlphaV.backgroundColor?.withAlphaComponent(0.8)
        
        // menu
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mRightBarBtn.image = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)

        configureHeaderViews()
        addCarousel()
        configureCarsCollectionView()
        configureAvalableCategoriesTableView()
        configureDelegates()
        self.selectedEdit()
        self.showLocation()
        self.showFilter()
        self.updateCategory()
        
    }
    
    ///set CollationView Posittion
    private func setCollationViewPosittion(top: CGFloat) {
        self.mCarCollectionV.contentInset = .init(top: top, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.setContentOffset(.init(x: 0, y: -top), animated: false)
    }
    
    ///set TableView Posittion
    private func setTableViewPosittion(top: CGFloat) {
        self.mAvalableCategoriesTbV.contentInset = .init(top: top, left: 0, bottom: 0, right: 0)
        self.mAvalableCategoriesTbV.setContentOffset(.init(x: 0, y: -top), animated: false)
    }
    
    // set info to search model
    private func setSearchModel(){
        searchModel.pickUpDate = searchHeaderV?.pickUpDate
        searchModel.returnDate = searchHeaderV?.returnDate
        searchModel.pickUpTime = searchHeaderV?.pickUpTime
        searchModel.returnTime = searchHeaderV?.returnTime
        searchModel.pickUpLocation = searchResultV?.mPickUpLocationLb.text
        searchModel.returnLocation = searchResultV?.mReturnLocationLb.text
    }
    
   //MARK: -- Configure UI
    private func configureDelegates() {
        mCarCollectionV.delegate = self
        mCarCollectionV.dataSource = self
        mAvalableCategoriesTbV.delegate = self
        mAvalableCategoriesTbV.dataSource = self
        searchHeaderV?.delegate = self
    }
    
    private func configureCarsCollectionView() {
        self.mCarCollectionV.contentInset = UIEdgeInsets(top: top_searchResult, left: 0, bottom: 0, right: 0)//n
//        self.mCarCollectionV.contentInset = UIEdgeInsets(top: (searchHeaderV?.frame.size.height)!, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.register(MainCollectionViewCell.nib(), forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        self.mCarCollectionV.register(SearchResultCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.mCarCollectionV.register(FilterSearchResultCell.nib(), forCellWithReuseIdentifier: FilterSearchResultCell.identifier)
    }
    
    
   ///Configure search header view
    private func configureHeaderViews() {
        //add top views
        searchHeaderV = SearchHeaderView()
        searchHeaderHeight = (view.frame.height * 0.455) + (searchHeaderV?.mCarouselV.bounds.height)! //view.frame.height * 0.5928
        collactionViewTop = searchHeaderHeight
        searchHeaderV!.frame = CGRect(x: 0, y: top_searchResult, width: self.view.bounds.width, height: searchHeaderHeight)
        mCarCollectionV.addSubview(searchHeaderV!)//n
    //self.view.addSubview(searchHeaderV!)
        
        searchResultV = SearchResultView()
        searchResultHeight = view.frame.height * 0.123762
        searchResultV!.frame = CGRect(x: 0, y: -200, width: self.view.bounds.width, height: searchResultHeight)
        self.view.addSubview(searchResultV!)
    }
    
    private func configureAvalableCategoriesTableView () {
        mAvalableCategoriesTbV.register(CategoryTableViewCell.nib(),
                                             forCellReuseIdentifier: CategoryTableViewCell.identifier)
        mAvalableCategoriesTbV.separatorStyle = .none
    }
    
    
    //Add Carousel child controller
    func addCarousel() {
        addChild(carouselVC)
        carouselVC.view.frame = (searchHeaderV?.mCarouselV.bounds)!
        searchHeaderV?.mCarouselV.addSubview(carouselVC.view)
        carouselVC.didMove(toParent: self)
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
    
    /// Update search result fiels
    private func updateSearchResultFields() {
        self.searchResultV?.updateSearchResultFields(pickUpDay: self.searchHeaderV?.mDayPickUpBtn.title(for: .normal),
                                                     pickUpMonth: self.searchHeaderV?.mMonthPickUpBtn.title(for: .normal),
                                                     returnDay: self.searchHeaderV?.mDayReturnDateBtn.title(for: .normal),
                                                     returnMonth: self.searchHeaderV?.mMonthReturnDateBtn.title(for: .normal),
                                                     pickUpLocation: self.searchHeaderV?.mPickUpLocationBtn.title(for: .normal),
                                                     returnLocation: self.searchHeaderV?.mReturnLocationBtn.title(for: .normal))
    }

    ///will open detail controller
    private func goToDetailPage(vehicleModel: VehicleModel,
                                isSearchEdit: Bool,
                                isClickMore: Bool) {
        
        let detailsVC = UIStoryboard(name: Constant.Storyboards.details, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.details) as! DetailsViewController
        if isSearchEdit {
            setSearchModel()
            detailsVC.searchModel = searchModel
        }
        detailsVC.isSearchEdit = isSearchEdit
        detailsVC.isClickMore = isClickMore
        detailsVC.vehicleModel = vehicleModel
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    //MARK: -- Animations

    //Will be hide search header and  show search result
    private func animateSearchResult(){
        self.updateSearchResultFields()
        animateSearchResultContainer(isThereResult: !isNoSearchResult)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                self.searchHeaderV?.frame = CGRect(x: 0, y: -900, width: self.searchHeaderV!.bounds.width, height: self.searchHeaderV!.bounds.height)
                self.searchResultV!.frame = CGRect(x: 0, y: top_searchResult, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                //n
                self.setCollationViewPosittion(top: searchResultHeight)
                mCarCollectionV.reloadData()
//                self.setCollationViewPosittion(top: searchResultHeight + top_searchResult)
                self.searchHeaderV?.alpha = 0
            }, completion: { [self] _ in
                self.searchHeaderV?.isHidden = true
            })
        }
    }
    
    /// will be show avalable categories
    private func animateAvalableCategoriesResult(){
        
        self.updateSearchResultFields()
        animateSearchResultContainer(isThereResult: !isNoSearchResult)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                self.searchHeaderV?.frame = CGRect(x: 0, y: -900, width: self.searchHeaderV!.bounds.width, height: self.searchHeaderV!.bounds.height)
                self.searchResultV!.frame = CGRect(x: 0, y: top_searchResult, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                self.setTableViewPosittion(top: searchResultHeight + top_searchResult + top_avalableCategoryTbv)
                self.searchHeaderV?.alpha = 0
            }, completion: { [self] _ in
                self.searchHeaderV?.isHidden = true
            })
        }
    }
    
    //Will be show search header for edit fields
    private func animateSearchHeader(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut], animations: { [self] in
                if self.isPressedFilter == true  {
                    self.isPressedFilter = !self.isPressedFilter
                    self.searchResultV!.isPressedFilter = self.isPressedFilter
                    self.searchResultV?.mFilterImgV.image = img_unselected_filter
                    self.mCarCollectionV.reloadData()
                }
                if self.isPressedEdit == true {
                    collactionViewTop = (view.frame.height * 0.5928) + 70
                    self.setCollationViewPosittion(top: top_searchResult)//n
                    mCarCollectionV.reloadData()
                    //  self.setCollationViewPosittion(top: collactionViewTop)
                } else {
                    collactionViewTop = view.frame.height * 0.5928
                    self.setCollationViewPosittion(top: searchHeaderHeight)
                }
                self.searchHeaderV?.isHidden = false
                self.searchHeaderV?.frame = CGRect(x: 0, y: top_searchResult, width: self.searchHeaderV!.bounds.width, height: searchHeaderHeight)
                self.searchResultV!.frame = CGRect(x: 0, y: -200, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                self.searchHeaderV?.alpha = 1.0
                
            }, completion: { _ in
                
            })
        }
    }
    
    /// if there is any search result will show car CollectionView else will show avalable categories TableView
    private func animateSearchResultContainer (isThereResult : Bool) {
        carTypes = ApplicationSettings.shared.carTypes
        carsList = ApplicationSettings.shared.carsList
        currentCarType =  carTypes![carouselVC.currentPage]
        searchResultV?.mFilterV.isHidden = !isThereResult
        searchResultV?.mNoticeLb.isHidden = isThereResult
        searchResultV?.mNoticeLb.text = String(format: Constant.Texts.notCategory, currentCarType!.name)
        
        if isThereResult { // will show avalable cars
            self.mCarCollectionV.isHidden = false
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.mAvalableCategoriesTbV.alpha = 0.0
            } completion: { [self] _ in
                self.mCarCollectionV.alpha = 1.0
                self.mAvalableCategoriesTbV.isHidden = true
            }

        } else { // will show avalable categories
            self.mAvalableCategoriesTbV.isHidden = false
            self.mAvalableCategoriesTbV.reloadData()
            UIView.animate(withDuration: 0.7) { [weak self] in
                self?.mAvalableCategoriesTbV.alpha = 1.0
            } completion: { [self] _ in
                self.mCarCollectionV.alpha = 0.0
            }
            self.mCarCollectionV.isHidden = true
        }
    }
    
  
   //MARK: -- Checkings
    
    ///check if reservation date more than 90 days
    func checkIfReservationMoreThan90Days() -> Bool {
        setSearchModel()
        if  mainViewModel.isReservetionMore90Days(search: searchModel) {
                BKDAlert().showAlertOk(on: self, message: Constant.Texts.max90Days, okTitle: Constant.Texts.ok) {
                    self.searchHeaderV?.resetReturnDate()
                    self.searchHeaderV?.resetReturnTime()
            }
            return true
        }
        return false
    }
    
    ///check if reservation date more than a month
    func checkMonthReservation() {
        var pickUpDate: Date? = searchHeaderV?.pickUpDate
        var returnDate: Date? = searchHeaderV?.returnDate
        if pickerState == .pickUpDate {
            pickUpDate = datePicker.date
        } else if pickerState == .returnDate {
            returnDate = datePicker.date
        }
        mainViewModel.isReservetionMoreThanMonth(pickUpDate: pickUpDate, returnDate: returnDate) { (result) in
            if result {
                self.showAlertMoreThanMonth()
            }
        }
    }
   
    /// check if reservetion time in range
    func checkReservetionTime() {
        settings = ApplicationSettings.shared.settings
        guard let _ = settings else { return }
        mainViewModel.isReservetionInWorkingHours(time: searchHeaderV?.pickUpTime, settings: settings! ) { [self] (result) in
            if !result {
                self.showAlertWorkingHours()
            } else {
                self.checkReservetionHalfHour()
            }
        }
    }
    
    
    
    ///Check if reservetion more then half hour
    func checkReservetionHalfHour() {
        guard let pickUpDate = searchHeaderV?.pickUpDate,
              let returnDate = searchHeaderV?.returnDate,
              let pickUpTime = searchHeaderV?.pickUpTime,
              let returnTime = searchHeaderV?.returnTime else {
                  if (searchHeaderV?.pickUpTime != nil || searchHeaderV?.returnTime != nil) &&
                        (pickerState == .returnTime || pickerState == .pickUpTime )  {
                      searchHeaderV?.updateTime(responderTxtFl: responderTxtFl, text: pickerList![ pickerV.selectedRow(inComponent: 0)])
                  }
            return
            
        }
            mainViewModel.isReservetionMoreHalfHour(pickUpDate: pickUpDate, returnDate: returnDate, pickUpTime: pickUpTime, returnTime: returnTime) { (result) in

                if !result {
                    BKDAlert().showAlertOk(on: self, message: Constant.Texts.lessThan30Minutes, okTitle: "ok", okAction: {
                        if self.pickerState == .pickUpTime {
                            self.searchHeaderV?.updateTime(responderTxtFl: self.responderTxtFl, text: self.pickerList![ self.pickerV.selectedRow(inComponent: 0)])
                        }
                        self.searchHeaderV?.resetReturnTime()
                    })
                } else if self.pickerState == .returnTime || self.pickerState == .pickUpTime {
                    
                    self.searchHeaderV?.updateTime(responderTxtFl: self.responderTxtFl, text: self.pickerList![ self.pickerV.selectedRow(inComponent: 0)])
                }
            }
    }
    
   
    /// Returns the amount of months from another date
    func months(from date: Date, toDate: Date) -> Int {
            return Calendar.current.dateComponents([.month], from: date, to: toDate).month ?? 0
        }
    
    //MARK: -- Alert Methods
    func showAlertMoreThanMonth() {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.messageMoreThanMonth,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: { [self] in
                                self.searchHeaderV?.mDayReturnDateBtn.isHidden = true
                                self.searchHeaderV?.mMonthReturnDateBtn.isHidden = true
                                self.searchHeaderV?.mReturnDateTxtFl.isHidden = false
                                self.searchHeaderV?.mReturnDateTxtFl.text = Constant.Texts.returnDate
                             }, okAction: nil)
        
    }
    
    func showAlertWorkingHours() {
        BKDAlert().showAlert(on: self,
                             title:String(format: Constant.Texts.titleWorkingTime, timePrice),
                             message: Constant.Texts.messageWorkingTime + "(\(settings?.workStart ?? "") -  \(settings?.workEnd ?? "")).",
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: { [self] in
                                self.searchHeaderV?.configureTimeTextField(txtFl: responderTxtFl)
                             }, okAction: {
                                self.checkReservetionHalfHour()
                             })
    }
    
    func showAlertCustomLocation(checkedBtn: UIButton) {
        BKDAlert().showAlert(on: self,
                             title:String(format: Constant.Texts.titleCustomLocation, customLocationPrice),
                             message: Constant.Texts.messageCustomLocation,
                             messageSecond: Constant.Texts.messageCustomLocation2,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: {
                                checkedBtn.setImage(img_uncheck_box, for: .normal)
                             }, okAction: { [self] in
                                 self.goToCustomLocationMapController(on: self, isAddDamageAddress: false)
                             })
    }
    
    //show filter cell
    func  showFilter()  {
        searchResultV?.didPressFilter = { [weak self] isShowFilter, needsUpdateFilterCell in
            self?.isPressedFilter = isShowFilter
            let indexPath = IndexPath(row:0, section: 0)
            if isShowFilter {
                self?.mCarCollectionV.insertItems(at: [indexPath])
            } else {
                self?.mCarCollectionV.deleteItems(at: [indexPath])
            }
            self?.mCarCollectionV.scrollToItem(at: IndexPath(item: 0, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: true)
            if isShowFilter && needsUpdateFilterCell  {
               self?.needsUpdateFilterCell = needsUpdateFilterCell
                 self?.mCarCollectionV.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
    }
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        searchHeaderV!.mLocationDropDownView.didSelectSeeMap = { [weak self] parkingModel  in
            self?.goToSeeMap(parking: parkingModel)
        }
    }

    
  //MARK: -- Selected Closures
    
    func selectedEdit() {
        searchResultV?.didPressEdit = { [weak self] in
            self?.isPressedEdit = true
            self?.animateSearchHeader()
            self?.searchHeaderV?.setShadow(color:  color_shadow!)
            self?.searchHeaderV?.mArrowBtn.isHidden = false
            self?.searchHeaderV?.mSearchBckgV.isUserInteractionEnabled = false
            self?.searchHeaderV?.mSearchBckgV.alpha = 0.8
            self?.searchHeaderV?.mSearchLeading.constant = 0
            self?.searchHeaderV?.layoutIfNeeded()
            if self!.isNoSearchResult {
                self?.isSearchResultPage = false
                self?.mCarCollectionV.reloadData()
                self?.animateSearchResultContainer(isThereResult: self!.isNoSearchResult)
                self?.navigationController!.navigationBar.topItem?.title = ""
            }
        }
    }
    
    
    func selectedBack(isBackFromResult: Bool) {
        isPressedFilter = false
        isSearchResultPage = false
        isPressedEdit = true
        isNoSearchResult = false
        searchResultV?.isPressedFilter = false
        mCarCollectionV.reloadData()
        searchResultV?.mFilterImgV.image = img_unselected_filter
        animateSearchResultContainer(isThereResult: isBackFromResult)
        navigationController!.navigationBar.topItem?.title = ""
        mLeftBarBtn.image = img_menu
        mRightBarBtn.image = img_bkd
        mChatWithUsBckgV.isHidden = isSearchResultPage
        searchHeaderV?.mSearchBckgV.isUserInteractionEnabled = true
        searchHeaderV?.mSearchBckgV.alpha = 1.0
        searchHeaderV?.mArrowBtn.isHidden = true
        searchHeaderV?.layer.shadowOpacity = 0.0
        searchHeaderV?.mSearchLeading.constant = 0
        self.view.layoutIfNeeded()
        cars = (carsList?[currentCarType!.id] ?? []) ?? []
        mCarCollectionV.reloadData()
        animateSearchHeader()
    }

    func updateCategory() {
        carouselVC.didChangeCategory = { [weak self] categoryIndex in
            self?.searchModel.category = categoryIndex
            self?.searchHeaderV?.categore = categoryIndex
        }
        
        carouselVC.updateCarList = { [weak self] carModel in
            guard let self = self else { return }
            self.cars = carModel
            self.mCarCollectionV.reloadData()
        }
    }
    
    /// Will open Chat View Controller
    private func openChatPage () {
        if mainViewModel.isOnline {
            let onlineChat = OnlineChatViewController.initFromStoryboard(name: Constant.Storyboards.chat)
            self.navigationController?.pushViewController(onlineChat, animated: true)
        } else {
            let offlineChat = OfflineViewController.initFromStoryboard(name: Constant.Storyboards.chat)
            self.navigationController?.pushViewController(offlineChat, animated: true)
        }
    }
    
    
    //MARK: -- Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        if isSearchResultPage || isNoSearchResult  {
            selectedBack(isBackFromResult: true)
        } else {
            present(menu!, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func rightBar(_ sender: UIBarButtonItem) {
        if isSearchResultPage {
            openChatPage ()
        }
    }
    
    @IBAction func chatWithUs(_ sender: UIButton) {
        openChatPage ()
    }
    
    
    ///Handler done of tool bar
    @objc func donePressed() {
        
        responderTxtFl.resignFirstResponder()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        switch pickerState {
        case .pickUpDate:
            searchHeaderV?.pickUpDate = datePicker.date
            if  !checkIfReservationMoreThan90Days() {
                searchHeaderV!.updatePickUpDate(datePicker: datePicker)
                self.checkReservetionHalfHour()
            }

        case .returnDate:
            searchHeaderV?.returnDate = datePicker.date
            if  !checkIfReservationMoreThan90Days() {
                checkMonthReservation()

                searchHeaderV?.updateReturnDate(datePicker: datePicker)
                self.checkReservetionHalfHour()
            }

        default:
            guard let _ = pickerList else { return }
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            if pickerState == .pickUpTime {
                searchHeaderV?.pickUpTime = timeStr.stringToDate()
            } else {
                //check if more then half hour
                searchHeaderV?.returnTime = timeStr.stringToDate()
            }
            if  !checkIfReservationMoreThan90Days() {
                self.checkReservetionTime()
            }
        }
        
        //Checking the filling of any fields and removing the error color from the field
        if searchHeaderV!.mErrorMessageLb.isHidden == false {
            let _ = searchHeaderV!.checkFieldsFilled()
        }
        
    }
    
}


//MARK: -- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPressedFilter {
            return cars.count + 1
        }
        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       // var cell: UICollectionViewCell
        // will show Main cell
        if !isSearchResultPage {
          let cellMain = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            cellMain.setCellInfo(item: cars[indexPath.item])
            return cellMain
        } else { // show search result page
            if isPressedFilter  {
                // will show filter cell
                if indexPath.row == 0 {
                  let cellFilter = collectionView.dequeueReusableCell(withReuseIdentifier: FilterSearchResultCell.identifier, for: indexPath) as! FilterSearchResultCell
                    cellFilter.currentCarType = currentCarType
                    if needsUpdateFilterCell {
                        cellFilter.setUpView()
                        needsUpdateFilterCell = false
                    }
                    cellFilter.filterCars = { cars in
                        self.cars = cars!
                        collectionView.reloadData()
                    }
                    return cellFilter
                } else {
                    // will show search result cell
                    return initSearchResultCell(index: indexPath.row - 1, collectionView: collectionView)
                }
            } else {
                // will show search result cell
                return initSearchResultCell(index: indexPath.row, collectionView: collectionView)
            }
        }
    }
    

    //MARK: -- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Main screen
        if !isSearchResultPage {
            let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
            let vehicleModel =  cell.setVehicleModel(carModel: cars[indexPath.row])
            goToDetailPage(vehicleModel: vehicleModel,
                           isSearchEdit: false, isClickMore: false)
        } else { //search result
            if !isPressedFilter {
            let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCollectionViewCell
            var vehicleModel =
                cell.setVehicleModel(carModel: cars[indexPath.row])
            goToDetailPage(vehicleModel: vehicleModel,
                           isSearchEdit: true, isClickMore: false)
            }
        }
    }
    

    //MARK: -- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPressedFilter &&  indexPath.row == 0{
            return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.306931)
        }
        return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.441832)
    }
    
    //n
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isSearchResultPage && !isPressedEdit{
            return  CGSize(width: collectionView.bounds.width, height: searchHeaderEditHeight)
        }
        
            return (searchHeaderV?.frame.size)!

//        if ((searchHeaderV?.isHidden) == true) {
//            return (searchHeaderV?.frame.size)!
//        } else {
           // return  CGSize(width: collectionView.bounds.width, height: searchHeaderEditHeight)

        //}
    }

    ///Search resul cell
    private func initSearchResultCell(index: Int, collectionView: UICollectionView) -> SearchResultCollectionViewCell{
        
        let cellSearch = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: IndexPath(row: index, section: 0) ) as! SearchResultCollectionViewCell
        
        cellSearch.startRendDate = searchHeaderV?.pickUpTime
        cellSearch.endRendtDate = searchHeaderV?.returnTime
        cellSearch.setSearchResultCellInfo( item: cars[index] , index: index)
        cellSearch.delegate = self
        return cellSearch
    }
}


//MARK: -- SearchResultCellDelegate
extension MainViewController: SearchResultCellDelegate {
    
    func didPressMore(tag: Int) {
        openDetails(tag: tag, isMore: true)
    }
    
    func didPressReserve(tag: Int) {
        openDetails(tag: tag, isMore: false)
    }
    
    private func openDetails(tag: Int, isMore: Bool) {
            let cell = mCarCollectionV.cellForItem(at: IndexPath(item: isPressedFilter ? (tag + 1) : tag, section: 0)) as! SearchResultCollectionViewCell
        let vehicleModel =  cell.setVehicleModel(carModel: cars[tag])
        
        goToDetailPage(vehicleModel: vehicleModel,
                       isSearchEdit: true, isClickMore: isMore)
    }
}

//MARK: -- SearchHeaderViewDelegate
extension MainViewController: SearchHeaderViewDelegate {
    
    func hideEditView() {
        if !isNoSearchResult {
            navigationController!.navigationBar.topItem?.title = Constant.Texts.searchResult
            isPressedEdit = false
            animateSearchResult()
        } else {
            navigationController!.navigationBar.topItem?.title = ""
            animateAvalableCategoriesResult()
        }
    }
    
    ///
    func didSelectSearch() {
        isSearchResultPage = true
        isPressedEdit = false
        searchHeaderV?.layer.shadowOpacity = 1.0
        
        mLeftBarBtn.image = img_back
        mRightBarBtn.image = img_chat
        mChatWithUsBckgV.isHidden = true
        mCarCollectionV.reloadData()
        
        // If will not  found result
        if cars.count == 0 {
            isNoSearchResult = true
            navigationController!.navigationBar.topItem?.title = ""
            animateAvalableCategoriesResult()
        } else {
            navigationController!.navigationBar.topItem?.title = Constant.Texts.searchResult
            isNoSearchResult = false
            animateSearchResult()
        }
    }
    
    /// Selecet location
    func didSelectLocation(_ parking: Parking, _ btnTag: Int) {
        if ((isPressedEdit) == true) {
            if btnTag == 4 { //pick up location
                searchModel.pickUpLocationId = parking.id
                searchHeaderV?.pickUpLocation = parking.name
                PriceManager.shared.pickUpCustomLocationPrice = nil
            } else {
                searchModel.returnLocationId = parking.id
                searchHeaderV?.returnLocation = parking.name
                PriceManager.shared.returnCustomLocationPrice = nil
            }
        }
    }
    
    func didDeselectCustomLocation(tag: Int) {
        if tag == 6 { //pick up custom location
            searchModel.isPickUpCustomLocation = false
            searchModel.pickUpLocation = nil
            PriceManager.shared.pickUpCustomLocationPrice = nil
        } else {//return custom location
            searchModel.isRetuCustomLocation = false
            searchModel.returnLocation = nil
            PriceManager.shared.returnCustomLocationPrice = nil
        }
        //isActiveReserve()
    }
   
    func willOpenPicker(textFl: UITextField, pickerState: DatePicker) {
        self.pickerState = pickerState
        self.view.addSubview(self.backgroundV)
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl

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
            self.datePicker.maximumDate =  Date().addMonths(12)
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    
    func didSelectCustomLocation(_ btn: UIButton) {
        self.goToCustomLocationMapController(on: self, isAddDamageAddress: false)
    }
    
    
}
//MARK: -- CustomLocationUIViewControllerDelegate
extension MainViewController: CustomLocationViewControllerDelegate {
    
    func getCustomLocation(_ locationPlace: String, coordinate: CLLocationCoordinate2D, price: Double?) {
        searchHeaderV?.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchHeaderV?.pickUpLocation = locationPlace
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
                self?.searchModel.pickUpLocationLongitude = coordinate.longitude
                self?.searchModel.pickUpLocationLatitude = coordinate.latitude
                PriceManager.shared.pickUpCustomLocationPrice = price
            } else {
                self?.searchHeaderV?.returnLocation = locationPlace
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
                self?.searchModel.returnLocationLongitude = coordinate.longitude
                self?.searchModel.returnLocationLatitude = coordinate.latitude
                PriceManager.shared.returnCustomLocationPrice = price
            }
        })
    }
}


//MARK: -- UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return carTypes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
        guard let _ = carsList else { return cell }
         cell.setCellInfo(carsList: carsList, carType: carTypes![indexPath.row])
       return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item:[CarsModel] = carsList![carTypes![indexPath.row].id]! ?? []
    if item.count == 0 {
        return 0
    }
       return self.view.frame.size.height * 0.222772;
   }
   
}


// MARK: -- UIScrollView Delegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Change top view position and alpha
        //n1
//        if (searchHeaderV?.frame.origin.y)! <= 12 {
//            searchHeaderV!.frame.origin.y = -abs(collactionViewTop + scrollView.contentOffset.y) + 12
//
//        }
        
    }
   
}


//MARK: -- UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList![row]
    }
}

