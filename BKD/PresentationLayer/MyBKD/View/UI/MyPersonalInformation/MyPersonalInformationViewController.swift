//
//  MyPersonalInformationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit
import GooglePlaces
import simd
import SVProgressHUD

class MyPersonalInformationViewController: BaseViewController {
//MARK: -- Outlets
    //Verified
    @IBOutlet weak var mVerifiedPendingLb: UILabel!
    @IBOutlet weak var mVerifiedLb: UILabel!
    @IBOutlet weak var mVerifiedImgV: UIImageView!
    @IBOutlet weak var mPersonalInfoTbV: MyPersonalInfoTableView!
    @IBOutlet weak var mActivityInd: UIActivityIndicatorView!
    @IBOutlet weak var mEdifBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
         
    lazy var myPersonalInfoVM =  MyPersonalInformationViewModel()
    var isTakePhoto:Bool = false
    var currIndex = 0
    public var mainDriver: MainDriver?
    public var navigationTitle: String?
    

    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationControll(navControll: navigationController, barBtn: mRightBarBtn)
       self.title = navigationTitle ?? ""
        
        getMainDriverList()
        handlerChangePhoto()
        handlerCancel()
        handlerConfirm()
        handlerCountry()
        handlerCity()
        handlerPhoneNumber()
        handlerVerify()
        editingCompleted()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAccount()
    }
    
    
    ///Configure UI
    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        let isVerified = (mainDriver?.state == Constant.Texts.state_accepted)
        mVerifiedLb.isHidden = !isVerified
        mVerifiedImgV.isHidden = !isVerified
        mVerifiedPendingLb.isHidden = isVerified
    }
    
    ///Get main driver
    func getMainDriverList() {
        guard let mainDriver = self.mainDriver else {return}
        self.configureUI()
        SVProgressHUD.show()

        self.myPersonalInfoVM.getMainDriverList(mainDriver: mainDriver) { list in
            self.mPersonalInfoTbV.editMainDriverList = list
            self.mPersonalInfoTbV.mainDriverList = self.mPersonalInfoTbV.editMainDriverList
            self.mPersonalInfoTbV.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
                SVProgressHUD.dismiss()
             }

        }
    }
    
    ///Call get account
    func getAccount() {
        self.mPersonalInfoTbV.getAccount()
        self.mPersonalInfoTbV.reloadData()
        SVProgressHUD.dismiss()
    }
    
    ///Will present image Picker controller
     func presentPicker (sourceType: UIImagePickerController.SourceType) {
        isTakePhoto = true
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    ///Show alert forn confirm info of accident details
    func showAlertForConfirm() {
        BKDAlert().showAlert(on: self, message: Constant.Texts.confitmEdit, cancelTitle: Constant.Texts.cancel, okTitle: Constant.Texts.change) {
            self.editCancel()
        } okAction: {
            self.confirmEditing()
        }
    }
    
    ///Send request to confirm editing
    func confirmEditing() {
        SVProgressHUD.show()
        self.mEdifBtn.setImage(img_edit, for: .normal)
        self.mPersonalInfoTbV.isEdit = false
        mPersonalInfoTbV.isPhoneEdited = myPersonalInfoVM.isPhoneNumberEdited(newMainDrivers: mPersonalInfoTbV.editMainDriverList!, oldMainDrivers: mPersonalInfoTbV.mainDriverList!)
        self.myPersonalInfoVM.confirmEditedInfo(driverId: self.mainDriver?.id ?? "",
                                                       newMainDrivers: self.mPersonalInfoTbV.editMainDriverList!,
                                                       oldMainDrivers: self.mPersonalInfoTbV.mainDriverList!)
    }
    
    ///Editing completed
    func editingCompleted() {
        myPersonalInfoVM.didConfirmEditing = {
            self.mPersonalInfoTbV.mainDriverList = self.mPersonalInfoTbV.editMainDriverList
            self.getAccount()
        }
    }
   
    ///Cancel edit
    func editCancel(){
        self.mEdifBtn.setImage(img_edit, for: .normal)
        self.mPersonalInfoTbV.isEdit = false
        self.mPersonalInfoTbV.reloadData()
    }
    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        mEdifBtn.setImage(img_disable_edit, for: .normal)
        mPersonalInfoTbV.isEdit = true
        mPersonalInfoTbV.reloadData()
    }
    
    ///Handler change Photo button
    func handlerChangePhoto() {
        mPersonalInfoTbV.didPressChangePhoto = { index in
            self.currIndex = index
            self.openActionshitOfImages(viewContr: self)
        }
    }
    
    ///Handler cancel
    func handlerCancel() {
        mPersonalInfoTbV.didPressCancel = {
            self.editCancel()
        }
    }
    
    ///Handler confirm
    func handlerConfirm() {
        mPersonalInfoTbV.didPressConfirm = {

            if self.myPersonalInfoVM.areFilledFields(mainDrivers: self.mPersonalInfoTbV.editMainDriverList) {
                self.showAlertForConfirm()
            } else {
                self.mPersonalInfoTbV.reloadData()
            }
            
        }
    }
    
    ///Handler country filed
    func handlerCountry() {
        mPersonalInfoTbV.willOpenCountry = {
            self.goToSearchPhoneCode(viewCont: self)
        }
    }
    
    ///Handler city filed
    func handlerCity() {
        mPersonalInfoTbV.willOpenCity = {
            self.showAutocompleteViewController(viewController: self)
        }
    }
    
    ///Handler phone verify button
    func handlerVerify() {
        mPersonalInfoTbV.willOpenPhoneVerify = { phoneNumber, code in
            self.goToPhoneVerification(vehicleModel: nil, phoneNumber: phoneNumber, phoneCode: code, paymentOption: .none)
        }
    }
    
    ///Handler phone Number filed
    func handlerPhoneNumber() {
        mPersonalInfoTbV.willOpenPhoneCodes = {
            self.goToSearchPhoneCode(viewCont: self)
        }
    }
}

//MARK: -- SearchPhoneCodeViewControllerDelegate
extension MyPersonalInformationViewController: SearchPhoneCodeViewControllerDelegate {
    
    func didSelectCountry(_ country: PhoneCode) {
//        let phoneNumber = mPersonalInfoTbV.editMainDriverList?[2].fieldValue
//        let phoneObj = MyPersonalInformationViewModel().getCurrnetPhoneCode(number: phoneNumber ?? "")
//        let newNumber = phoneNumber?.replacingOccurrences(of: phoneObj?.code ?? "", with: country.code)
        mPersonalInfoTbV.editMainDriverList?[2].phoneCode = country.code
        mPersonalInfoTbV.reloadData()
    }
}


//MARK: -- UIImagePickerControllerDelegate
extension MyPersonalInformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
    
    func uploadImage(image: UIImage) {
        mPersonalInfoTbV.editMainDriverList?[currIndex].editImg = image
        mPersonalInfoTbV.reloadRows(at: [IndexPath(row: currIndex, section: 0)], with: .automatic)
    }
}


//MARK: -- GMSAutocompleteViewControllerDelegate
extension MyPersonalInformationViewController: GMSAutocompleteViewControllerDelegate {

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
                  self.mPersonalInfoTbV.editMainDriverList?[9].fieldValue = cityname
                  self.mPersonalInfoTbV.reloadData()
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
