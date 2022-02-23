//
//  myPersonalInfoTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit
import SVProgressHUD

class MyPersonalInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    public var isEdit: Bool = false
    public var isPhoneEdited: Bool = false
    public var mainDriverList: [MainDriverModel]?
    public var editMainDriverList: [MainDriverModel]?
    var didPressChangePhoto:((Int)->Void)?
    var didPressCancel:(()->Void)?
    var didPressConfirm:(()->Void)?
    var willOpenCountry:(()-> Void)?
    var willOpenCity:(()-> Void)?
    var willOpenPhoneCodes:(()-> Void)?
    var willOpenPhoneVerify:((String, String)-> Void)?

    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var responderTxtFl = UITextField()
    var countryList: [Country]?
    var currentCountry: Country?
    var account: Account?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        configuredelegates()
        registerTableCells()
        getCountryList()
        getAccount()
    }
    
    ///Get country list
    func getCountryList() {
        countryList = ApplicationSettings.shared.countryList
        if countryList == nil {
            getCountryList()
        }
    }
    
    ///Get user account
    public func getAccount() {
        ApplicationSettings.shared.getAccount { account in
            SVProgressHUD.show()
            self.account = account
            self.reloadData()
        }
    }
    
    /// Register table view cells
    func registerTableCells() {
        self.register(PersonalInfoTableCell.nib(), forCellReuseIdentifier: PersonalInfoTableCell.identifier)
        self.register(MailBoxNumberTableCell.nib(), forCellReuseIdentifier: MailBoxNumberTableCell.identifier)
        self.register(PhotosTableViewCell.nib(), forCellReuseIdentifier: PhotosTableViewCell.identifier)
        self.register(PhonbeNumberTableCell.nib(), forCellReuseIdentifier: PhonbeNumberTableCell.identifier)
        self.register(ConfirmOrCancelTableCell.nib(), forCellReuseIdentifier: ConfirmOrCancelTableCell.identifier)
    }
    
    ///Configure delegates
    func configuredelegates() {
        self.delegate = self
        self.dataSource = self
    }
    
    
    ///Creat tool bar
    func creatToolBar(index: Int) -> UIToolbar {
        //toolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar Button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePressed(sender:)))
        done.tag = index

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        return toolBar
    }

    
    ///Pressed done button
    @objc func donePressed(sender: UIBarButtonItem) {
        responderTxtFl.resignFirstResponder()
        
        if sender.tag == 7 {
            currentCountry = countryList?[ pickerV.selectedRow(inComponent: 0)]
            editMainDriverList?[sender.tag].fieldValue = currentCountry?.id
        } else {
            let dateStr = datePicker.date.getDateByFormat() 
            editMainDriverList?[sender.tag].fieldValue = dateStr
        }
        //datePicker = nil
        self.reloadData()
    }

   
    //MARK: -- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editMainDriverList?.count ?? 0 > 0 && isEdit {
            return editMainDriverList!.count + 1
        }
        return editMainDriverList?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: MainDriverModel = MainDriverModel()
        if indexPath.row < editMainDriverList?.count ?? 0  {
            item = editMainDriverList![indexPath.row]
        }
        if item.isMailBox {
            return mailBoxTableViewCell(item: item, indexPath: indexPath)
        } else if item.isPhoto {
            return photosTableViewCell(item: item,
                                       indexPath: indexPath)
        } else if item.isPhone {
            return phoneNumberTableViewCell(item: item, indexPath: indexPath)
        }
        else if indexPath.row == editMainDriverList?.count && isEdit {
            return confirmTableViewCell(indexPath: indexPath)
        }
        return personalInfoTableViewCell(item: item, indexPath: indexPath)
    }
    
    
    ///Init personal table cell
    func personalInfoTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> PersonalInfoTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: PersonalInfoTableCell
                                        .identifier, for: indexPath) as! PersonalInfoTableCell
        cell.delegate = self
        cell.isEdit = isEdit
        cell.item = item
        cell.setCellInfo(index: indexPath.row)
        return cell
    }
    
    
    ///Init phone number table cell
    func phoneNumberTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> PhonbeNumberTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: PhonbeNumberTableCell
                                        .identifier, for: indexPath) as! PhonbeNumberTableCell
        if account != nil && ((account?.phoneVerified) == true) {
            cell.mVerifiedV.isHidden = false
        } else {
            cell.mVerifiedV.isHidden = true
            cell.mVerifyBtn.isHidden = false
        }
        cell.delegate = self
        let currentPhoneCode = MyPersonalInformationViewModel().getCurrnetPhoneCode(code: item.phoneCode ?? "")
        if let _ = currentPhoneCode {
            cell.selectedCountry = currentPhoneCode
            cell.mTxtFl.formatPattern = currentPhoneCode?.mask ?? ""
            cell.validFormPattern = (currentPhoneCode?.mask!.count)!
        }
        
        cell.isEdit = isEdit
        cell.isEditedPhone = isPhoneEdited
        cell.item = item
        cell.setCellInfo(index: indexPath.row)
        return cell
    }
    
    ///Init mail box table cell
    func mailBoxTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> MailBoxNumberTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: MailBoxNumberTableCell
                                        .identifier, for: indexPath) as! MailBoxNumberTableCell
        cell.isEdit = isEdit
        cell.setCellInfo(item: item, index: indexPath.row)
        cell.didChangeMailbox = { txt in
            self.editMainDriverList![indexPath.row].fieldValue = txt
        }
        return cell
    }
    
    ///Init Photos table cell
    func photosTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> PhotosTableViewCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: PhotosTableViewCell
                                        .identifier, for: indexPath) as! PhotosTableViewCell
        cell.isEdit = isEdit
        cell.setCellInfo(item: item, index: indexPath.row)
        
        cell.didPressChangePhoto = { index in
            self.didPressChangePhoto?(index)
        }
        return cell
    }

    ///Init Photos table cell
    func confirmTableViewCell( indexPath: IndexPath) -> ConfirmOrCancelTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: ConfirmOrCancelTableCell
                                        .identifier, for: indexPath) as! ConfirmOrCancelTableCell
        cell.setCellInfo(index: indexPath.row)
        cell.didPressCancel = {
            self.editMainDriverList = self.mainDriverList
            self.reloadData()
            self.didPressCancel?()
        }
        cell.didPressConfirm = {
            self.didPressConfirm?()
        }
        return cell
    }
}


//MARK: -- PersonalInfoTableCellDelegate
extension MyPersonalInfoTableView: PersonalInfoTableCellDelegate {
    
    func editFiled(index: Int, value: String) {
        editMainDriverList?[index].fieldValue = value
    }
    
   
    
    func willOpenPhoneCodesView() {
        willOpenPhoneCodes?()
    }
    
    func willOpenCityView() {
        self.willOpenCity?()
    }
    
    func willOpenCountryPicker(textFl: TextField) {
        pickerV.delegate = self
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar(index: textFl.tag)
        responderTxtFl = textFl
    }
    
    
    func willOpenPicker(textFl: UITextField, isExpiryDate: Bool) {
        datePicker = UIDatePicker()
        responderTxtFl = textFl
        textFl.inputView = datePicker
        textFl.inputAccessoryView = creatToolBar(index: textFl.tag)
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
}


//MARK: -- PhonbeNumberTableCellDelegate
extension MyPersonalInfoTableView: PhonbeNumberTableCellDelegate {
    
    func editPhoneNumber(index: Int,
                         code: String,
                         phone: String) {
        editMainDriverList?[index].fieldValue = phone
        editMainDriverList?[index].phoneCode = code
    }
    
    func didPressVerify(phone: String, code: String) {
        willOpenPhoneVerify?(phone, code)
    }
}

//MARK: -- UIPickerViewDelegate, UIPickerViewDataSource
extension MyPersonalInfoTableView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return countryList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentCountry = countryList?[row]
        return countryList?[row].country ?? ""
    }
}


