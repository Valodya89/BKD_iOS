//
//  myPersonalInfoTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit


class MyPersonalInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    public var isEdit: Bool = false
    public var mainDriverList: [MainDriverModel]?
    public var editMainDriverList: [MainDriverModel]?
    var didPressChangePhoto:((Int)->Void)?
    var didPressCancel:(()->Void)?
    var didPressConfirm:(()->Void)?
    var willOpenCountry:(()-> Void)?
    var willOpenCity:(()-> Void)?
    var willOpenPhoneVerify:(()-> Void)?

    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var responderTxtFl = UITextField()
    var countryList: [Country]?
    var currentCountry: Country?


    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        configuredelegates()
        registerTableCells()
        getCountryList()
        
    }
    
    ///Get country list
    func getCountryList() {
        countryList = ApplicationSettings.shared.countryList
        if countryList == nil {
            getCountryList()
        }
    }
    
    /// Register table view cells
    func registerTableCells() {
        self.register(PersonalInfoTableCell.nib(), forCellReuseIdentifier: PersonalInfoTableCell.identifier)
        self.register(MailBoxNumberTableCell.nib(), forCellReuseIdentifier: MailBoxNumberTableCell.identifier)
        self.register(PhotosTableViewCell.nib(), forCellReuseIdentifier: PhotosTableViewCell.identifier)
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
            mainDriverList?[sender.tag].fieldValue = currentCountry?.id
        } else {
            let date:Date? = datePicker.date
            let dateStr = (date?.getDay())! + " " + (date?.getMonth(lng: "en"))! + " " + (date?.getYear())!
            mainDriverList?[sender.tag].fieldValue = dateStr
        }
        self.reloadData()
    }

    
    //MARK: -- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainDriverList?.count ?? 0 > 0 && isEdit {
            return mainDriverList!.count + 1
        }
        return mainDriverList?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: MainDriverModel = MainDriverModel()
        if indexPath.row < mainDriverList?.count ?? 0  {
            item = mainDriverList![indexPath.row]
        }
        if item.isMailBox {
            return mailBoxTableViewCell(item: item, indexPath: indexPath)
        } else if item.isPhoto {
            return photosTableViewCell(item: item,
                                       indexPath: indexPath)
        } else if indexPath.row == mainDriverList?.count && isEdit {
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
    
    ///Init mail box table cell
    func mailBoxTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> MailBoxNumberTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: MailBoxNumberTableCell
                                        .identifier, for: indexPath) as! MailBoxNumberTableCell
        cell.isEdit = isEdit
        cell.setCellInfo(item: item, index: indexPath.row)
        cell.didChangeMailbox = { txt in
            self.mainDriverList![indexPath.row].fieldValue = txt
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
            self.mainDriverList = self.editMainDriverList
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
    
    func didPressVerify() {
        <#code#>
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

//MARK: -- UIPickerViewDelegate, UIPickerViewDataSource
extension MyPersonalInfoTableView: UIPickerViewDelegate, UIPickerViewDataSource {
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


