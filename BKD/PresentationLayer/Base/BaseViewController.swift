//
//  BaseViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class BaseViewController: UIViewController, StoryboardInitializable {
    

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
    
   
    //Go to registeration bot screen
    func goToRegistrationBot(isDriverRegister:Bool, tableData: [RegistrationBotModel]) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = tableData
        registrationBotVC.isDriverRegister = isDriverRegister
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
    
    ///Open agree Screen
    func goToAgreement(on viewController: UIViewController, isAdvanced:Bool, isEditAdvanced: Bool) {
        
        let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
        bkdAgreementVC.delegate = viewController as? BkdAgreementViewControllerDelegate
        bkdAgreementVC.isAdvanced = isAdvanced
        bkdAgreementVC.isEditAdvanced = isEditAdvanced

        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
    }
    
    ///Open SeeMap Screen
    func goToSeeMap(parking: Parking?) {
        let seeMapContr = UIStoryboard(name: Constant.Storyboards.seeMap, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.seeMap) as! SeeMapViewController
        seeMapContr.parking = parking
        self.navigationController?.pushViewController(seeMapContr, animated: true)
    }
    
    
    ///Open custom location map screen
    func goToCustomLocationMapController (on viewController: UIViewController, isAddDamageAddress: Bool) {
        let customLocationContr = UIStoryboard(name: Constant.Storyboards.customLocation, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.customLocation) as! CustomLocationViewController
        customLocationContr.delegate = viewController as? CustomLocationViewControllerDelegate
        customLocationContr.isAddDamageAddress = isAddDamageAddress
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    
    ///Go to PayLater ViewController
    func goToPayLater() {
        let payLaterVC = PayLaterViewController.initFromStoryboard(name: Constant.Storyboards.payLater)
        self.navigationController?.pushViewController(payLaterVC, animated: true)
    }
    
    ///Go to Add damage ViewController
    func goToAddDamage() {
        let addDamageVC = AddDamageViewController.initFromStoryboard(name: Constant.Storyboards.addDamage)
        self.navigationController?.pushViewController(addDamageVC, animated: true)
    }
    
    
    ///Go to VehicleCheck ViewController
    func goToVehicleCheck() {
        let vehicleCheckVC = VehicleCheckViewController.initFromStoryboard(name: Constant.Storyboards.vehicleCheck)
        self.navigationController?.pushViewController(vehicleCheckVC, animated: true)
    }
    
    
    //Open SelectPayment screen
     func goToSelectPayment() {
        let selectPaymentVC = SelectPaymentViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
    }
    
    /// Go to Sign in screen
    func goToSignInPage() {
          let signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
        self.navigationController?.pushViewController(signInVC, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// Go to Sign in screen
    func goToEditReservationAdvanced() {
          let editReservetionAdvancedVC = EditReservetionAdvancedViewController.initFromStoryboard(name: Constant.Storyboards.editReservetionAdvanced)
        self.navigationController?.pushViewController(editReservetionAdvancedVC, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    ///Go to additional driver screen
    func goToAdditionalDriver(on viewController: UIViewController?,  isEditReservation: Bool) {
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
        myDriverVC.isEditReservation = isEditReservation
        myDriverVC.delegate = viewController as? MyDriversViewControllerDelegate
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    ///Go to accessories  screen
    func goToAccessories(on viewController: UIViewController?, vehicleModel:VehicleModel?, isEditReservation: Bool) {
        
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        accessoriesVC.vehicleModel = vehicleModel
        accessoriesVC.isEditReservation = isEditReservation
        accessoriesVC.delegate = viewController as? AccessoriesUIViewControllerDelegate
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    
    
    /// Go to more screen
    func goToMore(vehicleModel: VehicleModel?, carModel: CarsModel?) {
        let moreVC = MoreViewController.initFromStoryboard(name: Constant.Storyboards.more)
        moreVC.vehicleModel = vehicleModel
        moreVC.carModel = carModel
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    
}
