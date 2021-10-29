//
//  EditReservationViewController.swift
//  EditReservationViewController
//
//  Created by Karine Karapetyan on 15-09-21.
//

import UIKit


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
   
    
    
    
    //MARK: -- Viriables
    weak var delegate: EditReservationDelegate?
    public var isExtendReservation: Bool = false
    
    var workingTimes: WorkingTimes?
    var searchModel:SearchModel = SearchModel()
    var pickerState: DatePicker?
    var datePicker = UIDatePicker()
    let pickerV = UIPickerView()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    private var pickerList: [String]?



    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        workingTimes = ApplicationSettings.shared.workingTimes
        mRightBarBtn.image = img_bkd
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mEditBySearchV.delegate = self
        showLocation()
        configureExtendReservation()
       handlerCinfirm()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mCheckPriceBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    
    ///Configure Extend reservation view
    func configureExtendReservation() {
        
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
            mEditBySearchV.showDateInfoViews(dayBtn: mEditBySearchV!.mDayReturnDateBtn,
                         monthBtn: mEditBySearchV!.mMonthReturnDateBtn,
                         txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mEditBySearchV!.mDayReturnDateBtn,
                             monthBtn: mEditBySearchV!.mMonthReturnDateBtn, timeStr: nil)
            searchModel.returnDate = datePicker.date
            mEditBySearchV.returnDate = datePicker.date
        case .returnTime :
            let timeStr = pickerList![ pickerV.selectedRow(inComponent: 0)]
            chanckReservationTime(timeStr: timeStr)
            searchModel.returnTime = timeStr.stringToDate()
            mEditBySearchV.returnTime = timeStr.stringToDate()

        default: break
            
            
        }
        
    }
    
    
    ///check is reservation time during working time
    private func chanckReservationTime(timeStr: String?) {
        DetailsViewModel().isReservetionInWorkingHours(time: timeStr?.stringToDate()) { [self] (result) in
            if !result {
                self.showAlertWorkingHours()
            } else {
                showSelectedDate(dayBtn: nil, monthBtn: nil, timeStr: timeStr)
            }
        }
        
    }
    
    ///Will put new values from pickerDate
    func showSelectedDate(dayBtn : UIButton?, monthBtn: UIButton?, timeStr: String?) {
        if  pickerState == .returnTime { //Time
            
            responderTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)
            responderTxtFl.text = timeStr
            responderTxtFl.textColor = color_entered_date
            
        } else { // date
        dayBtn?.setTitle(String(datePicker.date.getDay()), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
        }
    }
    
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        mEditBySearchV!.mLocationDropDownView.didSelectSeeMap = { [weak self] parkingModel  in
            self?.goToSeeMap(parking: parkingModel)
        }
    }
    
    
   //MARK: -- Alerts
    
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
                    

                             }, okAction: { [self] in
                                
                               // self.confirmPressed(optionIndex: optionIndex)
                             })
        
    }
    
    //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func additionalDriver(_ sender: UIButton) {
        
        self.goToAdditionalDriver(on: nil, isEditReservation: true)
    }
    
    
    @IBAction func accessories(_ sender: UIButton) {
        
        goToAccessories(on: nil, vehicleModel: nil, isEditReservation: true)
    }
    
    
    @IBAction func checkPrice(_ sender: UIButton) {
        sender.setClickTitleColor(color_menu!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
            self.delegate?.didPressCheckPrice(isEdit: true)
            self.goToEditReservationAdvanced()
           
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
            self.goToEditReservationAdvanced()
        }
    }
    
}




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
            self.datePicker.minimumDate =  Date()
            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    func didSelectLocation(_ text: String, _ tag: Int) {
        if tag == 4 { //pick up location
            searchModel.pickUpLocation = text
            
        } else {// return location
            searchModel.returnLocation = text
            mEditBySearchV.returnLocation = text

        }
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
        } else {//return custom location
            searchModel.isRetuCustomLocation = false
            searchModel.returnLocation = nil
            mEditBySearchV.returnLocation = nil
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


//MARK: CustomLocationUIViewControllerDelegate
//MARK: ----------------------------
extension EditReservationViewController: CustomLocationViewControllerDelegate {
    
    func getCustomLocation(_ locationPlace: String) {
         mEditBySearchV.updateCustomLocationFields(place: locationPlace, didResult: { [weak self] (isPickUpLocation) in
            if isPickUpLocation {
                self?.searchModel.isPickUpCustomLocation = true
                self?.searchModel.pickUpLocation = locationPlace
                self?.mEditBySearchV.pickUpLocation = locationPlace
            } else {
                self?.searchModel.isRetuCustomLocation = true
                self?.searchModel.returnLocation = locationPlace
                self?.mEditBySearchV.returnLocation = locationPlace

            }

        })
    }
}


//MARK: UIPickerViewDelegate
//MARK: --------------------------------
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
