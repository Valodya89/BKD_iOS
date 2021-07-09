//
//  RegistartionBotViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class RegistartionBotViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlets
    @IBOutlet weak var mTableV: UITableView!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    
    var tableData:[RegistrationBotModel] = [RegistrationBotData.registrationBotModel[0]]
    var timer: Timer?
    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var pickerList: [String]?
    private var currentIndex = 0
    private var isDatePicker = true
    private var activeTextField: UITextField?

    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
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
        mRightBarBtn.image = img_bkd
        configureTableView()
    }
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
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

        startTimer()
    }

    func startTimer() {
        if timer == nil {
            let seconds = 0.5
            timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateTableCell), userInfo: nil, repeats: true)
          }
    }
    
    func stopTimer() {
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
    }
    
    @objc func updateTableCell () {
        if RegistrationBotData.registrationBotModel[currentIndex].viewDescription == nil {
            insertTableCell()
        } else {
            stopTimer()
        }
        
    }
    
    func insertTableCell() {
        tableData.append(RegistrationBotData.registrationBotModel[currentIndex + 1])
        mTableV.beginUpdates()
        mTableV.insertRows(at: [IndexPath.init(row: tableData.count-1, section: 0)], with: .automatic)
        mTableV.endUpdates()
//        mTableV.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .bottom, animated: true)

        DispatchQueue.main.async { [self] in
            self.mTableV.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .none, animated: true)
        }
        startTimer()
    }

//    func updateTableContentInset() {
//        let contentInsetTop = mTableV.frame.size.height - mTableV.contentSize.height
//        if mTableV.contentSize.height >= contentInsetTop {
//            mTableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsetTop, right: 0)
//
//
//            DispatchQueue.main.async { [self] in
//                let index = IndexPath(row: self.currentIndex, section: 0)
//                self.mTableV.scrollToRow(at: index, at: .bottom, animated: true)
//            }
//            mTableV.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .bottom, animated: true)
//
//        }
//
//    }
//
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
    
    ///Will present Picker controller
    private func presentPicker (sourceType: UIImagePickerController.SourceType) {
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
    
    @objc func donePressed() {
        if isDatePicker {
            tableData[currentIndex].userRegisterInfo = UserRegisterInfo(date: datePicker.date, isFilled: true)
        } else {
            tableData[currentIndex].userRegisterInfo?.string = pickerList![ pickerV.selectedRow(inComponent: 0)]
            tableData[currentIndex].userRegisterInfo?.isFilled = true
        }

        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
       // mTableV.reloadData()
       // updateTableContentInset()

       insertTableCell()
    }
    //MARK: Keyboard NSNotification
    //MARK: ---------------------------
    
    @objc func keyboardWillShow (notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
           keyboardFrame = self.view.convert(keyboardFrame, from: nil)

           var contentInset:UIEdgeInsets = self.mTableV.contentInset
           contentInset.bottom = keyboardFrame.size.height
        mTableV.contentInset = contentInset
        
        
        
//        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
//
//            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0);
//                   self.mTableV.contentInset = contentInsets;
//                   self.mTableV.scrollIndicatorInsets = contentInsets;


            //            UIView.animate(withDuration: 0.2) { [self] in
//                self.mTableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//            }
    //       }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: { [self] in
            self.mTableV.contentInset = .zero
        })
    }

    
    
    
//    NSDictionary* info = [aNotification userInfo];
//       CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//       UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//       self.myTableView.contentInset = contentInsets;
//       self.myTableView.scrollIndicatorInsets = contentInsets;

    
    
    
    @IBAction func beck(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}


extension RegistartionBotViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableData[indexPath.row]
        currentIndex = tableData.count - 1
//        if  let _ = model.msgToFill {
//            let cell = tableView.dequeueReusableCell(withIdentifier: InfoMessageTableViewCell.identifier, for: indexPath) as! InfoMessageTableViewCell
//            cell.setCellInfo(items: tableData, index: indexPath.row)
//            cell.layoutIfNeeded()
//            cell.setNeedsLayout()
//
//            return cell
//
//        } else
        if let _ = model.examplePhoto {
           let cell = tableView.dequeueReusableCell(withIdentifier: ExamplePhotoTableViewCell.identifier, for: indexPath) as! ExamplePhotoTableViewCell
            cell.mImageV.image = model.examplePhoto
            return cell

        } else if let _ = model.viewDescription {
            switch model.viewDescription {
            case "button", "txtFl":
              let cell = tableView.dequeueReusableCell(withIdentifier: UserFillFieldTableViewCell.identifier, for: indexPath) as! UserFillFieldTableViewCell
                cell.setCellInfo(item: model)
                cell.delegate = self
                return cell
            case  "phone" :
                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
                  cell.setCellInfo(item: model)
                cell.delegate = self
                  return cell
            case  "calendar" :
                let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
                cell.setCellInfo(item: model)
                cell.delegate = self
                return cell
            case  "mailbox" :
                let cell = tableView.dequeueReusableCell(withIdentifier: MailBoxNumberTableViewCell.identifier, for: indexPath) as! MailBoxNumberTableViewCell
                cell.setCellInfo(item: model)
                cell.delegate = self
                return cell
            case  "national register" :
                let cell = tableView.dequeueReusableCell(withIdentifier: NationalRegisterNumberTableViewCell.identifier, for: indexPath) as! NationalRegisterNumberTableViewCell
                
                cell.setCellInfo(item: model)
                cell.delegate = self
                return cell
//            case  "takePhoto" :
//                let cell = tableView.dequeueReusableCell(withIdentifier: TakePhotoTableViewCell.identifier, for: indexPath) as! TakePhotoTableViewCell
//                
//                cell.setCellInfo(item: model)
//                cell.delegate = self
//                return cell
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TakePhotoTableViewCell.identifier, for: indexPath) as! TakePhotoTableViewCell
                
                cell.setCellInfo(item: model)
                cell.delegate = self
                return cell
//                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
//                  cell.setCellInfo(item: model)
//                  return cell
   
            }
        } else { // info message
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoMessageTableViewCell.identifier, for: indexPath) as! InfoMessageTableViewCell
            cell.setCellInfo(items: tableData, index: indexPath.row)
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableData[indexPath.row].userRegisterInfo?.isOtherNational != nil &&  tableData[indexPath.row].userRegisterInfo?.isOtherNational == true  {
            return 176
        } else if  tableData[indexPath.row].userRegisterInfo?.photo != nil &&  tableData[indexPath.row].userRegisterInfo?.isFilled == true {
            return 244
        }
            
        return UITableView.automaticDimension
    }
}




//MARK: UserFillFieldTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UserFillFieldTableViewCellDelegate {
    func didBeginEdithingTxtField(txtFl: UITextField) {
        activeTextField = txtFl
    }
    
    
    func didPressStart() {
        tableData[currentIndex].userRegisterInfo?.isFilled =  true
        // updateModelObj()
        insertTableCell()
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
        isDatePicker = false
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if viewType == .country {
            pickerList = countryList
        } else if viewType == .city {
            pickerList = cityList
        }        
        pickerV.delegate = self
        pickerV.dataSource = self
    }

}
 

//MARK: PhoneNumberTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: PhoneNumberTableViewCellDelegate {
    
    func didPressCountryCode() {
        let searchPhoneCodeVC = SearchPhoneCodeViewController.initFromStoryboard(name: Constant.Storyboards.searchPhoneCode)
        self.present(searchPhoneCodeVC, animated: true, completion: nil)
    }
    
    func didReturnTxtField(text: String?) {
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo( string: text, isFilled: true)
        insertTableCell()
    }
    
    
    
}


//MARK: CalendarTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: CalendarTableViewCellDelegate {
    func willOpenPicker(textFl: UITextField, isCalendar: Bool) {
        //self.view.addSubview(self.backgroundV)
       // let datePicker = UIDatePicker()
        textFl.inputView = datePicker
        textFl.inputAccessoryView = creatToolBar()
        textFl.isHidden = true
        isDatePicker = true
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    if isCalendar {
        datePicker.datePickerMode = .date
        datePicker.minimumDate =  Date()
        datePicker.locale = Locale(identifier: "en")
    }
    }
}



//MARK: MailBoxNumberTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: MailBoxNumberTableViewCellDelegate {
    
    func didReturn(text: String?, noMailBox: Bool) {
        
        if text?.count ?? 0 > 0 && !noMailBox {
            tableData[currentIndex].userRegisterInfo?.string = text
        }
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        self.insertTableCell()
    }
    
    
}



//MARK: NationalRegisterNumberTableViewCellDelegate
//MARK: -------------------------------------------
extension RegistartionBotViewController: NationalRegisterNumberTableViewCellDelegate {
    func didPressOtherCountryNational() {
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo(isOtherNational: true)
        mTableV.reloadData()

//        tableData[currentIndex].userRegisterInfo?.isFilled =  true
//        // updateModelObj()
//        insertTableCell()
    }
    
    func didReturnTxt(txt: String?) {
        tableData[currentIndex].userRegisterInfo?.string = txt
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        insertTableCell()
    }
    
//    func willOpenPicker(textFl: UITextField, viewType: ViewType) {
//       // countryList
//        textFl.inputView = pickerV
//        textFl.inputAccessoryView = creatToolBar()
//        textFl.isHidden = true
//        isDatePicker = false
//        if #available(iOS 14.0, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        } else {
//            // Fallback on earlier versions
//        }
//        if viewType == .country {
//            pickerList = countryList
//        } else if viewType == .city {
//            pickerList = cityList
//        }
//        pickerV.delegate = self
//        pickerV.dataSource = self
//    }

}



//MARK: TakePhotoTableViewCellDelegate
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

//MARK: BkdAgreementViewControllerDelegate
//MARK: ----------------------------
extension RegistartionBotViewController: BkdAgreementViewControllerDelegate {
    func agreeTermsAndConditions() {
        tableData[currentIndex].userRegisterInfo?.isFilled = true
        mTableV.reloadData()
        insertTableCell()
    }
}

//MARK: UIImagePickerControllerDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo(photo: image, isFilled: true)
        mTableV.reloadData()
        insertTableCell()
    }
}

//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        
    }
}



