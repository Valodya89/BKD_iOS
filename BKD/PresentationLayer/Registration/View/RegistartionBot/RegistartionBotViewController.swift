//
//  RegistartionBotViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit
import GooglePlaces

enum PickerType {
    case date
    case country
    case nationalCountry
}

protocol RegistartionBotViewControllerDelegate: AnyObject {
    func backToMyBKD()
}
final class RegistartionBotViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mTableV: UITableView!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mThankYouBckgV: UIView!
    @IBOutlet weak var mThankYouBtn: UIButton!
    
    
    
    //MARK: -- Variables
    weak var delegate: RegistartionBotViewControllerDelegate?
    lazy var registrationBotViewModel = RegistrationBotViewModel()
    var tableData: [RegistrationBotModel] = []
    var registrationBotModel: [RegistrationBotModel] = []
    private let applicationSettings: ApplicationSettings = .shared
    var currentPhoneCode: PhoneCode?
    var currentCountry: Country?

    var countryList: [Country]?
    var personalData: PersonalData = PersonalData()
    var driverLicenseDateData: DriverLiceseDateData = DriverLiceseDateData()
    
    var pickerType: PickerType = .date
    var timer: Timer?
    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var isTakePhoto:Bool = false
    var isDriverRegister: Bool = false
    var isEdit: Bool = false
    private var takePhotoCurrentIndex:Int  = 0
    private var currentIndex = 0
    private var activeTextField: UITextField?
    public var mainDriver: MainDriver?


    //MARK: -- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationBotModel = isDriverRegister ? RegistrationBotData.registrationDriverModel : RegistrationBotData.registrationBotModel
        countryList = ApplicationSettings.shared.countryList
        if countryList == nil {
            getCountryList()
        }
        setUpView()
        setUpConfirmView()
        configureTableView()
        
        if mainDriver == nil {
            creatDriver(driverType: isDriverRegister ? Constant.Texts.creat_additional_driver
                : Constant.Texts.creat_main_driver)
            startTimer()
        } else {
           // if !isDriverRegister {
                registrationBotViewModel.setRegisterBotInfo(mainDriver: mainDriver!, countryList: countryList) { registrationBotResult in
                    
                    self.tableData = registrationBotResult
                    if self.mainDriver?.state  != Constant.Texts.state_created {
                        self.personalData = self.registrationBotViewModel.getPersonalData(driver: self.mainDriver) ?? PersonalData()
                        self.driverLicenseDateData = self.registrationBotViewModel.getDriverLicenseDateData(driver: self.mainDriver) ?? DriverLiceseDateData()
                    }
                    self.mTableV.reloadData()
                    self.tableScrollToBottom()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        self.insertTableCell()
                    }
                }
           // }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        currentPhoneCode = applicationSettings.phoneCodes?.first
        currentCountry = countryList?.first
        mRightBarBtn.image = img_bkd
        mThankYouBtn.roundCornersWithBorder(corners: [.allCorners], radius: mThankYouBtn.frame.height/2, borderColor: color_navigationBar!, borderWidth: 1)
        
    }
    
    
    ///set up confirm view
    private func setUpConfirmView() {
        mConfirmBckgV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor: color_dark_register!,endColor: color_dark_register!.withAlphaComponent(0.85) )
        mConfirmBckgV.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    ///Add Keyboard notifications
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    ///Configure table view
    func configureTableView() {
        mTableV.register(InfoMessageTableViewCell.nib(), forCellReuseIdentifier: InfoMessageTableViewCell.identifier)
        mTableV.register(ExamplePhotoTableViewCell.nib(), forCellReuseIdentifier: ExamplePhotoTableViewCell.identifier)
        mTableV.register(UserFillFieldTableViewCell.nib(), forCellReuseIdentifier: UserFillFieldTableViewCell.identifier)
        mTableV.register(PhoneNumberTableViewCell.nib(), forCellReuseIdentifier: PhoneNumberTableViewCell.identifier)
        mTableV.register(CalendarTableViewCell.nib(), forCellReuseIdentifier: CalendarTableViewCell.identifier)
        mTableV.register(MailBoxNumberTableViewCell.nib(), forCellReuseIdentifier: MailBoxNumberTableViewCell.identifier)
        mTableV.register(NationalRegisterNumberTableViewCell.nib(), forCellReuseIdentifier: NationalRegisterNumberTableViewCell.identifier)
        mTableV.register(TakePhotoTableViewCell.nib(), forCellReuseIdentifier: TakePhotoTableViewCell.identifier)
        mTableV.estimatedRowHeight = UITableView.automaticDimension

    }
    
    
    ///Get country list
    func getCountryList() {
        registrationBotViewModel.getCountryList { [weak self] (response) in
            guard let self = self else { return }
            self.countryList = response
            self.currentCountry = self.countryList?.first

        }
    }
    
    ///Sent requesst for creat user account
    func creatDriver(driverType: String) {
        registrationBotViewModel.creatDriver(type: driverType) { request in
            print (request)
            guard let _ = request else {return}
            self.mainDriver = request!
        }
    }
    
    //Send personal data
    func sendPersonalData(personalData: PersonalData, index: Int, isEditData: Bool) {
        registrationBotViewModel.addPersonlaData(id: mainDriver?.id ?? "", personlaData: personalData) { [self] (result, err) in
            guard let result = result else {
                if err == "401" {
                    self.showAlertSignIn()
                } else {
                    self.showAlertMessage(Constant.Texts.errPersonalData) }
                return }
            mainDriver = result
            if !isEditData {
                fillInTableCell(txt: personalData.nationalRegisterNumber!, index: index)
                insertTableCell()
            } else {
                self.sendAgreement()
            }
        }
    }
    
   
    /// Send request accept agreement
    private func sendAgreement() {
        registrationBotViewModel.acceptAgreement(id: mainDriver?.id ?? "") { (result, err) in
            if result != nil {
                self.tableData = self.isDriverRegister ? RegistrationBotData.completedDriverAccountModel : RegistrationBotData.completedAccountModel
                self.animationConfirm()
            } else if err == "401" {
                    self.showAlertSignIn()
                } else {
                self.showAlertMessage(Constant.Texts.errAcceptAgreement)
            }
        }
    }

    //MARK: -- TIMER
    
    /// Start timer for update table cell
    func startTimer() {
        if timer == nil {
            let seconds = 0.65
            timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateTableCell), userInfo: nil, repeats: true)
          }
    }
    
    /// Stop timer
    func stopTimer() {
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
    }
 
    
    /// Update table cell
    @objc func updateTableCell () {
        if registrationBotModel[currentIndex].viewDescription == nil && mThankYouBckgV.isHidden{
            insertTableCell()
        } else {
            stopTimer()
        }
    }
    
    ///Fill in table cell
    func fillInTableCell(txt:String, index: Int?) {
        if  tableData[index ?? currentIndex].userRegisterInfo == nil {
            tableData[index ?? currentIndex].userRegisterInfo? = UserRegisterInfo(string: txt, isFilled: true)
        } else {
            tableData[index ?? currentIndex].userRegisterInfo?.string = txt
            tableData[index ?? currentIndex].userRegisterInfo?.isFilled = true
        }
        isEdit = (index ?? 0 < currentIndex)
    }
    
    /// Insert table cell
    func insertTableCell() {
        if tableData.count < registrationBotModel.count && !isEdit  {
            
            if !mConfirmBckgV.isHidden &&  tableData.count == RegistrationBotData.completedAccountModel.count {
                stopTimer()
            } else {
                tableData.append(registrationBotModel[currentIndex + 1])
                mTableV.performBatchUpdates {
                    mTableV.insertRows(at: [IndexPath.init(row: tableData.count-1, section: 0)], with: .automatic)
                } completion: { [weak self]_ in
                    guard let self = self else {return}
                    self.tableScrollToBottom()
                    self.startTimer()
                }
                
            }
        }
    }
    
    
    ///Table view scroll to bottom
    func tableScrollToBottom(){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.tableData.count-1, section: 0)
                self.mTableV.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }

    ///Will creat actionshit for camera and photo library
    func takePhotoPressed() {
        let alert = UIAlertController(title: Constant.Texts.selecteImg, message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction (title: Constant.Texts.camera, style: .default) { [self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.presentPicker(sourceType: .camera)
            }
        }
        
        let photoLibraryAction = UIAlertAction (title: Constant.Texts.photoLibrary, style: .default) { [self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.presentPicker(sourceType: .photoLibrary)
            }
        }
        let cancelAction = UIAlertAction (title: Constant.Texts.cancel, style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    ///Will present image Picker controller
    private func presentPicker (sourceType: UIImagePickerController.SourceType) {
        isTakePhoto = true
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
     ///creat tool bar
    private func creatToolBar(index: Int) -> UIToolbar {
        //toolBAr
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar Button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePressed(sender:)))
        done.tag = index
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        return toolBar
    }
    
    //MARK: -- Keyboard NSNotification
    
    @objc func keyboardWillShow (notification: NSNotification) {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        let bottomInset = keyboardSize.height
        
        mTableV.contentInset.bottom = bottomInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
            self.mTableV.contentInset = .zero
    }
    
    
    ///Will animate confirm button
    func animationConfirm() {
        self.mConfirmLeading.constant = self.view.bounds.width - self.mConfirmBckgV.bounds.width + 25
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.mConfirmBckgV.isHidden = true
            self.mTableV.reloadData()
            self.mThankYouBckgV.isHidden = false
        }
    }
    
    
    //MARK: -- ACTIONS
    @IBAction func confirm(_ sender: UIButton) {
        sendPersonalData(personalData: personalData,
                         index: 0,
                         isEditData: true)
    }
    
    @IBAction func thankYou(_ sender: UIButton) {
        
        registrationBotViewModel.saveUserPhoneNumber(phoneCodeId: currentPhoneCode?.id, number: personalData.phoneNumber)
        
        UserDefaults.standard.set(true, forKey: key_isLogin)
        sender.setTitleColor(color_menu!, for: .normal)
        sender.setBorderColorToCAShapeLayer(color: .clear)
        sender.backgroundColor = color_navigationBar!//color_dark_register
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToViewController(ofClass: self.isDriverRegister ? MyDriversViewController.self : MyBKDViewController.self, animated: true)
        }
    }
    
    @IBAction func beck(_ sender: UIBarButtonItem) {
        delegate?.backToMyBKD()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        isEdit = (sender.tag < currentIndex)
        switch pickerType {
        case .date:
            tableData[sender.tag].userRegisterInfo = UserRegisterInfo(date: datePicker.date, isFilled: true)
        case .nationalCountry:
            // change nationality  textfiled
            guard let _ = countryList else { return }
            currentCountry = countryList?[ pickerV.selectedRow(inComponent: 0)]
            tableData[sender.tag].userRegisterInfo?.nationalString = countryList?[ pickerV.selectedRow(inComponent: 0)].country
        break
        case .country:
            guard let _ = countryList else { return }
            fillInTableCell(txt: countryList![ pickerV.selectedRow(inComponent: 0)].country ?? "", index: sender.tag)
            personalData.countryId = countryList![ pickerV.selectedRow(inComponent: 0)].id
            mTableV.reloadData()
            
        }

        mTableV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        if pickerType != .nationalCountry {
            insertTableCell()
        }
    }
}

//MARK: -- UITableViewDataSource
extension RegistartionBotViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableData[indexPath.row]
        currentIndex = tableData.count - 1
        
        if let _ = model.examplePhoto {
           return examplePhotoCell(indexPath: indexPath, model: model)

        } else if let _ = model.viewDescription {
            switch model.viewDescription {
            case Constant.Texts.button,
                 Constant.Texts.txtFl:
                return userFillFieldCell(indexPath: indexPath, model: model)
            case Constant.Texts.phone:
                return phoneNumberCell(indexPath: indexPath,model: model)
            case Constant.Texts.calendar,
                 Constant.Texts.issueDateDrivingLicense:
                return calendarCell(indexPath: indexPath,model: model, isExpiryDate: false)
            case Constant.Texts.expiryDate,
                 Constant.Texts.expiryDateDrivingLicense:
                return calendarCell(indexPath: indexPath,model: model, isExpiryDate: true)
            case Constant.Texts.mailbox:
                return mailBoxCell(indexPath: indexPath, model: model)
            case  Constant.Texts.nationalRegister:
               return nationalRegisterCell(indexPath: indexPath, model: model)
            default:
                return takePhotoCell(indexPath: indexPath,model: model)
            }
        } else { // info message
            return infoMessageCell(indexPath: indexPath,model: model)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //MARK: -- Table cells
    private func infoMessageCell(indexPath: IndexPath, model: RegistrationBotModel) -> InfoMessageTableViewCell{
        let cell = mTableV.dequeueReusableCell(withIdentifier: InfoMessageTableViewCell.identifier, for: indexPath) as! InfoMessageTableViewCell
        cell.setCellInfo(items: tableData, index: indexPath.row)
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    private func userFillFieldCell(indexPath: IndexPath, model: RegistrationBotModel) -> UserFillFieldTableViewCell {
        
    let cell = mTableV.dequeueReusableCell(withIdentifier: UserFillFieldTableViewCell.identifier, for: indexPath) as! UserFillFieldTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
      return cell
    }
    
    private func phoneNumberCell(indexPath: IndexPath, model: RegistrationBotModel) -> PhoneNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
        if let _ = currentPhoneCode {
            cell.selectedCountry = currentPhoneCode
            cell.mPhoneNumberTxtFl.formatPattern = currentPhoneCode?.mask ?? ""
            cell.validFormPattern = (currentPhoneCode?.mask!.count)!
        }
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
          return cell
    }
    
    private func calendarCell(indexPath: IndexPath, model: RegistrationBotModel, isExpiryDate: Bool) -> CalendarTableViewCell {
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
        cell.isExpiryDate = isExpiryDate
        return cell
    }
    
    private func mailBoxCell(indexPath: IndexPath, model: RegistrationBotModel) -> MailBoxNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: MailBoxNumberTableViewCell.identifier, for: indexPath) as! MailBoxNumberTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
        return cell
    }
    
    private func nationalRegisterCell(indexPath: IndexPath, model: RegistrationBotModel) -> NationalRegisterNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: NationalRegisterNumberTableViewCell.identifier, for: indexPath) as! NationalRegisterNumberTableViewCell
        cell.selectedCountry = currentCountry
//        cell.mTextFl.formatPattern = currentCountry?.nationalDocumentMask ?? ""
//        cell.validFormPattern = (currentCountry?.nationalDocumentMask!.count)!
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
        return cell
    }
    
    private func takePhotoCell(indexPath: IndexPath, model: RegistrationBotModel) -> TakePhotoTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: TakePhotoTableViewCell.identifier, for: indexPath) as! TakePhotoTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model, index: indexPath.row)
        return cell
    }
    
    private func examplePhotoCell(indexPath: IndexPath, model: RegistrationBotModel) -> ExamplePhotoTableViewCell {
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: ExamplePhotoTableViewCell.identifier, for: indexPath) as! ExamplePhotoTableViewCell
         cell.mImageV.image = model.examplePhoto
         return cell
    }
}




//MARK: -- UserFillFieldTableViewCellDelegate
extension RegistartionBotViewController: UserFillFieldTableViewCellDelegate {
    
    func didBeginEdithingTxtField(txtFl: UITextField) {
        activeTextField = txtFl
    }
    
    func didPressStart() {
        self.tableData[self.currentIndex].userRegisterInfo?.isFilled =  true
        self.insertTableCell()
    }

    func didReturnTxtField(txt: String?, index: Int) {
        fillInTableCell(txt: txt ?? "", index: index)
        insertTableCell()
    }
    
    func willOpenPicker(textFl: UITextField, viewType: ViewType) {
       // countryList
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar(index: textFl.tag)
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if viewType == .country {
            pickerType = .country
        }
        pickerV.delegate = self
        pickerV.dataSource = self
    }
    
    func willOpenAutocompleteViewControlle() {
        self.showAutocompleteViewController(viewController: self)
    }
    
    func updateUserData(dataType: ViewType, data: String) {
        switch dataType {
        case .name:
            personalData.name = data
        case .surname:
            personalData.surname = data
        case .street:
            personalData.street = data
        case .house:
            personalData.house = data
        case .mailBox:
            personalData.mailBox = data
        case .countryId:
            personalData.countryId = data
        case .zip:
            personalData.zip = data
        case .city:
            personalData.city = data
        case .nationalRegister:
            personalData.nationalRegisterNumber = data
        case .drivingLicenseNumber:
            driverLicenseDateData.drivingLicenseNumber = data
            if driverLicenseDateData.expirationDate != nil &&  driverLicenseDateData.issueDate != nil  {
                addDriverLicenseDate()
            }
        default: break
        }
    }
}
 

//MARK: -- PhoneNumberTableViewCellDelegate
extension RegistartionBotViewController: PhoneNumberTableViewCellDelegate {
    
    func didPressCountryCode() {
        self.goToSearchPhoneCode(viewCont: self)
//        let searchPhoneCodeVC = SearchPhoneCodeViewController.initFromStoryboard(name: Constant.Storyboards.searchPhoneCode)
//        searchPhoneCodeVC.delegate = self
//        self.present(searchPhoneCodeVC, animated: true, completion: nil)
    }
    
    func didReturnTxtField(text: String, code: String, index: Int) {
        fillInTableCell(txt: text, index: index)
        insertTableCell()
        personalData.phoneNumber = code + text
    }
}


//MARK: -- CalendarTableViewCellDelegate
extension RegistartionBotViewController: CalendarTableViewCellDelegate {
    
    func willOpenPicker(textFl: UITextField, isExpiryDate: Bool) {
        
        textFl.inputView = datePicker
        textFl.inputAccessoryView = creatToolBar(index: textFl.tag)
        textFl.isHidden = true
        pickerType = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        if isExpiryDate {
            datePicker.minimumDate = Date()
            datePicker.maximumDate = nil
        } else {
            datePicker.minimumDate = nil
            datePicker.maximumDate = Date()
        }
    }
    
    func updateData(viewType: ViewType, calendarData: String) {
        switch viewType {
         case .dateOfBirth:
            personalData.dateOfBirth = calendarData
        case .expiryDate:
                addIdentityExpirationDate(expiryDate: calendarData)
        case .issueDateDrivingLicense:
            driverLicenseDateData.issueDate = calendarData
            if driverLicenseDateData.expirationDate != nil {
                addDriverLicenseDate()
            }
        case .expiryDateDrivingLicense:
                driverLicenseDateData.expirationDate = calendarData
                addDriverLicenseDate()
        default:
            break
        }
    }
    
    ///add Identity Expiration Date to database
    private func addIdentityExpirationDate(expiryDate: String) {
        registrationBotViewModel.addIdentityExpiration(id:  mainDriver?.id ?? "", experationDate: expiryDate) { (result) in
            if result != nil {
                self.mainDriver = result!
            } else {
                self.showAlertMessage(Constant.Texts.errIDExpirationDate)
            }
        }
    }
    
    ///add Driver License Date to database
    private func addDriverLicenseDate() {
        registrationBotViewModel.addDriverLicenseDates(id:  mainDriver?.id ?? "",
                                                       driverLicenseDateData: driverLicenseDateData) { (result) in
            if result != nil {
                self.mainDriver = result!
            } else {
                self.showAlertMessage(Constant.Texts.errDrivLicenseDate)
            }
        }
    }
}



//MARK: -- MailBoxNumberTableViewCellDelegate
extension RegistartionBotViewController: MailBoxNumberTableViewCellDelegate {
    
    func didReturn(text: String?, noMailBox: Bool, index: Int) {
        
        if text?.count ?? 0 > 0 && !noMailBox {
            tableData[index].userRegisterInfo?.string = text
        }
        tableData[index].userRegisterInfo?.isFilled = true
        personalData.mailBox = text ?? ""
        isEdit = (index < currentIndex)
        self.insertTableCell()
    }
}



//MARK: -- NationalRegisterNumberTableViewCellDelegate
extension RegistartionBotViewController: NationalRegisterNumberTableViewCellDelegate {
    
    func didPressOtherCountryNational(isClicked: Bool, index: Int) {
        tableData[index].userRegisterInfo = UserRegisterInfo(isOtherNational: isClicked)
        mTableV.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableScrollToBottom()
    }
    
    func didReturnTxt(txt: String?, index: Int) {
        
        personalData.nationalRegisterNumber = txt
        sendPersonalData(personalData: personalData, index: index, isEditData: false)
    }
    
    func willOpenPicker(textFl: UITextField) {
       // countryList
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar(index: textFl.tag)
        textFl.isHidden = true
        pickerType = .nationalCountry
        pickerV.delegate = self
        pickerV.dataSource = self
    }
}



//MARK: -- TakePhotoTableViewCellDelegate
extension RegistartionBotViewController: TakePhotoTableViewCellDelegate {
    
    func didPressTackePhoto(isOpenDoc: Bool, index: Int) {
        takePhotoCurrentIndex = index
        if isOpenDoc {
            
            self.goToAgreement(on: self,
                               agreementType: .none,
                               vehicleModel: nil,
                               urlString: ApplicationSettings.shared.settings?.registrationAgreementUrl)
        } else {
            takePhotoPressed()
        }
    }
}

//MARK: -- BkdAgreementViewControllerDelegate
extension RegistartionBotViewController: BkdAgreementViewControllerDelegate {
    
    func agreeTermsAndConditions() {
        self.mConfirmBckgV.isHidden = false
        self.tableData[self.currentIndex].userRegisterInfo  = UserRegisterInfo(isFilled: true)
        self.mTableV.reloadRows(at: [IndexPath(row: self.currentIndex, section: 0)], with: .automatic)
        isEdit = false
        self.insertTableCell()
    }
    
}


//MARK: -- SearchPhoneCodeViewControllerDelegate
extension RegistartionBotViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCode) {
        currentPhoneCode = country
        mTableV.reloadRows(at: [IndexPath(row: 9, section: 0)], with: .automatic)
    }
}

//MARK: -- UIImagePickerControllerDelegate
extension RegistartionBotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        isTakePhoto = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        if isTakePhoto {
            uploadImage(image: image)
            
        }
    }
    
    //Upload image to database
    private func uploadImage(image: UIImage) {
        let uploadState = registrationBotViewModel.getImageUploadState( index: takePhotoCurrentIndex)
        let newImage = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        registrationBotViewModel.imageUpload(image: newImage,
                                             id: mainDriver?.id ?? "",
                                             state: uploadState.rawValue) { [self] (result, err) in
            if result != nil {
                mainDriver = result!
                DispatchQueue.main.async { [self] in
                    tableData[self.takePhotoCurrentIndex].userRegisterInfo = UserRegisterInfo(photo: image, isFilled: true)
                    mTableV.reloadRows(at: [IndexPath(row: self.takePhotoCurrentIndex, section: 0)], with: .automatic)
                  //  mTableV.reloadData()
                    isEdit = (self.takePhotoCurrentIndex < currentIndex)
                    self.insertTableCell()
                }
                self.isTakePhoto = false

            } else  if err == "401" {
                self.showAlertSignIn()
            } else {
                self.showAlertMessage(Constant.Texts.errImageUpload)
            }
        }
    }
}

//MARK: -- UIPickerViewDelegate
extension RegistartionBotViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return countryList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            currentCountry = countryList![row]
            return countryList![row].country
    }
}


//MARK: -- GMSAutocompleteViewControllerDelegate
extension RegistartionBotViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

      self.resolveLocation(place: place) { result  in
          switch result {
          case .success(let coordinate):
              
              let geoCoder = CLGeocoder()
              let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
              geoCoder.reverseGeocodeLocation(location, completionHandler:
                                                {
                  placemarks, error -> Void in
                  // Place details
                  guard let placeMark = placemarks?.first else { return }
                  // City
                  var cityname = ""
                  if let city = placeMark.subAdministrativeArea {
                      cityname = city
                  } else {
                      cityname = place.name ?? ""
                  }
                  self.personalData.city = cityname
                  self.fillInTableCell(txt: cityname, index: 24)
                  self.mTableV.reloadData()
                  self.insertTableCell()
              })
          case .failure( _ ):
              self.showAlertMessage(Constant.Texts.errLocation)
          }
      }
      dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}

