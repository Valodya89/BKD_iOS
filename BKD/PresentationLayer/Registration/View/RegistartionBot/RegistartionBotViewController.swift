//
//  RegistartionBotViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

enum PickerType {
    case date
    case country
    case city
    case nationalCountry
}

protocol RegistartionBotViewControllerDelegate: AnyObject {
    func backToMyBKD()
}
final class RegistartionBotViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlets
    @IBOutlet weak var mTableV: UITableView!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mThankYouBckgV: UIView!
    @IBOutlet weak var mThankYouBtn: UIButton!
    
    
    
    //MARK: Variables
    weak var delegate: RegistartionBotViewControllerDelegate?
    lazy var registrationBotViewModel = RegistrationBotViewModel()
    var tableData:[RegistrationBotModel] = []
    private let applicationSettings: ApplicationSettings = .shared
    var currentPhoneCode: PhoneCode?
    var currentCountry: Country?

    var countryList: [Country]?
    var cityList: [City]? = [City(id: "test", city: "Test"),
                             City(id: "test1", city: "Test1")]
    var personalData: PersonalData = PersonalData()
    var driverLicenseDateData: DriverLiceseDateData = DriverLiceseDateData()
    
    var pickerType:PickerType = .date
    var registrationState: RegistrationState = .PERSONAL_DATA
    
    var timer: Timer?
    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var isTakePhoto:Bool = false
    var isDriverRegister: Bool = false
    private var currentIndex = 0
    private var imageUploadCounter = 0
    private var activeTextField: UITextField?
    public var mainDriver: MainDriver?


    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList = ApplicationSettings.shared.countryList
        if countryList == nil {
            getCountryList()
        }
        creatUser()
        setUpView()
        setUpConfirmView()
        configureTableView()
        if mainDriver == nil {
            startTimer()
        } else {
            registrationBotViewModel.setRegisterBotInfo(mainDriver: mainDriver!, countryList: countryList) { registrationBotResult in
                self.tableData = registrationBotResult
                self.mTableV.reloadData()
                self.tableScrollToBottom()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                    self.insertTableCell()
                }
            }
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
        mThankYouBtn.roundCornersWithBorder(corners: [.allCorners], radius: 36.0, borderColor: color_dark_register!, borderWidth: 1)
        
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
    func creatUser() {
        registrationBotViewModel.creatDriver(type: Constant.Texts.creat_main_driver) { request in
            print (request)
            guard let _ = request else {return}
            self.mainDriver = request!
        }
    }
    
    //Send personal data
    func sendPersonalData(personalData: PersonalData) {
        registrationBotViewModel.addPersonlaData(id: mainDriver!.id, personlaData: personalData) { [self] (result) in
            print(result)
            guard let result = result else {
                self.showAlertMessage(Constant.Texts.errPersonalData)
                return }
            mainDriver = result
            self.registrationState = RegistrationState(rawValue: mainDriver?.state ?? "")!
        }
    }

    //MARK: TIMER
    //MARK -------------------
    
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
        if RegistrationBotData.registrationBotModel[currentIndex].viewDescription == nil && mThankYouBckgV.isHidden{
            insertTableCell()
        } else {
            stopTimer()
        }
    }
    
    /// Insert table cell
    func insertTableCell() {
        if tableData.count < RegistrationBotData.registrationBotModel.count  {
            
            if !mConfirmBckgV.isHidden &&  tableData.count == RegistrationBotData.completedAccountModel.count {
                stopTimer()
            } else {
            tableData.append(RegistrationBotData.registrationBotModel[currentIndex + 1])
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
    private func creatToolBar() -> UIToolbar {
        //toolBAr
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar Button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        return toolBar
    }
    
    //MARK: Keyboard NSNotification
    //MARK: ---------------------------
    
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
    
    
    //MARK: ACTIONS
    //MARK: -----------------
    @IBAction func confirm(_ sender: UIButton) {
        tableData = isDriverRegister ? RegistrationBotData.completedDriverAccountModel : RegistrationBotData.completedAccountModel
        animationConfirm()
    }
    
    @IBAction func thankYou(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: key_isLogin)
        sender.setTitleColor(color_menu!, for: .normal)
        sender.layer.cornerRadius = 10
        sender.backgroundColor = color_dark_register
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
           
        self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: false)
            
        }
    }
    
    @IBAction func beck(_ sender: UIBarButtonItem) {
        delegate?.backToMyBKD()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func donePressed() {
        switch pickerType {
        case .date:
            tableData[currentIndex].userRegisterInfo = UserRegisterInfo(date: datePicker.date, isFilled: true)
        case .nationalCountry:
            // change nationality  textfiled
            guard let _ = countryList else { return }
            tableData[currentIndex].userRegisterInfo?.nationalString = countryList?[ pickerV.selectedRow(inComponent: 0)].country
        break
        case .country:
            guard let _ = countryList else { return }
            tableData[currentIndex].userRegisterInfo?.string = countryList![ pickerV.selectedRow(inComponent: 0)].country
            tableData[currentIndex].userRegisterInfo?.isFilled = true
            personalData.countryId = countryList![ pickerV.selectedRow(inComponent: 0)].id
        case .city:
            tableData[currentIndex].userRegisterInfo?.string = cityList![ pickerV.selectedRow(inComponent: 0)].city
            tableData[currentIndex].userRegisterInfo?.isFilled = true
            personalData.city = cityList![ pickerV.selectedRow(inComponent: 0)].city
            
        }

        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
        if pickerType != .nationalCountry {
            insertTableCell()
        }
    }
}

//MARK: UITableViewDataSource
//MARK: ---------------------------
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
            case Constant.Texts.calendar:
                return calendarCell(indexPath: indexPath,model: model, isExpireDate: false)
            case Constant.Texts.expityDate,
                 Constant.Texts.issueDateDrivingLicense,
                 Constant.Texts.expityDateDrivingLicense:
                return calendarCell(indexPath: indexPath,model: model, isExpireDate: true)
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
    
    
    //MARK: TABLE CELLS
    //MARK: ---------------------
    private func infoMessageCell(indexPath: IndexPath, model: RegistrationBotModel) -> InfoMessageTableViewCell{
        let cell = mTableV.dequeueReusableCell(withIdentifier: InfoMessageTableViewCell.identifier, for: indexPath) as! InfoMessageTableViewCell
        cell.setCellInfo(items: tableData, index: indexPath.row)
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    private func userFillFieldCell(indexPath: IndexPath, model: RegistrationBotModel) -> UserFillFieldTableViewCell {
        
    let cell = mTableV.dequeueReusableCell(withIdentifier: UserFillFieldTableViewCell.identifier, for: indexPath) as! UserFillFieldTableViewCell
      cell.setCellInfo(item: model)
      cell.delegate = self
      return cell
    }
    
    private func phoneNumberCell(indexPath: IndexPath, model: RegistrationBotModel) -> PhoneNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
        if let _ = currentPhoneCode {
            cell.selectedCountry = currentPhoneCode
            cell.mPhoneNumberTxtFl.formatPattern = currentPhoneCode?.mask ?? ""
            cell.validFormPattern = (currentPhoneCode?.mask!.count)!
        }
        cell.setCellInfo(item: model)
        cell.delegate = self
          return cell
    }
    
    private func calendarCell(indexPath: IndexPath, model: RegistrationBotModel, isExpireDate: Bool) -> CalendarTableViewCell {
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model)
        cell.isExpireDate = isExpireDate
        return cell
    }
    
    private func mailBoxCell(indexPath: IndexPath, model: RegistrationBotModel) -> MailBoxNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: MailBoxNumberTableViewCell.identifier, for: indexPath) as! MailBoxNumberTableViewCell
        cell.delegate = self
        cell.setCellInfo(item: model)
        return cell
    }
    
    private func nationalRegisterCell(indexPath: IndexPath, model: RegistrationBotModel) -> NationalRegisterNumberTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: NationalRegisterNumberTableViewCell.identifier, for: indexPath) as! NationalRegisterNumberTableViewCell
        cell.selectedCountry = currentCountry
//        cell.mTextFl.formatPattern = currentCountry?.nationalDocumentMask ?? ""
//        cell.validFormPattern = (currentCountry?.nationalDocumentMask!.count)!
        cell.setCellInfo(item: model)
        cell.delegate = self
        return cell
    }
    
    private func takePhotoCell(indexPath: IndexPath, model: RegistrationBotModel) -> TakePhotoTableViewCell{
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: TakePhotoTableViewCell.identifier, for: indexPath) as! TakePhotoTableViewCell
        cell.setCellInfo(item: model)
        cell.delegate = self
        return cell
    }
    
    private func examplePhotoCell(indexPath: IndexPath, model: RegistrationBotModel) -> ExamplePhotoTableViewCell {
        
        let cell = mTableV.dequeueReusableCell(withIdentifier: ExamplePhotoTableViewCell.identifier, for: indexPath) as! ExamplePhotoTableViewCell
         cell.mImageV.image = model.examplePhoto
         return cell
    }
}




//MARK: - UserFillFieldTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UserFillFieldTableViewCellDelegate {
    
    func didBeginEdithingTxtField(txtFl: UITextField) {
        activeTextField = txtFl
    }
    
    func didPressStart() {
        self.tableData[self.currentIndex].userRegisterInfo?.isFilled =  true
        self.insertTableCell()
       // signIn()
    }

    func didReturnTxtField(txt: String?) {
        tableData[currentIndex].userRegisterInfo?.string = txt
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        insertTableCell()
    }
    
    func willOpenPicker(textFl: UITextField, viewType: ViewType) {
       // countryList
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar()
        textFl.isHidden = true
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if viewType == .country {
            pickerType = .country
        } else if viewType == .city {
            pickerType = .city
        }
        pickerV.delegate = self
        pickerV.dataSource = self
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
        default: break
        }
    }
}
 

//MARK: - PhoneNumberTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: PhoneNumberTableViewCellDelegate {
    
    func didPressCountryCode() {
        let searchPhoneCodeVC = SearchPhoneCodeViewController.initFromStoryboard(name: Constant.Storyboards.searchPhoneCode)
        searchPhoneCodeVC.delegate = self
        self.present(searchPhoneCodeVC, animated: true, completion: nil)
    }
    
    func didReturnTxtField(text: String, code: String) {
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo( string: text, isFilled: true)
        insertTableCell()
        personalData.phoneNumber = code + text
    }
}


//MARK: - CalendarTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: CalendarTableViewCellDelegate {
    
    func willOpenPicker(textFl: UITextField, isExpireDate: Bool) {
        
        textFl.inputView = datePicker
        textFl.inputAccessoryView = creatToolBar()
        textFl.isHidden = true
        pickerType = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        if isExpireDate {
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
        case .expityDate:
            if registrationState == .IDENTITY_BACK {
                addIdentityExpirationDate(expityDate: calendarData)
            }
        case .issueDateDrivingLicense:
            
            driverLicenseDateData.issueDate = calendarData
            
        case .expityDateDrivingLicense:
            
            if registrationState == .DRIVING_LICENSE_BACK {
                driverLicenseDateData.expirationDate = calendarData
                addDriverLicenseDate()
            }
        default:
            break
        }
    }
    
    private func addIdentityExpirationDate(expityDate: String) {
        registrationBotViewModel.addIdentityExpiration(experationDate: expityDate) { (result) in
            //Will changed
            if result == "SUCCESS" {
                self.registrationState = .IDENTITY_EXPIRATION
            } else {
                self.showAlertMessage(Constant.Texts.errIDExpirationDate)
            }
            print (result)
        }
        
    }
    
    private func addDriverLicenseDate() {
        registrationBotViewModel.addDriverLicenseDates(driverLicenseDateData: driverLicenseDateData) { (result) in
            //Will changed
            if result == "SUCCESS" {
                self.registrationState = .DRIVING_LICENSE_DATES
            } else {
                self.showAlertMessage(Constant.Texts.errDrivLicenseDate)
            }
            print (result)
        }
    }
}



//MARK: - MailBoxNumberTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: MailBoxNumberTableViewCellDelegate {
    
    func didReturn(text: String?, noMailBox: Bool) {
        
        if text?.count ?? 0 > 0 && !noMailBox {
            tableData[currentIndex].userRegisterInfo?.string = text
        }
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        personalData.mailBox = text ?? ""
        self.insertTableCell()
    }
}



//MARK: - NationalRegisterNumberTableViewCellDelegate
//MARK: -------------------------------------------
extension RegistartionBotViewController: NationalRegisterNumberTableViewCellDelegate {
    func didPressOtherCountryNational(isClicked: Bool) {
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo(isOtherNational: isClicked)
        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
        tableScrollToBottom()
    }
    
    func didReturnTxt(txt: String?) {
        tableData[currentIndex].userRegisterInfo?.string = txt
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        insertTableCell()
        personalData.nationalRegisterNumber = txt
        
        if registrationState == .PERSONAL_DATA {
            sendPersonalData(personalData: personalData)
        }
    }
    
    func willOpenPicker(textFl: UITextField) {
       // countryList
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar()
        textFl.isHidden = true
        pickerType = .nationalCountry
        pickerV.delegate = self
        pickerV.dataSource = self
    }
}



//MARK: - TakePhotoTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: TakePhotoTableViewCellDelegate {
    
    func didPressTackePhoto(isOpenDoc: Bool) {
        if isOpenDoc {
            let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
            bkdAgreementVC.delegate = self
            self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
        } else {
            takePhotoPressed()
        }
    }
}

//MARK: - BkdAgreementViewControllerDelegate
//MARK: ----------------------------
extension RegistartionBotViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
        mConfirmBckgV.isHidden = false
        tableData[currentIndex].userRegisterInfo  = UserRegisterInfo(isFilled: true)
        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
        insertTableCell()
    }
}


//MARK: - SearchPhoneCodeViewControllerDelegate
//MARK: --------------------------------------
extension RegistartionBotViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCode) {
        currentPhoneCode = country
        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
    }
}

//MARK: - UIImagePickerControllerDelegate
//MARK: --------------------------------
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
    
    private func uploadImage(image: UIImage) {
        let uploadState = documentStateArr[imageUploadCounter]
       
        
        let newImage = image.resizeImage(targetSize: CGSize(width: 50, height: 50))
        registrationBotViewModel.imageUpload(image: newImage,
                                             id: mainDriver?.id ?? "",
                                             state: "IF") { [self] (result) in
//            if result == "SUCCESS" {
//                DispatchQueue.main.async { [self] in
//                    tableData[self.currentIndex].userRegisterInfo = UserRegisterInfo(photo: image, isFilled: true)
//                    mTableV.reloadRows(at: [IndexPath(row: self.currentIndex, section: 0)], with: .automatic)
//                    self.insertTableCell()
//                }
//                self.isTakePhoto = false
//                self.imageUploadCounter += 1
//                if uploadState == "IB" {
//                    self.registrationState = .IDENTITY_BACK
//                } else if uploadState == "DLB" {
//                    self.registrationState = .DRIVING_LICENSE_BACK
//                }
//            } else {
//                self.showAlertMessage(Constant.Texts.errImageUpload)
//            }            
        }
    }
  
}

//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .country || pickerType == .nationalCountry {
            return countryList?.count ?? 0
        }
        return cityList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == .country || pickerType == .nationalCountry {
            currentCountry = countryList![row]
            return countryList![row].country
        }
        return cityList![row].city
    }
}
