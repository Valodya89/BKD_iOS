//
//  MyPersonalInformationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit
import GooglePlaces
import simd

class MyPersonalInformationViewController: BaseViewController {
//MARK: -- Outlets
    //Verified
    @IBOutlet weak var mVerifiedPendingLb: UILabel!
    @IBOutlet weak var mVerifiedLb: UILabel!
    @IBOutlet weak var mVerifiedImgV: UIImageView!
    @IBOutlet weak var mPersonalInfoTbV: MyPersonalInfoTableView!
    @IBOutlet weak var mEdifBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
         
    lazy var myPersonalInfoViewModel =  MyPersonalInformationViewModel()
    var isTakePhoto:Bool = false
    var currIndex = 0
    public var mainDriver: MainDriver?
    

    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationControll(navControll: navigationController, barBtn: mRightBarBtn)
        getMainDriverList()
        handlerChangePhoto()
        handlerCancel()
        handlerConfirm()
        handlerCountry()
        handlerCity()
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
        self.mPersonalInfoTbV.mainDriverList = self.myPersonalInfoViewModel.getMainDriverList(mainDriver: mainDriver)
        self.mPersonalInfoTbV.editMainDriverList = self.mPersonalInfoTbV.mainDriverList
        self.mPersonalInfoTbV.reloadData()
    }

    
    
    ///Will creat actionshit for camera and photo library
    func photoPressed() {
        self.openActionshitOfImages(viewContr: self)
//        let alert = UIAlertController(title: Constant.Texts.selecteImg, message: "", preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction (title: Constant.Texts.camera, style: .default) { [self] (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.presentPicker(sourceType: .camera)
//            }
//        }
//
//        let photoLibraryAction = UIAlertAction (title: Constant.Texts.photoLibrary, style: .default) { [self] (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                self.presentPicker(sourceType: .photoLibrary)
//            }
//        }
//        let cancelAction = UIAlertAction (title: Constant.Texts.cancel, style: .cancel)
//
//        alert.addAction(cameraAction)
//        alert.addAction(photoLibraryAction)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true)
    }
    
    
    ///Will present image Picker controller
     func presentPicker (sourceType: UIImagePickerController.SourceType) {
        isTakePhoto = true
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
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
            self.photoPressed()
        }
    }
    
    ///Handler cancel
    func handlerCancel() {
        mPersonalInfoTbV.didPressCancel = {
            self.mEdifBtn.setImage(img_edit, for: .normal)
            self.mPersonalInfoTbV.isEdit = false
            self.mPersonalInfoTbV.reloadData()
        }
    }
    
    ///Handler confirm
    func handlerConfirm() {
        mPersonalInfoTbV.didPressConfirm = {
            self.mEdifBtn.setImage(img_edit, for: .normal)
            self.mPersonalInfoTbV.isEdit = false
            self.mPersonalInfoTbV.reloadData()
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
        mPersonalInfoTbV.mainDriverList?[currIndex].editImg = image
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
                  self.mPersonalInfoTbV.mainDriverList?[9].fieldValue = cityname
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
