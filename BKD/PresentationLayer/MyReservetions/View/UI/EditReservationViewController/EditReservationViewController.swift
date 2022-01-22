//
//  EditReservationViewController.swift
//  EditReservationViewController
//
//  Created by Karine Karapetyan on 15-09-21.
//

import UIKit
import CoreLocation


protocol EditReservationDelegate: AnyObject {
    func didPressCheckPrice(isEdit: Bool)
    
}
class EditReservationViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mEditBySearchV: EditBySearchView!
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mAdditionalServicestackV: UIStackView!
    @IBOutlet weak var mCheckPriceBtn: UIButton!
    
    ///Extend reservation
    @IBOutlet weak var mChangePriceContentV: UIView!
    @IBOutlet weak var mChangePriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mDamageLb: UILabel!
    @IBOutlet weak var mDamageCheckBoxBtn: UIButton!
    
    ///Continue
    @IBOutlet weak var mConfirmV: ConfirmView!
   
    lazy var mainVM: MainViewModel = MainViewModel()
    public var currRent: Rent?
    public var accessories: [AccessoriesEditModel]?
    public var isExtendReservation: Bool = false

    
    
    //MARK: -- Viriables
    weak var delegate: EditReservationDelegate?
    lazy var editReservVM = EditReservationViewModel()
    var settings: Settings?
    var searchModel:SearchModel = SearchModel()
    var oldSearchModel:SearchModel = SearchModel()
    var pickerState: DatePicker?
    var datePicker = UIDatePicker()
    let pickerV = UIPickerView()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    private var pickerList: [String]?
    private var editReservationModel: EditReservationModel = EditReservationModel()
    



    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mCheckPriceBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        settings = ApplicationSettings.shared.settings
        mRightBarBtn.image = img_bkd
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mEditBySearchV.delegate = self
        showLocation()
        configureExtendReservationUI()
       handlerCinfirm()
        configureUI()
    }
    
    
    ///Configure UI
    func configureUI() {
        guard let rent = self.currRent else {return}
        oldSearchModel = editReservVM.getSearch(rent: rent)
        searchModel = oldSearchModel
        editReservationModel = editReservVM.getNewReservetion(carId: rent.carDetails.id,
                                       startDate: rent.startDate,
                                       search: searchModel)
        mEditBySearchV.updateSearchFields(searchModel: searchModel)
    }
    
    ///Configure Extend reservation view
    func configureExtendReservationUI() {
        
       // mChangePriceContentV.isHidden = !isExtendReservation
        mAdditionalServicestackV.isHidden = isExtendReservation
        mCheckPriceBtn.isHidden = isExtendReservation
        mConfirmV.isHidden = !isExtendReservation
        mDamageCheckBoxBtn.setTitle("", for: .normal)
        
        if isExtendReservation {
            mEditBySearchV.passivePickUpLocations()
            mCheckPriceBtn.setTitle("", for: .normal)
        }
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

    
    ///Pressed done button
    @objc func donePressed() {
        responderTxtFl.resignFirstResponder()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
        
        switch pickerState {
   
        case .returnDate:
            searchModel.returnDate = datePicker.date
            mEditBySearchV.returnDate = datePicker.date
            if  !checkIfReservationMoreThan90Days() {
                checkMonthReservation()

                mEditBySearchV?.setReturnDateInfo(searchModel: searchModel)
                editReservationModel =  editReservVM.getNewReservetion(carId: currRent?.carDetails.id ?? "", startDate: currRent?.startDate ?? 0.0 , search: searchModel)
//                self.checkReservetionHalfHour()
            }
        
           // mEditBySearchV.setReturnDateInfo(searchModel: searchModel)
        case .returnTime :
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            checkReservationTime(timeStr: timeStr)
        default: break
        }
    }
    
    
    //MARK: -- Checks
    
    ///check if reservation date more than a month
    func checkMonthReservation() {
        mainVM.isReservetionMoreThanMonth(pickUpDate: searchModel.pickUpDate, returnDate: searchModel.returnDate) { [self] (result) in
            if result {
                self.showAlertMoreThanMonth()
            } else {
                checkEditReservationIsLater()
            }
        }
    }
    
    ///Check if reservation date more than 90 days
    func checkIfReservationMoreThan90Days() -> Bool {
       // setSearchModel()
        if  mainVM.isReservetionMore90Days(search: searchModel) {
                BKDAlert().showAlertOk(on: self, message: Constant.Texts.max90Days, okTitle: Constant.Texts.ok) {
                    self.mEditBySearchV?.resetReturnDate()
                    self.mEditBySearchV?.resetReturnTime()
            }
            return true
        }
        return false
    }
    
    ///Check is reservation time during working time
    private func checkReservationTime(timeStr: String) {
        DetailsViewModel().isReservetionInWorkingHours(time: timeStr.stringToDate()) { [self] (result) in
            if !result {
                self.showAlertWorkingHours(timeStr: timeStr)
            } else {
                searchModel.returnTime = timeStr.stringToDate()
                mEditBySearchV.setReturnTimeInfo(searchModel: searchModel)
                editReservationModel = editReservVM.getNewReservetion(carId: currRent?.carDetails.id ?? "", startDate: currRent?.startDate ?? 0.0, search: searchModel)
            }
        }
    }
    
    ///Is edit date later than before
    private func checkEditReservationIsLater() {
       if !editReservVM.isEditeDateLater(editSearch: searchModel,
                                        oldSearch: oldSearchModel) {
           self.showAlertExtendDate()
       }
    }
    
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        mEditBySearchV!.mLocationDropDownView.didSelectSeeMap = { [weak self] parkingModel  in
            self?.goToSeeMap(parking: parkingModel, customLocation: nil)
        }
    }
    
    
   //MARK: -- Alerts
    ///Will show alert when checked custom location
    func showAlertCustomLocation(checkedBtn: UIButton) {
        let locationPrice = CGFloat(ApplicationSettings.shared.settings?.customLocationMinimalValue ?? 0)
        BKDAlert().showAlert(on: self,
                             title: String(format: Constant.Texts.titleCustomLocation, locationPrice),
                             message: Constant.Texts.messageCustomLocation,
                             messageSecond: Constant.Texts.messageCustomLocation2,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: {
                                checkedBtn.setImage(img_uncheck_box, for: .normal)
                             }, okAction: { [self] in
                                 self.goToCustomLocationMapController(on: self, isAddDamageAddress: false)
                             })
    }
    
    ///Will show alert when selection time is out of working times
    func showAlertWorkingHours(timeStr: String) {
        BKDAlert().showAlert(on: self,
                             title:String(format: Constant.Texts.titleWorkingTime, timePrice),
                             message: Constant.Texts.messageWorkingTime + "(\(settings?.workStart ?? "") -  \(settings?.workEnd ?? "")).",
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction:nil,
                             
                             okAction: { [self] in
            searchModel.returnTime = timeStr.stringToDate()
            mEditBySearchV.setReturnTimeInfo(searchModel: searchModel)
            editReservationModel = editReservVM.getNewReservetion(carId: currRent?.carDetails.id ?? "", startDate: currRent?.startDate ?? 0.0, search: searchModel)
                             })
    }
    
    ///Will show alert when selection date more then a month
    func showAlertMoreThanMonth() {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.messageMoreThanMonth,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,
                             cancelAction:{
            self.mEditBySearchV.resetReturnDate()

        }, okAction: { [self] in
            checkEditReservationIsLater()
        })
    }
    
    ///Will show alert when selection date is smaller
    func showAlertExtendDate() {
        BKDAlert().showAlertOk(on: self, message: Constant.Texts.extendDateAlert, okTitle: Constant.Texts.ok) {
            self.mEditBySearchV.resetReturnTime()
            self.searchModel.returnTime = self.oldSearchModel.returnTime
        }
    }
    
    //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func additionalDriver(_ sender: UIButton) {
        
        let driverVC = MyDriversViewController.initFromStoryboard(name: Constant.Storyboards.myDrivers)
        driverVC.rent = currRent
        driverVC.accessories = accessories
        driverVC.isEditReservation = true
        driverVC.editReservationModel = editReservationModel
        self.navigationController?.pushViewController(driverVC, animated: true)
    }
    
    
    @IBAction func accessories(_ sender: UIButton) {
        let accessoriesVC = AccessoriesUIViewController.initFromStoryboard(name: Constant.Storyboards.accessories)
        accessoriesVC.currRent = currRent
        accessoriesVC.isEditReservation = true
        accessoriesVC.editReservationModel = editReservationModel
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    
    
    @IBAction func checkPrice(_ sender: UIButton) {
        sender.setClickTitleColor(color_menu!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
            self.delegate?.didPressCheckPrice(isEdit: true)
            self.goToEditReservationAdvanced(rent: self.currRent, accessories: self.accessories,
                                             editReservationModel: self.editReservationModel)
           
         }
    }
    
    @IBAction func damageCheckBox(_ sender: UIButton) {
        
        if sender.image(for: .normal) == img_check_box {
            sender.setImage(img_uncheck_box, for: .normal)
        } else {
            sender.setImage(img_check_box, for: .normal)
        }
            
    }
    
    func handlerCinfirm() {
        mConfirmV.didPressConfirm = {
            self.goToEditReservationAdvanced(rent: self.currRent, accessories: self.accessories,
                                             editReservationModel: self.editReservationModel)
        }
    }
    
}



//MARK: -- EditBySearchViewDelegate
extension EditReservationViewController: EditBySearchViewDelegate {
    
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
            self.datePicker.minimumDate = oldSearchModel.returnDate
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
            mEditBySearchV.returnLocation = parking.name
            searchModel.isRetuCustomLocation = false
            PriceManager.shared.returnCustomLocationPrice = nil
        }
        editReservationModel = editReservVM.getNewReservetion(carId: currRent?.carDetails.id ?? "",
                                       startDate: editReservationModel.startDate ?? 0.0, search: searchModel)
        //isActiveReserve()
        
    }
    
    func didSelectCustomLocation(_ btn: UIButton) {
        self.showAlertCustomLocation(checkedBtn: btn)

    }
    
    func didDeselectCustomLocation(tag: Int) {
        if tag == 6 { //pick up custom location
            searchModel.isPickUpCustomLocation = false
            searchModel.pickUpLocation = nil
            mEditBySearchV.pickUpLocation = nil
            PriceManager.shared.pickUpCustomLocationPrice = nil
        } else {//return custom location
            searchModel.isRetuCustomLocation = false
            searchModel.returnLocation = nil
            mEditBySearchV.returnLocation = nil
            PriceManager.shared.returnCustomLocationPrice = nil
        }
    }
    
    func editReservation(isEdited: Bool) {
        if isExtendReservation {
            isEdited ? mConfirmV.enableView() : mConfirmV.disableView()
            mChangePriceContentV.isHidden = !isEdited
        } else  {
            isEdited ? mCheckPriceBtn.enable() : mCheckPriceBtn.disable()
        }
    }
    
}


//MARK: -- CustomLocationUIViewControllerDelegate
extension EditReservationViewController: CustomLocationViewControllerDelegate {
    
    func getCustomLocation(_ locationPlace: String, coordinate: CLLocationCoordinate2D, price: Double?) {
         mEditBySearchV.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
                self?.searchModel.pickUpLocationLongitude = coordinate.longitude
                self?.searchModel.pickUpLocationLatitude = coordinate.latitude
                self?.mEditBySearchV.pickUpLocation = locationPlace
            } else {
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
                self?.searchModel.returnLocationLongitude = coordinate.longitude
                self?.searchModel.returnLocationLatitude = coordinate.latitude
                self?.mEditBySearchV.returnLocation = locationPlace
            }

        })
    }
}


//MARK: -- UIPickerViewDelegate
extension EditReservationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.selectedRow(inComponent: component))
        
    }
}


////MARK: -- AccessoriesUIViewControllerDelegate
//extension EditReservationViewController: AccessoriesUIViewControllerDelegate {
//
//    func addedAccessories(_ isAdd: Bool,
//                          totalPrice: Double,
//                          accessoriesEditList: [AccessoriesEditModel]?) {
//
//        self.accessoriesEditList = accessoriesEditList
//    }
//}
