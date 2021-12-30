//
//  AddAccidentDetailsViewController.swift
//  AddAccidentDetailsViewController
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit
import CoreLocation


class AddAccidentDetailsViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mDateAndLocationV: DateAndLocationView!
    @IBOutlet weak var mDamageSideLb: UILabel!
    @IBOutlet weak var mDamageSideTbV: DamageSidesTableView!
    @IBOutlet weak var mDamageSideTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mAccidentFormHeight: NSLayoutConstraint!
    @IBOutlet weak var mFilledAccidentLb: UILabel!
    @IBOutlet weak var mAccidentFormTbV: AccidentFormTableView!
    @IBOutlet weak var mConfirmV: ConfirmView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    
    //MARK: -- Variables
    lazy var addAccidentDetailViewModel =  AddAccidentDetailViewModel()
    var dateAndLocationState: DateAndLocationState?
    var datePicker = UIDatePicker()
    let pickerV = UIPickerView()

    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    var isDamageSide = true
    var currIndexOfDamageSide: Int = 0
    var currIndexOfAccidentForm: Int = 0
    var accidentCoordinate: CLLocationCoordinate2D?
    var isCancelAccident = false
    public var currRentModel: Rent?
    var accidentId: String?
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
        self.view.addGestureRecognizer(gesture)
        setupView()
        configureDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mDamageSideTableHeight.constant = mDamageSideTbV.contentSize.height
        mAccidentFormHeight.constant = mAccidentFormTbV.contentSize.height

    }
    

    func setupView() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mConfirmV.needsCheck = true
        mDamageSideTbV.disableView()
        mAccidentFormTbV.disableView()
        handlerConfirm()
    }
    
    ///Configure delegates
    func configureDelegates() {
        mDateAndLocationV.delegate = self
        mDamageSideTbV.damageSidesDelegate = self
        mAccidentFormTbV.accidentFormDelegate = self
        pickerV.delegate = self
    }
    
    ///Add accident
    func addAccident() {
        addAccidentDetailViewModel.addAccident(id: currRentModel?.id ?? "",
                                               date: mDateAndLocationV.date ?? Date(),
                                               time:mDateAndLocationV.time ?? Date(),
                                               address: mDateAndLocationV.location ?? "", coordinate: accidentCoordinate!) { result in
            guard let _ = result else {return}
            self.mDamageSideTbV.enableView()
            self.accidentId = result!.id
            print (result!)
        }
    }
    
    ///Add accident damage
    func addAccidentDamageWithSide(image: UIImage) {
        let currDamageSide = mDamageSideTbV.damageSideArr.last
        addAccidentDetailViewModel.addAccidentWithSide(image: image, id: accidentId ?? "", side: currDamageSide?.damageSide ?? "") { result, err in
            guard let accident = result else { return }
            if accident.damages.count > 0 {
                self.mAccidentFormTbV.enableView()
                self.updateDamageSideList(side:nil,
                                          img: image,
                                          isTakePhoto: false)
            }
        }
    }
    
    ///Add accident form
    func addForm(image: UIImage) {
        addAccidentDetailViewModel.addAccidentForm(image: image, id: accidentId ?? "") { result, err in
            guard let accident = result else { return }
            if accident.form.count > 0 {
                self.updateAccidentFormList(img: image, isTakePhoto: false)
            }
        }
    }
    
  ///Approve accident
    func approveAccident() {
        addAccidentDetailViewModel.approveAccident(id: accidentId ?? "") { result in
            guard let _ = result else { return }
            self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
        }
    }
    
    ///Approve accident
      func cancelAccident() {
          addAccidentDetailViewModel.cancelAccident(id: accidentId ?? "") { result in
              guard let _ = result else { return }
              self.navigationController?.popToViewController(ofClass: MyReservationsViewController.self)
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
        
        switch dateAndLocationState {
   
        case .date:
            mDateAndLocationV.updateDateInfo(datePicker: datePicker)
            checkDamageData()
        case .time :
            mDateAndLocationV.mDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            mDateAndLocationV.updateTime(datePicker: datePicker)
            checkDamageData()

        case  .location:
            checkDamageData()
            break
        default:
            let side = sidesList[pickerV.selectedRow(inComponent: 0)]
            
            updateDamageSideList(side: side,
                                 img: nil,
                                 isTakePhoto: nil)
        }
        
    }
    
    ///Check id fill all damege data info
    func checkDamageData() {
        if let _ = mDateAndLocationV.date,
           let _ = mDateAndLocationV.time,
           let _ = mDateAndLocationV.location {
             addAccident()
        }
    }
    
    ///Update damage side list
    func updateDamageSideList(side: String?,
                              img: UIImage?,
                              isTakePhoto:Bool?) {
        
        mDamageSideTbV.damageSideArr =    addAccidentDetailViewModel.updateDamageSideList(side: side,
                                                                                          img: img,
                                                                                          isTakePhoto: isTakePhoto,
                                                                                          damageSideArr: mDamageSideTbV.damageSideArr,
                                                                                          currIndex: currIndexOfDamageSide)
        mDamageSideTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.view.setNeedsLayout()

        }
    }
    
    
    ///Update accident form side list
    func updateAccidentFormList(img: UIImage?,
                                isTakePhoto:Bool?) {
        
        mAccidentFormTbV.accidentFormArr = addAccidentDetailViewModel.updateAccidentFormList(img: img,
                                                                                             isTakePhoto: isTakePhoto,
                                                                                             accidentFormArr: mAccidentFormTbV.accidentFormArr, currIndex: currIndexOfAccidentForm)
        mAccidentFormTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.view.setNeedsLayout()

        }
    }
    
    ///Will present image Picker controller
    private func presentPicker (sourceType: UIImagePickerController.SourceType) {
       // isTakePhoto = true
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    ///Will creat actionsheet for camera and photo library
     func openActionSheetForPhoto() {
        
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
        let cancelAction = UIAlertAction (title: Constant.Texts.cancel, style: .cancel){ [self] (action) in
            if isDamageSide {
                self.updateDamageSideList(side:nil,
                                     img: nil,
                                     isTakePhoto: true)
            } else {
                updateAccidentFormList(img: nil, isTakePhoto: true)
            }
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    ///Show alert forn confirm info of accident details
    func showAlertForConfirm() {
        BKDAlert().showAlert(on: self, message: Constant.Texts.confirmAccidentDetails, cancelTitle: Constant.Texts.cancel, okTitle: Constant.Texts.yes) {
            self.isCancelAccident = true
            self.mConfirmV.initConfirm()
        } okAction: {
            self.isCancelAccident = false
            self.approveAccident()
        }
    }
    
    ///Show cancel care accident
    func showCancelAccidentAlert() {
        if isCancelAccident {
            BKDAlert().showAlert(on: self, message: Constant.Texts.cancelAccident, cancelTitle: Constant.Texts.cancel, okTitle: Constant.Texts.yes) {
            } okAction: {
                self.cancelAccident()
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
            showCancelAccidentAlert()
    }
  
    ///Dismis Viewcontroller
    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
            showCancelAccidentAlert()
    }
    
    ///Handler confirm button
    func handlerConfirm() {
        mConfirmV.willCheckConfirm = {
            var isError = false
            if !self.mDateAndLocationV.checkAllFieldsAreFilled()  {
                isError = true
            }
            
            if !self.addAccidentDetailViewModel.isAccidentFormIsFilled(accidentFormList: self.mAccidentFormTbV.accidentFormArr)  {
                isError = true
                self.mAccidentFormTbV.accidentFormArr[0] = AccidentFormModel(isTakePhoto: true, isError: true)
                self.mAccidentFormTbV.reloadData()
            }
            
            let damageSideCheck = self.addAccidentDetailViewModel.isDamagesSideIsFilled(damagesSideList: self.mDamageSideTbV.damageSideArr)
            if !damageSideCheck.0 {
                isError = true
                self.mDamageSideTbV.damageSideArr = damageSideCheck.1
                self.mDamageSideTbV.reloadData()
            }
            
            if !isError {
                self.mConfirmV.needsCheck = false
                self.mConfirmV.clickConfirm()
            }
        }
        
        mConfirmV.didPressConfirm = {
            self.showAlertForConfirm()
        }
    }
}


//MARK: -- DateAndLocationViewDelegate
//MARK: ---------------------------------
extension AddAccidentDetailsViewController: DateAndLocationViewDelegate {
    func willOpenPicker(textFl: UITextField, dateAndLocationState: DateAndLocationState) {
        
        self.dateAndLocationState = dateAndLocationState
        self.view.addSubview(self.backgroundV)
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl

            
            self.datePicker = UIDatePicker()
            textFl.inputView = self.datePicker

            if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            } else {
                       // Fallback on earlier versions
            }
        if dateAndLocationState == .date {
            self.datePicker.datePickerMode = .date
            self.datePicker.locale = Locale(identifier: "en")
        } else if dateAndLocationState == .time {
            self.datePicker.datePickerMode = .time
        }
        
    }
        
    func openMap() {
        self.goToCustomLocationMapController(on: self, isAddDamageAddress: true)
    }
}


//MARK: -- DamageSidesTableViewDelegate
//MARK: ---------------------------------
extension AddAccidentDetailsViewController: DamageSidesTableViewDelegate {
    
    func didPressTakePhoto(index: Int) {
        isDamageSide = true
        currIndexOfDamageSide = index
        openActionSheetForPhoto()
    }
    
    func didPressAddMore(index: Int) {
        
        currIndexOfDamageSide = index
        mDamageSideTbV.damageSideArr = addAccidentDetailViewModel.addDamageSide(damageSideArr: mDamageSideTbV.damageSideArr)
        mDamageSideTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.view.setNeedsLayout()

        }
    }
    
    
    func willOpenPicker(textFl: UITextField) {
        dateAndLocationState = .none
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl
        self.currIndexOfDamageSide = textFl.tag
        
    }
        
}



//MARK: -- AccidentFormTableViewDelegate
//MARK: ---------------------------------
extension AddAccidentDetailsViewController: AccidentFormTableViewDelegate{
    
    func pressedTakePhoto(index: Int) {
        isDamageSide = false
        currIndexOfAccidentForm = index
        openActionSheetForPhoto()
        
    }
    
    func pressedAddMore(index: Int) {
        currIndexOfAccidentForm = index
        mAccidentFormTbV.accidentFormArr = addAccidentDetailViewModel.addAccidentForm(accidentFormList: mAccidentFormTbV.accidentFormArr)
        mAccidentFormTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.view.setNeedsLayout()

        }
    }
     
}


//MARK: UIPickerViewDelegate
//MARK: --------------------------------
extension AddAccidentDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sidesList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sidesList[row]
    }
}


//MARK: - UIImagePickerControllerDelegate
//MARK: --------------------------------
extension AddAccidentDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        if isDamageSide {
            updateDamageSideList(side:nil,
                                 img: nil,
                                 isTakePhoto: true)
        } else {
            updateAccidentFormList(img: nil, isTakePhoto: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        
        if isDamageSide {
            addAccidentDamageWithSide(image: image)
        } else {
            addForm(image: image)
        }
    }
}


//MARK: -- CustomLocationViewControllerDelegate
//MARK: -------------------------------------------
extension AddAccidentDetailsViewController: CustomLocationViewControllerDelegate {
    
    func getCustomLocation(_ locationPlace: String, coordinate: CLLocationCoordinate2D, price: Double?) {
        mDateAndLocationV.location = locationPlace
        mDateAndLocationV.mLocationTxtFl.text = locationPlace
        accidentCoordinate = coordinate
        checkDamageData()
    }
    
    
}
