//
//  AddAccidentDetailsViewController.swift
//  AddAccidentDetailsViewController
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit

class AddAccidentDetailsViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mDateAndLocationV: DateAndLocationView!
    @IBOutlet weak var mDamageSideLb: UILabel!
    @IBOutlet weak var mDamageSideTbV: DamageSidesTableView!
    @IBOutlet weak var mDamageSideTableHeight: NSLayoutConstraint!
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
    
    var currIndexOfDamageSide: Int = 0

    
    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mDamageSideTableHeight.constant = mDamageSideTbV.contentSize.height

    }
    
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        handlerConfirm()
    }
    
    ///Configure delegates
    func configureDelegates() {
        mDateAndLocationV.delegate = self
        mDamageSideTbV.damageSidesDelegate = self
        pickerV.delegate = self
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
        case .time :
            mDateAndLocationV.updateTime(datePicker: datePicker)
        default:
            let side = sidesList[pickerV.selectedRow(inComponent: 0)]
            
            updateDamageSideList(side: side,
                                 img: nil,
                                 isTakePhoto: nil)
        }
        
    }
    
    
    ///Update damage side list
    func updateDamageSideList(side: String?,
                              img: UIImage?,
                              isTakePhoto:Bool?) {
        
        mDamageSideTbV.damageSideArr =    addAccidentDetailViewModel.updateDamageSideList(side: side,
                                                          img: img,
                                                          isTakePhoto: isTakePhoto, damageSideArr: mDamageSideTbV.damageSideArr, currIndex: currIndexOfDamageSide)       
        mDamageSideTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
            self.view.setNeedsLayout()

        }
    }
    
    
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func handlerConfirm() {
        
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
        self.goToSeeMap(parking: nil)
    }
}


//MARK: -- DamageSidesTableViewDelegate
//MARK: ---------------------------------
extension AddAccidentDetailsViewController: DamageSidesTableViewDelegate {
    
    func didPressTakePhoto() {
        ///Will creat actionshit for camera and photo library
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
            self.updateDamageSideList(side:nil,
                                 img: nil,
                                 isTakePhoto: true)
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
    }
    
    func didPressAddMore() {
        mDamageSideTbV.damageSideArr = addAccidentDetailViewModel.addDamageSide(damageSideArr: mDamageSideTbV.damageSideArr)
        mDamageSideTbV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.view.setNeedsLayout()

        }
    }
    
    
    func willOpenPicker(textFl: UITextField) {
        
        textFl.inputView = pickerV
        textFl.inputAccessoryView = creatToolBar()
        responderTxtFl = textFl
        self.currIndexOfDamageSide = textFl.tag
    }
    
    ///Will present image Picker controller
    private func presentPicker (sourceType: UIImagePickerController.SourceType) {
       // isTakePhoto = true
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
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
        updateDamageSideList(side:nil,
                             img: nil,
                             isTakePhoto: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        updateDamageSideList(side:nil,
                             img: image,
                             isTakePhoto: false)
       // if isTakePhoto {
           // uploadImage(image: image)
            
        //}
    }
    
   
}
