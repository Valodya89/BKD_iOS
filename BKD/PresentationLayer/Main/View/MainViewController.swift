//
//  MainViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-05-21.
//

import UIKit
import SideMenu


let timePrice: Double = 59.99
let customLocationPrice: Double = 42.99


class MainViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mAvalableCategoriesTbV: UITableView!
    @IBOutlet weak var mCarCollectionV: UICollectionView!
    @IBOutlet weak var mChatWithUsBckgV: UIView!
    @IBOutlet weak var mChatWithUsAlphaV: UIView!
    @IBOutlet weak var mChatWithUsBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    //MARK: - Variables
    private lazy  var carouselVC = CarouselViewController.initFromStoryboard(name: Constant.Storyboards.carousel)
    let mainViewModel: MainViewModel = MainViewModel()
    lazy var searchModel: SearchModel = SearchModel()
    var menu: SideMenuNavigationController?
    var searchHeaderV: SearchHeaderView?
    var searchResultV: SearchResultView?
    var pickerState: DatePicker?

    private var cars = [CarsModel]()
    private var pickerList: [String]?
    var workingTimes: WorkingTimes?

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
    private var isOnline: Bool = false



    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //getCars()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
   }
    
    
    func setupView() {
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

       addHeaderViews()
        addCarousel()
        configureCarsCollectionView()
        configureAvalableCategoriesTableView()
        configureDelegates()
        self.selectedEdit()
        self.showLocation()
        self.showFilter()
        self.updateCategory()
        
    }
    
    // set info to setSearch model
    private func setSearchModel(){
        searchModel.pickUpDate = searchHeaderV?.pickUpDate
        searchModel.returnDate = searchHeaderV?.returnDate
        searchModel.pickUpTime = searchHeaderV?.pickUpTime
        searchModel.returnTime = searchHeaderV?.returnTime
        searchModel.pickUpLocation = searchResultV?.mPickUpLocationLb.text
        searchModel.returnLocation = searchResultV?.mReturnLocationLb.text
    }
    
    
    private func configureDelegates() {
        mCarCollectionV.delegate = self
        mCarCollectionV.dataSource = self
        mAvalableCategoriesTbV.delegate = self
        mAvalableCategoriesTbV.dataSource = self
        searchHeaderV?.delegate = self
    }
    
    private func configureCarsCollectionView() {
        self.mCarCollectionV.contentInset = UIEdgeInsets(top: (searchHeaderV?.frame.size.height)!, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.register(MainCollectionViewCell.nib(), forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        self.mCarCollectionV.register(SearchResultCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.mCarCollectionV.register(FilterSearchResultCell.nib(), forCellWithReuseIdentifier: FilterSearchResultCell.identifier)
    }
    
    private func configureAvalableCategoriesTableView () {
        mAvalableCategoriesTbV.register(CategoryTableViewCell.nib(),
                                             forCellReuseIdentifier: CategoryTableViewCell.identifier)
        mAvalableCategoriesTbV.separatorStyle = .none
    }
    
    
    private func setCollationViewPosittion(top: CGFloat) {
        self.mCarCollectionV.contentInset = .init(top: top, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.setContentOffset(.init(x: 0, y: -top), animated: false)
    }
    
    private func setTableViewPosittion(top: CGFloat) {
        self.mAvalableCategoriesTbV.contentInset = .init(top: top, left: 0, bottom: 0, right: 0)
        self.mAvalableCategoriesTbV.setContentOffset(.init(x: 0, y: -top), animated: false)
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
    
    func addCarousel() {
        addChild(carouselVC)
        carouselVC.view.frame = (searchHeaderV?.mCarouselV.bounds)!
        
        searchHeaderV?.mCarouselV.addSubview(carouselVC.view)
        carouselVC.didMove(toParent: self)
    }
    
    
    private func addHeaderViews() {
        //add top views
        searchHeaderV = SearchHeaderView()
        searchHeaderHeight = (view.frame.height * 0.455) + (searchHeaderV?.mCarouselV.bounds.height)! //view.frame.height * 0.5928
        collactionViewTop = searchHeaderHeight
        searchHeaderV!.frame = CGRect(x: 0, y: top_searchResult, width: self.view.bounds.width, height: searchHeaderHeight)
        self.view.addSubview(searchHeaderV!)
        
        searchResultV = SearchResultView()
        searchResultHeight = view.frame.height * 0.123762
        searchResultV!.frame = CGRect(x: 0, y: -200, width: self.view.bounds.width, height: searchResultHeight)
        self.view.addSubview(searchResultV!)
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
    private func goToDetailPage(vehicleModel: VehicleModel,         isSearchEdit: Bool) {
        
        let detailsVC = UIStoryboard(name: Constant.Storyboards.details, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.details) as! DetailsViewController
        if isSearchEdit {
            setSearchModel()
            detailsVC.searchModel = searchModel
        }
        detailsVC.isSearchEdit = isSearchEdit
        detailsVC.vehicleModel = vehicleModel
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    //MARK: Animations
    //MARK: -----------------------------
    //Will be hide search header and  show search result
    private func animateSearchResult(){
        self.updateSearchResultFields()
        animateSearchResultContainer(isThereResult: !isNoSearchResult)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                self.searchHeaderV?.frame = CGRect(x: 0, y: -900, width: self.searchHeaderV!.bounds.width, height: self.searchHeaderV!.bounds.height)
                self.searchResultV!.frame = CGRect(x: 0, y: top_searchResult, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                self.setCollationViewPosittion(top: searchResultHeight + top_searchResult)
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
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                if self.isPressedFilter == true  {
                    self.isPressedFilter = !self.isPressedFilter
                    self.searchResultV!.isPressedFilter = self.isPressedFilter
                    self.searchResultV?.mFilterImgV.image = img_unselected_filter
                    self.mCarCollectionV.reloadData()
                }
                if self.isPressedEdit == true {
                    collactionViewTop = (view.frame.height * 0.5928) + 70
                    self.setCollationViewPosittion(top: collactionViewTop)
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
    
    /// if there is any search result it will show car CollectionView else it will show avalable categories TableView
    private func animateSearchResultContainer (isThereResult : Bool) {
        searchResultV?.mFilterV.isHidden = !isThereResult
        searchResultV?.mNoticeLb.isHidden = isThereResult
        
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
            UIView.animate(withDuration: 0.7) { [weak self] in
                self?.mAvalableCategoriesTbV.alpha = 1.0
            } completion: { [self] _ in
                self.mCarCollectionV.alpha = 0.0
            }
            self.mCarCollectionV.isHidden = true
        }
    }
    
  
   //MARK: - Checkings
    //MARK: -----------------------------
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
        workingTimes = ApplicationSettings.shared.workingTimes
        guard let _ = workingTimes else { return }
        mainViewModel.isReservetionInWorkingHours(time: searchHeaderV?.pickUpTime, workingTimes: workingTimes! ) { [self] (result) in
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
            return
            
        }
            mainViewModel.isReservetionMoreHalfHour(pickUpDate: pickUpDate, returnDate: returnDate, pickUpTime: pickUpTime, returnTime: returnTime) { (result) in

                if !result {
                    BKDAlert().showAlertOk(on: self, message: Constant.Texts.lessThan30Minutes, okTitle: "ok", okAction: {
                        self.searchHeaderV?.resetReturnTime()
                    })
                }
            }
    }
    
   
    /// Returns the amount of months from another date
    func months(from date: Date, toDate: Date) -> Int {
            return Calendar.current.dateComponents([.month], from: date, to: toDate).month ?? 0
        }
    //MARK: - Alert Methods
    //MARK: ---------------------------
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
                             message: Constant.Texts.messageWorkingTime + "(\(workingTimes?.workStart ?? "") -  \(workingTimes?.workEnd ?? "")).",
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
                                self.goToCustomLocationMap()
                             })
    }
    
    
    func  showFilter()  {
        searchResultV?.didPressFilter = { [weak self] isShowFilter in
            self?.isPressedFilter = isShowFilter
            let indexPath = IndexPath(row:0, section: 0)
            if isShowFilter {
                self?.mCarCollectionV.insertItems(at: [indexPath])
            } else {
                self?.mCarCollectionV.deleteItems(at: [indexPath])
            }
            self?.mCarCollectionV.scrollToItem(at: IndexPath(item: 0, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: true)
        }
    }
    
    //Will put new values from pickerDate
    func showSelectedDate(dayBtn : UIButton?, monthBtn: UIButton?) {
        if responderTxtFl.tag > 1 {
            responderTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)

            responderTxtFl.text = pickerList![ pickerV.selectedRow(inComponent: 0)]
//            responderTxtFl.text = datePicker.date.getHour()
            responderTxtFl.textColor = color_entered_date
            searchHeaderV?.mTimeLb.textColor = color_search_placeholder

        } else {
            dayBtn?.setTitle(String(datePicker.date.get(.day)), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
            searchHeaderV?.mDateLb.textColor = color_search_placeholder
        }
    }
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        searchHeaderV!.mLocationDropDownView.didSelectSeeMap = { [weak self] parkingModel  in
            let seeMapContr = UIStoryboard(name: Constant.Storyboards.seeMap, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.seeMap) as! SeeMapViewController
            seeMapContr.parking = parkingModel
            self?.navigationController?.pushViewController(seeMapContr, animated: true)
        }
    }
    ///will go to custom location map screen
    func goToCustomLocationMap() {
        let customLocationContr = UIStoryboard(name: Constant.Storyboards.customLocation, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.customLocation) as! CustomLocationViewController
        customLocationContr.delegate = self
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    
  //MARK: - Selected Closures
    //MARK ------------------------------

    
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
        isSearchResultPage = false
        isPressedEdit = true
        isNoSearchResult = false
        
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
    
    /// Hide Date views in search View
    func hideDateInfo(dayBtn : UIButton, monthBtn: UIButton, hidden: Bool, txtFl: UITextField)  {
        dayBtn.isHidden = hidden
        monthBtn.isHidden = hidden
        if hidden == false {
            responderTxtFl.text = ""
        }
    }
    
    
    /// Will open Chat View Controller
    private func openChatPage () {
        if isOnline {
            let onlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.onlineChat) as! OnlineChatViewController
            self.navigationController?.pushViewController(onlineChat, animated: true)
        } else {
            let offlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.offlineChat) as! OfflineViewController
            self.navigationController?.pushViewController(offlineChat, animated: true)
        }
    }
    
    
    //MARK: - Actions
    //MARK: ----------------------------
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
    
    
    @objc func donePressed() {
        
        responderTxtFl.resignFirstResponder()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        switch pickerState {
        case .pickUpDate:
            searchHeaderV?.pickUpDate = datePicker.date
            hideDateInfo(dayBtn: searchHeaderV!.mDayPickUpBtn,
                         monthBtn: searchHeaderV!.mMonthPickUpBtn,
                         hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: searchHeaderV!.mDayPickUpBtn,
                             monthBtn: searchHeaderV!.mMonthPickUpBtn)
            self.checkReservetionHalfHour()

        case .returnDate:
            checkMonthReservation()
            searchHeaderV?.returnDate = datePicker.date
            hideDateInfo(dayBtn: searchHeaderV!.mDayReturnDateBtn,
                         monthBtn: searchHeaderV!.mMonthReturnDateBtn,
                         hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: searchHeaderV!.mDayReturnDateBtn,
                             monthBtn: searchHeaderV!.mMonthReturnDateBtn)
            self.checkReservetionHalfHour()

        default:
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            if pickerState == .pickUpTime {
                searchHeaderV?.pickUpTime = timeStr.stringToDate()
            } else {
                //check if more then half hour
                searchHeaderV?.returnTime = timeStr.stringToDate()
            }
            showSelectedDate(dayBtn: nil, monthBtn: nil)
            self.checkReservetionTime()

        }
        
        //Checking the filling of any fields and removing the error color from the field
        if searchHeaderV!.mErrorMessageLb.isHidden == false {
            let _ = searchHeaderV!.checkFieldsFilled()
        }
        
    }
    
}


//MARK:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
//MARK: -----------------------
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDataSource
    //MARK: -------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPressedFilter {
            return 5 + 1
        }
        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        // will show Main cell
        if !isSearchResultPage {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            (cell as! MainCollectionViewCell).setCellInfo(item: cars[indexPath.item])
        } else {
            if isPressedFilter  {
                // will show filter cell
                if indexPath.row == 0 {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterSearchResultCell.identifier, for: indexPath) as! FilterSearchResultCell
                } else {
                    // will show search result cell
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell                    
                }
            } else {
                // will show search result cell
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
                (cell as! SearchResultCollectionViewCell).setSearchResultCellInfo( item: cars[indexPath.row] , index: indexPath.row)
                (cell as! SearchResultCollectionViewCell).delegate = self
            }

        }
        return cell
    }

    //MARK: UICollectionViewDelegate
    //MARK: -------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isSearchResultPage {
            let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
            let vehicleModel =  cell.setVehicleModel(carModel: cars[indexPath.row])
            goToDetailPage(vehicleModel: vehicleModel,
                           isSearchEdit: false)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCollectionViewCell
            var vehicleModel =  cell.setVehicleModel()
            vehicleModel.customLocationTotalPrice = SearchHeaderViewModel().getCustomLocationTotalPrice(searchV:searchHeaderV!)
            goToDetailPage(vehicleModel: vehicleModel,
                           isSearchEdit: true)
        }
    }

    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPressedFilter &&  indexPath.row == 0{
            return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.306931)
        }
        return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.441832)
    }
}


//MARK: SearchResultCellDelegate
//MARK: ----------------------------
extension MainViewController: SearchResultCellDelegate {
    
    func didPressMore() {
        let detailsVC = UIStoryboard(name: Constant.Storyboards.details, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.details) as! DetailsViewController
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func didPressReserve(tag: Int) {
        let cell = mCarCollectionV.cellForItem(at: IndexPath(item: tag, section: 0)) as! SearchResultCollectionViewCell
        var vehicleModel =  cell.setVehicleModel()
        vehicleModel.customLocationTotalPrice = SearchHeaderViewModel().getCustomLocationTotalPrice(searchV:searchHeaderV!)
        goToDetailPage(vehicleModel: vehicleModel,
                       isSearchEdit: true)
    }
}

//MARK: SearchHeaderViewDelegate
//MARK: ----------------------------
extension MainViewController: SearchHeaderViewDelegate {
    
    func hideEditView() {
        if !isNoSearchResult {
            navigationController!.navigationBar.topItem?.title = Constant.Texts.searchResult
            animateSearchResult()
        } else {
            navigationController!.navigationBar.topItem?.title = ""
            animateAvalableCategoriesResult()
        }
    }
    
    func didSelectSearch() {
        isSearchResultPage = true
        isPressedEdit = false
        searchHeaderV?.layer.shadowOpacity = 1.0
        
        mLeftBarBtn.image = img_back
        mRightBarBtn.image = img_chat
        mChatWithUsBckgV.isHidden = true
        mCarCollectionV.reloadData()
        
        // If will not  found result
        // must be change by api result
        if carouselVC.currentPage == 2 {
            isNoSearchResult = true
            navigationController!.navigationBar.topItem?.title = ""
            animateAvalableCategoriesResult()
        } else {
            navigationController!.navigationBar.topItem?.title = Constant.Texts.searchResult
            isNoSearchResult = false
            animateSearchResult()
        }
    }
    
    func didSelectLocation(_ locationStr: String, _ btnTag: Int) {
        if ((isPressedEdit) == true) {
            if btnTag == 4 { //pick up location
                searchHeaderV?.pickUpLocation = locationStr
            } else {
                searchHeaderV?.returnLocation = locationStr
            }
        }
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
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    
    func didSelectCustomLocation(_ btn: UIButton) {
//        self.showAlertCustomLocation(checkedBtn: btn)
        goToCustomLocationMap()
    }
    
    
}
//MARK: CustomLocationUIViewControllerDelegate
//MARK: ----------------------------
extension MainViewController: CustomLocationViewControllerDelegate {
    func getCustomLocation(_ locationPlace: String) {
        searchHeaderV?.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchHeaderV?.pickUpLocation = locationPlace
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
            } else {
                self?.searchHeaderV?.returnLocation = locationPlace
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
            }
        })
    }
}


//MARK: UITableViewDataSource
//MARK: -----------------------------
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return CategoryData.avalableCategoryModel.count
   }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell

       let categoryModel: CategoryModel = CategoryData.avalableCategoryModel[indexPath.row]
       cell.mCategoryNameLb.text = categoryModel.categoryName
       cell.collectionData = CategoryData.avalableCategoryModel[indexPath.row]
       return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return self.view.frame.size.height * 0.222772;
   }
   
}


// MARK: - UIScrollView Delegate
//MARK:-----------------------
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Change top view position and alpha
        
        if (searchHeaderV?.frame.origin.y)! <= 12 {
            searchHeaderV!.frame.origin.y = -abs(collactionViewTop + scrollView.contentOffset.y) + 12
            
        }
        
    }
   
}


//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

