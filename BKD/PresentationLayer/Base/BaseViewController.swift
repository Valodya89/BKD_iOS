//
//  BaseViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu
import GooglePlaces



class BaseViewController: UIViewController, StoryboardInitializable {
    
    lazy var placesClient: GMSPlacesClient = GMSPlacesClient.shared()


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setmenu(menu: SideMenuNavigationController?) {
        menu?.leftSide = true
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        SideMenuManager.default.leftMenuNavigationController = menu
        menu?.setNavigationBarHidden(true, animated: true)
        menu?.menuWidth = 310
        menu?.presentDuration = 0.8
    }
    
    ///Configure navigtion bar
    func configureNavigationControll(navControll: UINavigationController?, barBtn: UIBarButtonItem) {
        
        navControll?.setNavigationBarBackground(color: color_dark_register!)
        navControll?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        barBtn.image = img_bkd
    }
    
    ///show Autocomplete ViewController
    func showAutocompleteViewController(viewController: UIViewController) {
          
          let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = viewController as? GMSAutocompleteViewControllerDelegate
          autocompleteController.tableCellBackgroundColor = color_background!
          autocompleteController.secondaryTextColor = color_alert_txt!
          autocompleteController.primaryTextColor = color_navigationBar!

          // Specify the place data types to return.
          let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                      UInt(GMSPlaceField.placeID.rawValue))
          autocompleteController.placeFields = fields

          // Specify a filter.
          let filter = GMSAutocompleteFilter()
          
          //search by country
//            filter.type = .establishment
//            filter.countries = ["AM"]
         // filter.type = .address
          autocompleteController.autocompleteFilter = filter
          // Display the autocomplete view controller.
          present(autocompleteController, animated: true, completion: nil)
     }
    
    
    ///Resolve Location
    func resolveLocation(place: GMSPlace, completion: @escaping (Result<CLLocationCoordinate2D, Error> ) -> Void) {
        
        placesClient.fetchPlace(fromPlaceID: place.placeID ?? "",
                                placeFields: .coordinate,
                                sessionToken: nil) { (googlePlace, error) in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCordinates))
                return
            }
            let coordinate = CLLocationCoordinate2DMake(googlePlace.coordinate.latitude,
                                                        googlePlace.coordinate.longitude)
            completion(.success(coordinate))
        }
    }
    
    ///Open search phoneCode screen
    func goToSearchPhoneCode(viewCont: UIViewController) {
        let searchPhoneCodeVC = SearchPhoneCodeViewController.initFromStoryboard(name: Constant.Storyboards.searchPhoneCode)
        searchPhoneCodeVC.delegate = viewCont as! SearchPhoneCodeViewControllerDelegate
        viewCont.present(searchPhoneCodeVC, animated: true, completion: nil)
    }
    
    ///Go to email address comtroller
    func goToEmailAddress() {
        let emailAddressVC = EmailAddressViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(emailAddressVC, animated: true)
    }
    
    
    //Go to registeration bot screen
    func goToRegistrationBot(isDriverRegister:Bool,
                             tableData: [RegistrationBotModel]) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = tableData
        registrationBotVC.isDriverRegister = isDriverRegister
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
    
    ///Open agree Screen
    func goToAgreement(on viewController: UIViewController,
                       agreementType: AgreementType,
                       paymentOption:PaymentOption?,
                       vehicleModel: VehicleModel?,
                       rent: Rent?,
                       urlString: String?) {
        
        let bkdAgreementVC = BkdAgreementViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        bkdAgreementVC.delegate = viewController as? BkdAgreementViewControllerDelegate
        bkdAgreementVC.agreementType = agreementType
        bkdAgreementVC.urlString = urlString
        bkdAgreementVC.vehicleModel = vehicleModel
        bkdAgreementVC.currRent = rent
        bkdAgreementVC.paymentOption = paymentOption
        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
    }
    
    ///Open Reservation completed screen
    func goToReservationCompleted(vehicleModel: VehicleModel?) {
        
        let reservationCompletedVC = ReservationCompletedViewController.initFromStoryboard(name: Constant.Storyboards.reservationCompleted)
        reservationCompletedVC.vehicleModel = vehicleModel
        self.navigationController?.pushViewController(reservationCompletedVC, animated: true)
    }
    
    ///Open SeeMap Screen
    func goToSeeMap(parking: Parking?, customLocation: CustomLocationToRent?) {
        
        let seeMapContr = SeeMapViewController.initFromStoryboard(name: Constant.Storyboards.seeMap)
        seeMapContr.parking = parking
        seeMapContr.customLocationToRent = customLocation
        self.navigationController?.pushViewController(seeMapContr, animated: true)
    }
    
    
    ///Open custom location map screen
    func goToCustomLocationMapController (on viewController: UIViewController, isAddDamageAddress: Bool) {
        
        let customLocationContr = CustomLocationViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
        customLocationContr.delegate = viewController as? CustomLocationViewControllerDelegate
        customLocationContr.isAddDamageAddress = isAddDamageAddress
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    
    ///Go to PayLater ViewController
    func goToPayLater(rent: Rent?) {
        let payLaterVC = PayLaterViewController.initFromStoryboard(name: Constant.Storyboards.payLater)
        payLaterVC.currRent = rent
        self.navigationController?.pushViewController(payLaterVC, animated: true)
    }
    
    ///Go to Add damage ViewController
    func goToAddDamage(rent: Rent?) {
        let addDamageVC = AddDamageViewController.initFromStoryboard(name: Constant.Storyboards.addDamage)
        addDamageVC.currRentModel = rent
        self.navigationController?.pushViewController(addDamageVC, animated: true)
    }
    
    
    ///Go to VehicleCheck ViewController
    func goToVehicleCheck(rent: Rent?) {
        let vehicleCheckVC = VehicleCheckViewController.initFromStoryboard(name: Constant.Storyboards.vehicleCheck)
        vehicleCheckVC.currRent = rent
        self.navigationController?.pushViewController(vehicleCheckVC, animated: true)
    }
    
    ///Go to Stop ride ViewController
    func goToStopRide(rent: Rent?) {
        let stopRideVC = StopRideViewController.initFromStoryboard(name: Constant.Storyboards.stopRide)
        stopRideVC.currRentModel = rent
        self.navigationController?.pushViewController(stopRideVC, animated: true)
    }
    
    ///Go to Stop ride odometer check ViewController
    func goToStopRideOdometereCheck(rent: Rent?) {
        let stopRideOdometerVC = OdometerCheckStopRideUIViewController.initFromStoryboard(name: Constant.Storyboards.odometerCheckStopRide)
        stopRideOdometerVC.currRentModel = rent
        self.navigationController?.pushViewController(stopRideOdometerVC, animated: true)
    }
    
    //Open SelectPayment screen
    func goToSelectPayment(vehicleModel: VehicleModel?,
                           paymentOption: PaymentOption) {
        
        let selectPaymentVC = SelectPaymentViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        selectPaymentVC.vehicleModel = vehicleModel
        selectPaymentVC.paymentOption = paymentOption
        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
    }
    
    /// Go to Sign in screen
    func goToSignInPage() {
          let signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(signInVC, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// Go to Sign in screen
    func goToEditReservationAdvanced(rent: Rent?,
                                     accessories: [AccessoriesEditModel]?,
                                     searchModel: SearchModel,
                                     editReservationModel: EditReservationModel?) {
        let editReservetionAdvancedVC = EditReservetionAdvancedViewController.initFromStoryboard(name: Constant.Storyboards.editReservetionAdvanced)
        editReservetionAdvancedVC.currRent = rent
        editReservetionAdvancedVC.accessories = accessories
        editReservetionAdvancedVC.searchModel = searchModel
        editReservetionAdvancedVC.editReservationModel = editReservationModel ?? EditReservationModel()
        self.navigationController?.pushViewController(editReservetionAdvancedVC, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    ///Go to additional driver screen
    func goToAdditionalDriver(on viewController: UIViewController?,
                              additionalDrivers: [MyDriversModel]?) {
        
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
        myDriverVC.delegate = viewController as? MyDriversViewControllerDelegate
        myDriverVC.additionalDrivers = additionalDrivers
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    ///Go to accessories  screen
    func goToAccessories(on viewController: UIViewController?,
                         vehicleModel:VehicleModel?,
                         rent: Rent?,
                         isEditReservation: Bool,
                         accessoriesEditList: [AccessoriesEditModel]?) {
        
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        accessoriesVC.delegate = viewController as? AccessoriesUIViewControllerDelegate
        accessoriesVC.vehicleModel = vehicleModel
        accessoriesVC.currRent = rent
        accessoriesVC.isEditReservation = isEditReservation
        accessoriesVC.accessoriesEditList = accessoriesEditList
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    
    
    /// Go to more screen
    func goToMore(vehicleModel: VehicleModel?, carModel: CarsModel?) {
        let moreVC = MoreViewController.initFromStoryboard(name: Constant.Storyboards.more)
        moreVC.vehicleModel = vehicleModel
        moreVC.carModel = carModel
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    
    ///Go to verification screen
    func goToPhoneVerification(vehicleModel: VehicleModel?, phoneNumber: String?) {
        let changePhoneNumberVC = ChangePhoneNumberViewController.initFromStoryboard(name: Constant.Storyboards.changePhoneNumber)
        changePhoneNumberVC.vehicleModel = vehicleModel
        changePhoneNumberVC.newPhoneNumber = phoneNumber
      self.navigationController?.pushViewController(changePhoneNumberVC, animated: true)
    }
    
    ///Open OdometerCheck controller
    func goToOdometerCheck(rent: Rent?) {
        let odometerCheckVC = OdometerCheckViewController.initFromStoryboard(name: Constant.Storyboards.odometerCheck)
        odometerCheckVC.currRent = rent
        self.navigationController?.pushViewController(odometerCheckVC, animated: true)
    }
    
    ///Open my personal information controller
    func goToMyPersonalInfo(mainDriver: MainDriver?, navigationTitle: String) {
        let personalInfoVC = MyPersonalInformationViewController.initFromStoryboard(name: Constant.Storyboards.myPersonalInfo)
        personalInfoVC.mainDriver = mainDriver
        personalInfoVC.navigationTitle = navigationTitle
        self.navigationController?.pushViewController(personalInfoVC, animated: true)
    }
    
    ///Open my accounts driversriver information controller
    func goToMyAccountDrivers() {
        let myAccountDriversVC = MyAccountsDriversViewController.initFromStoryboard(name: Constant.Storyboards.myAccountsDrivers)
        self.navigationController?.pushViewController(myAccountDriversVC, animated: true)
    }
    
    ///Open my accounts  controller
    func goToMyAccount() {
        let myAccountVC = MyAccountViewController.initFromStoryboard(name: Constant.Storyboards.myAccount)
        self.navigationController?.pushViewController(myAccountVC, animated: true)
    }
    ///Show alert for sign in account
    func showAlertSignIn() {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.signInToContinue,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.signIn,
                             cancelAction: nil) {
            self.goToSignInPage()
        }
    }
    
    
    ///Open upload images actionshit
    func openActionshitOfImages(viewContr: MyPersonalInformationViewController) {
        let alert = UIAlertController(title: Constant.Texts.selecteImg, message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction (title: Constant.Texts.camera, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                viewContr.presentPicker(sourceType: .camera)
            }
        }
        
        let photoLibraryAction = UIAlertAction (title: Constant.Texts.photoLibrary, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                viewContr.presentPicker(sourceType: .photoLibrary)
            }
        }
        let cancelAction = UIAlertAction (title: Constant.Texts.cancel, style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        viewContr.present(alert, animated: true)
    }
    
    
    /// Will open Chat View Controller
     func openChatPage (viewCont: UIViewController) {
        if MainViewModel().isOnline {
            let onlineChat = OnlineChatViewController.initFromStoryboard(name: Constant.Storyboards.chat)
            viewCont.navigationController?.pushViewController(onlineChat, animated: true)
        } else {
            let offlineChat = OfflineViewController.initFromStoryboard(name: Constant.Storyboards.chat)
            viewCont.navigationController?.pushViewController(offlineChat, animated: true)
        }
    }
}
