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
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    var tableData:[RegistrationBotModel] = [RegistrationBotData.registrationBotModel[0]]
    var timer: Timer?
    var datePicker = UIDatePicker()
    var pickerV = UIPickerView()
    var pickerList: [String]?
    private var currentIndex = 0

    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        configureTableView()
    }
    
    func configureTableView() {
        mTableV.register(InfoMessageTableViewCell.nib(), forCellReuseIdentifier: InfoMessageTableViewCell.identifier)
        mTableV.register(ExamplePhotoTableViewCell.nib(), forCellReuseIdentifier: ExamplePhotoTableViewCell.identifier)
        mTableV.register(UserFillFieldTableViewCell.nib(), forCellReuseIdentifier: UserFillFieldTableViewCell.identifier)
        mTableV.register(PhoneNumberTableViewCell.nib(), forCellReuseIdentifier: PhoneNumberTableViewCell.identifier)
        mTableV.register(CalendarTableViewCell.nib(), forCellReuseIdentifier: CalendarTableViewCell.identifier)
        mTableV.register(MailBoxNumberTableViewCell.nib(), forCellReuseIdentifier: MailBoxNumberTableViewCell.identifier)
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
        mTableV.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .bottom, animated: true)
        startTimer()
    }

    func updateTableContentInset() {
        let contentInsetTop = mTableV.frame.size.height - mTableV.contentSize.height
        if mTableV.contentSize.height >= contentInsetTop {
            mTableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsetTop, right: 0)
            mTableV.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .bottom, animated: true)
            
        }
        
    }
    
//    func updateModelObj(<#parameters#>) {
//        tableData[currentIndex].userRegisterInfo = UserRegisterInfo(date: datePicker.date, isFilled: true)
//    }
    
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
        tableData[currentIndex].userRegisterInfo = UserRegisterInfo(date: datePicker.date, isFilled: true)
        mTableV.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
       // mTableV.reloadData()
       // updateTableContentInset()

       insertTableCell()
    }
    //MARK: Keyboard NSNotification
    //MARK: ---------------------------
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            UIView.animate(withDuration: 0.2) { [self] in
                self.mTableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            }
           }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: { [self] in
            self.mTableV.contentInset = .zero
        })
    }
    
    
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
        if  let _ = model.msgToFill {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoMessageTableViewCell.identifier, for: indexPath) as! InfoMessageTableViewCell
            cell.setCellInfo(items: tableData, index: indexPath.row)
            return cell
            
        } else if let _ = model.examplePhoto {
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
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
                  cell.setCellInfo(item: model)
                  return cell
   
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
              cell.setCellInfo(item: model)
              return cell
        }

    }
    

    
}



//MARK: UserFillFieldTableViewCellDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UserFillFieldTableViewCellDelegate {
    
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
    
    func willOpenPicker(textFl: UITextField, isCountry: Bool) {
       // countryList
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar()
        textFl.isHidden = true
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        pickerList = isCountry ? countryList : cityList
        pickerV.delegate = self
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

//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension RegistartionBotViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "First \(row)"
    }
}
