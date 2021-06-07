//
//  MainViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-05-21.
//

import UIKit
import SideMenu


class MainViewController: BaseViewController {
        
    @IBOutlet weak var mCarCollectionV: UICollectionView!
    @IBOutlet weak var mChatWithUsBckgV: UIView!
    @IBOutlet weak var mChatWithUsAlphaV: UIView!
    @IBOutlet weak var mChatWithUsBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    let mainViewModel: MainViewModel = MainViewModel()
    var menu: SideMenuNavigationController?
    var searchHeaderV: SearchHeaderView?
    var searchResultV: SearchResultView?
    let datePicker = UIDatePicker()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()

    private var collactionViewTop: CGFloat = 0.0
    private var searchHeaderHeight: CGFloat = 0.0
    private var searchResultHeight: CGFloat = 0.0
    private var searchHeaderEditHeight: CGFloat = 0.0


    private var isSearchResultPage: Bool = false
    private var isPressedFilter: Bool = false
    private var isPressedEdit: Bool = false
    private var isOnline: Bool = false

    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
   }
    
    
    func setupView() {
        UserDefaults.standard.removeObject(forKey: key_pickUpDate)
        UserDefaults.standard.removeObject(forKey: key_returnDate)
        UserDefaults.standard.removeObject(forKey: key_pickUpTime)
        UserDefaults.standard.removeObject(forKey: key_returnTime)
        UserDefaults.standard.removeObject(forKey: key_pickUpLocation)
        UserDefaults.standard.removeObject(forKey: key_returnLocation)
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
        registrCollectionView()
        self.selectedDatePicker()
        self.selectedSearch()
        self.selectedLocation()
        self.selectedCustomLocation()
        self.showLocation()
        self.showFilter()
        self.showEdit()
        self.hideEdit()
        self.updateCategory()
        
    }
    private func initTimeTextField(txtFl: UITextField, txt: String) {
        txtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 10.0)
        txtFl.text = txt
        txtFl.textColor = color_choose_date
        UserDefaults.standard.removeObject(forKey: key_pickUpTime)
        UserDefaults.standard.removeObject(forKey: key_returnTime)
        searchHeaderV?.mTimeLb.textColor = .clear
    }
    private func setCollationViewPosittion(top: CGFloat) {
        self.mCarCollectionV.contentInset = .init(top: top, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.setContentOffset(.init(x: 0, y: -top), animated: false)
    }
    
    private func registrCollectionView() {
        //CollectionView
        self.mCarCollectionV.delegate = self
        self.mCarCollectionV.dataSource = self
        self.mCarCollectionV.contentInset = UIEdgeInsets(top: (searchHeaderV?.frame.size.height)!, left: 0, bottom: 0, right: 0)
        self.mCarCollectionV.register(MainCollectionViewCell.nib(), forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        self.mCarCollectionV.register(SearchResultCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.mCarCollectionV.register(FilterSearchResultCell.nib(), forCellWithReuseIdentifier: FilterSearchResultCell.identifier)
    }
    private func addHeaderViews() {
        //add top views
        searchHeaderV = SearchHeaderView()
        searchHeaderHeight = view.frame.height * 0.5928
        collactionViewTop = searchHeaderHeight
        searchHeaderV!.frame = CGRect(x: 0, y: top_searchResult, width: self.view.bounds.width, height: searchHeaderHeight)
        self.view.addSubview(searchHeaderV!)
        
        searchResultV = SearchResultView()
        searchResultHeight = view.frame.height * 0.123762
        searchResultV!.frame = CGRect(x: 0, y: -200, width: self.view.bounds.width, height: searchResultHeight)
        self.view.addSubview(searchResultV!)
    }
    
    private func updateSearchResultFields() {
        self.searchResultV?.mPickUpDayBtn.setTitle(self.searchHeaderV?.mDayPickUpBtn.title(for: .normal), for: .normal)
        self.searchResultV?.mPickUpMonthBtn.setTitle(self.searchHeaderV?.mMonthPickUpBtn.title(for: .normal), for: .normal)
        self.searchResultV?.mReturnDayBtn.setTitle(self.searchHeaderV?.mDayReturnDateBtn.title(for: .normal), for: .normal)
        self.searchResultV?.mReturnMonthBtn.setTitle(self.searchHeaderV?.mMonthReturnDateBtn.title(for: .normal), for: .normal)
    }
    
    //MARK: ANIMATIONS
    //Will be hide search header and  show search result
    private func animateSearchResult(){
        self.updateSearchResultFields()
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
    
    @objc func donePressed() {
        responderTxtFl.resignFirstResponder()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        checkMonthReservation()
        if isPressedEdit {
            checkAnyFieldsHaveBeenEdited()
        }
        if responderTxtFl.tag == 0 { // PickUpDate
            UserDefaults.standard.set(datePicker.date, forKey: key_pickUpDate)
            hiddeDateInfo(dayBtn: searchHeaderV!.mDayPickUpBtn,
                          monthBtn: searchHeaderV!.mMonthPickUpBtn,
                          hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: searchHeaderV!.mDayPickUpBtn,
                             monthBtn: searchHeaderV!.mMonthPickUpBtn)
            
        } else if responderTxtFl.tag == 1 { // ReturnDate
            UserDefaults.standard.set(datePicker.date, forKey: key_returnDate)
            hiddeDateInfo(dayBtn: searchHeaderV!.mDayReturnDateBtn,
                          monthBtn: searchHeaderV!.mMonthReturnDateBtn,
                          hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: searchHeaderV!.mDayReturnDateBtn,
                             monthBtn: searchHeaderV!.mMonthReturnDateBtn)
            
        } else {
            checkReservetionTime()
            responderTxtFl.tag == 2 ? UserDefaults.standard.set(datePicker.date, forKey: key_pickUpTime) : UserDefaults.standard.set(datePicker.date, forKey: key_returnTime)
            showSelectedDate(dayBtn: nil, monthBtn: nil)
            
        }
        
        //Checking the filling of any fields and removing the error color from the field
        if searchHeaderV!.mErrorMessageLb.isHidden == false {
            let _ = searchHeaderV!.checkFieldsFilled()
        }
    }
        
  
   //MARK: CHECKINGS
    ///check if reservation date more than a month
    func checkMonthReservation() {
        if responderTxtFl.tag == 0 { //pick up date
            mainViewModel.isReservetionMoreThanMonth(pickUpDate: datePicker.date,
                                                     returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date) { (result) in
                if result {
                    self.showAlertMoreThanMonth()
                }
            }
            
        } else if responderTxtFl.tag == 1{ //return date
            mainViewModel.isReservetionMoreThanMonth( pickUpDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                                     returnDate: datePicker.date) { (result) in
                if result {
                    self.showAlertMoreThanMonth()
                }
            }
        }
    }
    
    func checkReservetionTime() {
        if responderTxtFl.tag == 2 { //pick up time
            mainViewModel.isReservetionInWorkingHours(pickUpTime: datePicker.date,
                                                      returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date) { [self] (result) in
                if !result {
                    self.showAlertWorkingHours()
                }
            }
            
        } else if responderTxtFl.tag == 3 { //return time
            mainViewModel.isReservetionInWorkingHours(pickUpTime: UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                                      returnTime: datePicker.date) { (result) in
                if !result {
                    self.showAlertWorkingHours()
                }
                
            }
        }
    }
    
    ///check if any fields have been edited
    func checkAnyFieldsHaveBeenEdited() {
            switch responderTxtFl.tag {
            case 0:
                checkFieldsEdited(pickupDate: datePicker.date,
                                  returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                  pickupTime: UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                  returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                  pickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                  returnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String)

            case 1:
                checkFieldsEdited(pickupDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                  returnDate: datePicker.date,
                                  pickupTime:  UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                  returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                  pickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                  returnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String)

            case 2:
                checkFieldsEdited(pickupDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                  returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                  pickupTime:  datePicker.date,
                                  returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                  pickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                  returnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String)

            case 3:
                checkFieldsEdited(pickupDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                  returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                  pickupTime:  UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                  returnTime: datePicker.date,
                                  pickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                  returnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String)
                
            default: break
                
            }
    }
    func checkFieldsEdited(pickupDate: Date?,
                           returnDate: Date?,
                           pickupTime: Date?,
                           returnTime: Date?,
                           pickUpLocation: String?,
                           returnLocation:String?){
        mainViewModel.isFieldsEdited(pickUpDate: pickupDate,
                                             returnDate: returnDate,
                                             pickUpTime: pickupTime,
                                             returnTime: returnTime,
                                             pickUpLocation: pickUpLocation,
                                             returnLocation: returnLocation,
                                             oldPickUpDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                             oldReturnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                             oldPickUpTime: UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                             oldReturnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                             oldPickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                             oldReturnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String) { [self] (edit) in
            if edit {
                searchHeaderV!.mSearchBckgV.isUserInteractionEnabled = true
                searchHeaderV!.mSearchBckgV.alpha = 1.0
            }
            
        }
        
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date, toDate: Date) -> Int {
            return Calendar.current.dateComponents([.month], from: date, to: toDate).month ?? 0
        }
    //MARK: SHOW FUNCS
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
                             title:Constant.Texts.titleWorkingTime,
                             message: Constant.Texts.messageWorkingTime,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: { [self] in
                                self.initTimeTextField(txtFl: (self.searchHeaderV?.mPickUpTimeTxtFl)!, txt: Constant.Texts.pickUpTime)
                                self.initTimeTextField(txtFl: (self.searchHeaderV?.mReturnTimeTxtFl)!, txt: Constant.Texts.returnTime)
                             }, okAction: { [self] in
                                if self.isPressedEdit {
                                    self.checkAnyFieldsHaveBeenEdited()
                                }
                             })
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
    func showEdit() {
        searchResultV?.didPressEdit = { [weak self] in
            self?.isPressedEdit = true
            self?.animateSearchHeader()
            self?.searchHeaderV?.setShadow(color: .lightGray)
            self?.searchHeaderV?.mArrowBtn.isHidden = false
            self?.searchHeaderV?.mSearchBckgV.isUserInteractionEnabled = false
            self?.searchHeaderV?.mSearchBckgV.alpha = 0.8
            self?.searchHeaderV?.mSearchLeading.constant = 0
            self?.searchHeaderV?.layoutIfNeeded()
        }
    }
    
    func hideEdit()  {
        searchHeaderV?.hideEditView = { [self] in
            self.animateSearchResult()
        }
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

            responderTxtFl.text = datePicker.date.getHour()
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
        searchHeaderV!.mLocationDropDownView.didSelectSeeMap = { [weak self]  in
            let seeMapContr = UIStoryboard(name: Constant.Storyboards.seeMap, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.seeMap) as! SeeMapViewController
            self?.navigationController?.pushViewController(seeMapContr, animated: true)
        }
    }
    ///will be show the custom location map controller
    func showCustomLocationMap() {
        let customLocationContr = UIStoryboard(name: Constant.Storyboards.customLocation, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.customLocation) as! CustomLocationViewController
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    func selectedCustomLocation() {
        searchHeaderV!.didSelectCustomLocation = { [weak self] checkedBtn, willShowAlert in
            willShowAlert ? self!.showAlertCustomLocation(checkedBtn: checkedBtn) : self!.showCustomLocationMap()
        }
    }
    
    
    func selectedDatePicker() {
        searchHeaderV!.didSelectPickUp = { [weak self] textFl in
            self?.view.addSubview(self!.backgroundV)
            print("didSelectPickUp")
            //toolBAr
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            //bar Button
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self?.donePressed))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([flexibleSpace, done], animated: false)
      
            textFl.inputView = self?.datePicker
            textFl.inputAccessoryView = toolBar
            self?.responderTxtFl = textFl

              if #available(iOS 14.0, *) {
                self?.datePicker.preferredDatePickerStyle = .wheels
         } else {
             // Fallback on earlier versions
         }
            if textFl.tag > 1 {
                self?.datePicker.datePickerMode = .time
                self?.datePicker.minimumDate = nil
            } else {
                self?.datePicker.datePickerMode = .date
                self?.datePicker.minimumDate =  Date()

                self?.datePicker.locale = Locale(identifier: "en")
            }
        }

    }

    func selectedLocation() {
        searchHeaderV!.didSelectLocation = { [weak self] (locationStr, buttonTag) in
            if ((self?.isPressedEdit) == true) {
                if  buttonTag == 4 {
                    self?.checkFieldsEdited(pickupDate:UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                            returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                            pickupTime: UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                            returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                            pickUpLocation: locationStr,
                                            returnLocation: UserDefaults.standard.object(forKey: key_returnLocation) as? String)
                } else {
                    self?.checkFieldsEdited(pickupDate: UserDefaults.standard.object(forKey: key_pickUpDate) as? Date,
                                            returnDate: UserDefaults.standard.object(forKey: key_returnDate) as? Date,
                                            pickupTime: UserDefaults.standard.object(forKey: key_pickUpTime) as? Date,
                                            returnTime: UserDefaults.standard.object(forKey: key_returnTime) as? Date,
                                            pickUpLocation: UserDefaults.standard.object(forKey: key_pickUpLocation) as? String,
                                            returnLocation: locationStr)
                    
                }
            }
        }
    }
    
    func selectedSearch() {
        searchHeaderV!.didSelectSearch = { [weak self]  in
            self?.isSearchResultPage = true
            self?.isPressedEdit = false
            self?.searchHeaderV?.layer.shadowOpacity = 1.0
            self?.navigationController!.navigationBar.topItem?.title = "Search Results"
            self?.mLeftBarBtn.image = img_back
            self?.mRightBarBtn.image = img_chat
            self?.mChatWithUsBckgV.isHidden = true
            self?.mCarCollectionV.reloadData()
            self?.animateSearchResult()
        }
    }
    
    func selectedBack() {
        isSearchResultPage = false
        isPressedEdit = true
        
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
//        searchHeaderV?.carouselBackgV.didChangeCategory = { [self] categoryIndex in
//            let category: Categorys = Categorys.init(rawValue: categoryIndex)!
//            switch category {
//            case .trucs: break
//            case .frigoVans: break
//            case .vans: break
//            case .doubleCabs:break
//            case .boxTrucs:break
//            default:
//                break
//            }
//            mCarCollectionV.reloadData()
//
//        }
    }
    
    func hiddeDateInfo(dayBtn : UIButton, monthBtn: UIButton, hidden: Bool, txtFl: UITextField)  {
        dayBtn.isHidden = hidden
        monthBtn.isHidden = hidden
        if hidden == false {
            responderTxtFl.text = ""
        }
    }
    

    //MARK: ACTIONS
    @IBAction func menu(_ sender: UIBarButtonItem) {
        if isSearchResultPage {
            selectedBack()
        } else {
            present(menu!, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func rightBar(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func chatWithUs(_ sender: UIButton) {
        if isOnline {
            let onlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.onlineChat) as! OnlineChatViewController
            self.navigationController?.pushViewController(onlineChat, animated: true)
        } else {
            let offlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.offlineChat) as! OfflineViewController
            self.navigationController?.pushViewController(offlineChat, animated: true)
        }
        
    }

}



extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPressedFilter {
            return 5 + 1
        }
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        // will show Main cell
        if !isSearchResultPage {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
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
            }

        }
        return cell
    }

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPressedFilter &&  indexPath.row == 0{
            return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.306931)
        }
        return CGSize(width: collectionView.bounds.width, height: view.frame.height * 0.441832)
    }
}


// MARK: - UIScrollView Delegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Change top view position and alpha
        //  searchHeaderV?.frame.origin.y = scrollView.contentOffset.y
        
        if (searchHeaderV?.frame.origin.y)! <= 12 {
            searchHeaderV!.frame.origin.y = -abs(collactionViewTop + scrollView.contentOffset.y) + 12
            
        }
        
    }
   
}
