//
//  MyReservationsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu

class MyReservationsViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mReservCollectionV: UICollectionView!
    @IBOutlet weak var mNoReservationContentV: UIView!
    @IBOutlet weak var mNoReservationLb: UILabel!
    @IBOutlet weak var mReservationSegmentedC: UISegmentedControl!
    
    //Switch driver table
    @IBOutlet weak var mSwitchDriversTbV: SwitchDriversTableView!
    @IBOutlet weak var mSwitchDriversTbHeight: NSLayoutConstraint!
    @IBOutlet weak var mSwitchDriversBottom: NSLayoutConstraint!
    
    ///Visual effect
    @IBOutlet weak var mVissualEffectV: UIVisualEffectView!
    @IBOutlet weak var mGradientV: UIView!
    
    
    //MARK -- Variables
    lazy var myReservationViewModel: MyReservationViewModel = MyReservationViewModel()
    var menu: SideMenuNavigationController?
    var isReservationHistory: Bool = false
    var drivers:[MyDriversModel]? = MyDriversData.myDriversModel
    var myReservations: [Rent]?


    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        getRent()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if mSwitchDriversTbV.contentSize.height > 260 {
            mSwitchDriversTbHeight.constant = 260
        } else {
            mSwitchDriversTbHeight.constant = mSwitchDriversTbV.contentSize.height
        }
        
    }
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mNoReservationContentV.isHidden = ReservationWithReservedPaidData.reservationWithReservedPaidModel.count > 0
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mSwitchDriversTbV.switchDriversDelegate = self
        registerCollectionCells()
    }
    
    func registerCollectionCells() {
        self.mReservCollectionV.register(ReservationWithStartRideCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservationWithRegisterNumberCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservetionWithDistancePriceCell.nib(), forCellWithReuseIdentifier: ReservetionWithDistancePriceCell.identifier)
        self.mReservCollectionV.register(ReservetionWithPayRentalPriceCell.nib(), forCellWithReuseIdentifier: ReservetionWithPayRentalPriceCell.identifier)
        self.mReservCollectionV.register(ReservetionMakePaymentCell.nib(), forCellWithReuseIdentifier: ReservetionMakePaymentCell.identifier)
        self.mReservCollectionV.register(OnRideCollectionViewCell.nib(), forCellWithReuseIdentifier: OnRideCollectionViewCell.identifier)
        self.mReservCollectionV.register(AdditionalDriverWaithingApplovalCell.nib(), forCellWithReuseIdentifier: AdditionalDriverWaithingApplovalCell.identifier)
        
        self.mReservCollectionV.register(ReservationHistoryCell.nib(), forCellWithReuseIdentifier: ReservationHistoryCell.identifier)
    }
    
    ///Get reservations
    private func getRent() {
        myReservationViewModel.getReservations { result in
            guard let result = result else {return}
            self.myReservations = result
            self.mReservCollectionV.reloadData()
            /*
             {
                      "id": "61c0cc79f19e7772672c5d6a",
                      "state": "COMPLETED",
                      "deposit": null,
                      "rent": null,
                      "distance": null,
                      "userId": "60febc56266f574fec954af2",
                      "startDate": 1636395213876,
                      "endDate": 1636395213876,
                      "accessories": [
                          {
                              "id": "61506ec81464ab42a0e2f31e",
                              "count": 1
                          }
                      ],
                      "pickupLocation": {
                          "type": "CUSTOM",
                          "customLocation": {
                              "name": "Masivi city",
                              "longitude": 45.5,
                              "latitude": 47.8
                          },
                          "parking": null
                      },
                      "returnLocation": {
                          "type": "CUSTOM",
                          "customLocation": {
                              "name": "Masivi city",
                              "longitude": 45.5,
                              "latitude": 47.8
                          },
                          "parking": null
                      },
                      "carDetails": {
                          "id": "61815f3296b3233b4995c625",
                          "registrationNumber": null,
                          "logo": {
                              "id": "14122AFE1F760709174A3F2B166B05AB51B1D7286ECAC4678C5B2F485A99F02605F320DD234F89BAAFC16476569668ED",
                              "node": "dev-node1"
                          },
                          "model": "M3",
                          "type": null
                      },
                      "driver": {
                          "id": "60febc56266f574fec954af2",
                          "name": "Valodya",
                          "surname": "Galstyan",
                          "drivingLicenseNumber": "sdfsdfsd256s1dfsd5"
                      },
                      "currentDriver": {
                          "id": "60febc56266f574fec954af2",
                          "name": "Valodya",
                          "surname": "Galstyan",
                          "drivingLicenseNumber": "sdfsdfsd256s1dfsd5"
                      },
                      "additionalDrivers": [],
                      "startDefects": [],
                      "endDefects": [],
                      "startOdometer": null,
                      "endOdometer": null,
                      "hasAccident": true
                  }
              ],
             */
            
        }
    }
    
    ///Go to my reservation ViewController
    func goToMyReservation(myReservationState: MyReservationState,
                           paymentStatusArr: [PaymentStatusModel]?,
                           registerNumberArr:[String]?,
                           onRideArr:[OnRideModel]?) {
        
        let myReservetionAdvancedVC = MyReservetionAdvancedViewController.initFromStoryboard(name: Constant.Storyboards.myReservetionAdvanced)
        myReservetionAdvancedVC.myReservationState = myReservationState
        myReservetionAdvancedVC.paymentStatusArr = paymentStatusArr
        myReservetionAdvancedVC.registerNumberArr = registerNumberArr
        myReservetionAdvancedVC.onRideArr = onRideArr
        self.navigationController?.pushViewController(myReservetionAdvancedVC, animated: true)
    }
    
    
    ///Show switch drivers table view
    private func animateSwitchDriversTable() {                self.mSwitchDriversTbV.isScrollEnabled = false
        mVissualEffectV.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = 10
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.mSwitchDriversTbV.contentSize.height >  self.mSwitchDriversTbHeight.constant {
                self.mSwitchDriversTbV.isScrollEnabled = true
            }
        }
    }
    
    ///Hide switch drivers table view
    private func hideSwitchTable(driver: DriverToRent?){
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = -500
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        } completion: { _ in
            self.mVissualEffectV.isHidden = true
            guard let driver = driver else {return}
            self.showAlertForSwitchDriver(driver: driver)
        }
    }
    
    ///Show alert for switch driver
    private func showAlertForSwitchDriver(driver: DriverToRent?) {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.confirmSwitchDriver, ""),
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
        }
    }
        
        ///Show alert for inactive start ride
        private func showAlertForInactiveStartRide() {
            BKDAlert().showAlert(on: self, message: Constant.Texts.activeStartRide, cancelTitle: nil, okTitle: Constant.Texts.gotIt, cancelAction: nil) {
                
            }
    }
    
    
    ///Check is active start ride(Is less then 15 minute before start)
    private func isActiveStartRide(start: Double) -> Bool {
        let duration = Date().getDistanceByComponent(.minute, toDate: Date(timeIntervalSince1970: start)).minute
        return duration! <= 15
    }
    
    
    
    //MARK: -- Actions
    @IBAction func menu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func reservation(_ sender: UISegmentedControl) {
        isReservationHistory = sender.selectedSegmentIndex == 1
        mReservCollectionV.reloadData()
    }
    
    @IBAction func swipeSwitchTable(_ sender: UISwipeGestureRecognizer) {
        hideSwitchTable(driver: nil)
    }
    
}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension MyReservationsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isReservationHistory {
            return 0
        }
        return myReservations?.count ?? 0 //ReservationWithReservedPaidData.reservationWithReservedPaidModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = myReservations![indexPath.item] //ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
        let rentState = RentState.init(rawValue: item.state ?? "FINISHED")
        if isReservationHistory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationHistoryCell.identifier, for: indexPath) as!  ReservationHistoryCell
            return cell
            
        } else {
            switch rentState {
            case .COMPLETED,
                 .START_DEFECT_CHECK,
                 .START_ODOMETER_CHECK:/*.startRide:*/
                
                if isActiveStartRide(start: item.startDate) || item.carDetails.registrationNumber != nil /*item.isRegisterNumber*/ {
                  return startRideWithRegisterNumberCell(item: item, indexPath: indexPath)
                }
                return startRideCell(item: item, indexPath: indexPath)
//            case .maykePayment:
//                return maykePaymentCell(item: item, indexPath: indexPath)
            case .FINISHED:/*.payDistancePrice:*/
                return payDistancePriceCell(item: item, indexPath: indexPath)
//            case .payRentalPrice:
//                return payRentalPriceCell(item: item, indexPath: indexPath)
            case .STARTED,
                 .END_DEFECT_CHECK,
                 .END_ODOMETER_CHECK:/*.stopRide:*/
                return stopRideCell(item: item, indexPath: indexPath)
//            case .driverWaithingApproval:
//                return driverWaithingApprovalCell(indexPath: indexPath)
            default:
                return stopRideCell(item: item, indexPath: indexPath)
            }
        }
    }
    
    //MARK: UICollectionViewDelegate
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isReservationHistory {
            
            let item = myReservations![indexPath.item] //ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
            var paymentStatusModel: PaymentStatusModel?
            var registerNumberArr:[String]?
            var onRideArr:[OnRideModel]?
            let rentState = RentState.init(rawValue: item.state ?? "FINISHED")
            var myResrevationState: MyReservationState = .stopRide
            
            switch rentState {
            case .COMPLETED,
                 .START_DEFECT_CHECK,
                 .START_ODOMETER_CHECK /*.startRide*/:
                myResrevationState = .startRide
                
                if isActiveStartRide(start: item.startDate) || item.carDetails.registrationNumber != nil /*item.isRegisterNumber*/ {
                    let cell: ReservationWithRegisterNumberCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithRegisterNumberCollectionViewCell
                    paymentStatusModel = cell.getPaymentStatusModel()
                    registerNumberArr = [cell.mRegistrationNumberLb.text!]
                } else {
                    let cell: ReservationWithStartRideCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithStartRideCollectionViewCell
                    paymentStatusModel = cell.getPaymentStatusModel()
                }
//            case .payRentalPrice:
  //              myResrevationState = .payRentalPrice
//                let cell: ReservetionWithPayRentalPriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithPayRentalPriceCell
//                paymentStatusModel = cell.getPaymentStatusModel()
            case .FINISHED:/*.payDistancePrice:*/
                myResrevationState = .payDistancePrice
                let cell: ReservetionWithDistancePriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithDistancePriceCell
                paymentStatusModel = cell.getPaymentStatusModel()
//            case .maykePayment:
              //  myResrevationState = .maykePayment
//                let cell: ReservetionMakePaymentCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionMakePaymentCell
//                paymentStatusModel = cell.getPaymentStatusModel()
            case .STARTED,
                 .END_DEFECT_CHECK,
                 .END_ODOMETER_CHECK:/*.stopRide:*/
                myResrevationState = .stopRide
                let cell: OnRideCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! OnRideCollectionViewCell
               let onRideModel = cell.getOnRideModel()
                onRideArr = [onRideModel]
//            case .driverWaithingApproval:
     //           myResrevationState = .driverWaithingApproval
//                break
            default:
                break
            }
            
            var paymentArr:[PaymentStatusModel]?
            if let payment = paymentStatusModel {
                paymentArr = []
                paymentArr!.append(payment)
            }
            
            goToMyReservation(myReservationState: myResrevationState,
                              paymentStatusArr: paymentArr,
                              registerNumberArr: registerNumberArr,
                              onRideArr: onRideArr )
            
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = myReservations![indexPath.item]
        let rentState = RentState.init(rawValue: item.state ?? "FINISHED")
        
        if isReservationHistory {
            return CGSize(width: collectionView.bounds.width,
                          height: height274)
        }
        
//       let item =  ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
           
        switch rentState {
        case .COMPLETED,
             .START_DEFECT_CHECK,
             .START_ODOMETER_CHECK /*.startRide*/:
            if item.carDetails.registrationNumber != nil /*item.isRegisterNumber*/ {
                return CGSize(width: collectionView.bounds.width,
                              height: height307)
            }
            return CGSize(width: collectionView.bounds.width,
                          height: height245)
//        case .maykePayment:
//            return CGSize(width: collectionView.bounds.width,
//                          height: height240)
        case .FINISHED:/*.payDistancePrice:*/
            return CGSize(width: collectionView.bounds.width,
                          height: height285)
//        case .payRentalPrice:
//            return CGSize(width: collectionView.bounds.width,
//                          height: height285)
        case .STARTED,
             .END_DEFECT_CHECK,
             .END_ODOMETER_CHECK:/*.stopRide:*/
            return CGSize(width: collectionView.bounds.width,
                          height: height405)
//        case .driverWaithingApproval:
//            var driversCellHight = height48
//            if drivers?.count ?? 0 > 1 {
//                driversCellHight *= drivers!.count
//            }
//            return CGSize(width: collectionView.bounds.width,
//                          height: 230.0 + CGFloat(driversCellHight))
        default:
            return CGSize(width: collectionView.bounds.width,
                                 height: height405)
        }
    }
    
    ///Start ride UICollectionViewCell
    private func startRideCell(item: Rent, indexPath: IndexPath) -> ReservationWithStartRideCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier, for: indexPath) as!  ReservationWithStartRideCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.pressInactiveStartRide = {
            self.showAlertForInactiveStartRide()
        }
        return cell
    }
    
    ///Start ride UICollectionViewCell
    private func stopRideCell(item: Rent, indexPath: IndexPath) -> OnRideCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: OnRideCollectionViewCell.identifier, for: indexPath) as!  OnRideCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.pressedStopRide = {
            self.goToVehicleCheck(rent: item)
        }
        cell.pressedAddDamages = {
            self.goToAddDamage()
        }
        cell.pressedSwitchDriver = { index in
            if item.additionalDrivers?.count == 0 {
                self.showAlertForSwitchDriver(driver: nil)
            } else {
                self.animateSwitchDriversTable()
            }
           // self.showAlertForSwitchDriver()
        }
        cell.pressedSeeMap = { index in
            self.goToSeeMap(parking: item.returnLocation.parking, customLocation: item.returnLocation.customLocation)
        }
        return cell
    }
    
    ///Start Ride with registretion number UICollectionViewCell
    private func startRideWithRegisterNumberCell(item: Rent, indexPath: IndexPath) -> ReservationWithRegisterNumberCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier, for: indexPath) as!  ReservationWithRegisterNumberCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.didPressStartRide = { index in
            if RentState.init(rawValue: item.state ?? "") == .START_DEFECT_CHECK || RentState.init(rawValue: item.state ?? "") == .START_ODOMETER_CHECK {
                self.goToOdometerCheck(rent: item)
            } else {
                self.goToVehicleCheck(rent: item)
            }
        }
        return cell
    }
    
    ///Mayke Payment UICollectionViewCell
    private func maykePaymentCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservetionMakePaymentCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionMakePaymentCell.identifier, for: indexPath) as!  ReservetionMakePaymentCell
        
        cell.setCellInfo(item: item, index: indexPath.item)
        cell.makePayment = {
            self.goToPayLater()
        }
        return cell
    }
    
    ///Pay Distance Price UICollectionViewCell
    private func payDistancePriceCell(item: Rent, indexPath: IndexPath) -> ReservetionWithDistancePriceCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithDistancePriceCell.identifier, for: indexPath) as!  ReservetionWithDistancePriceCell
        
        cell.setCellInfo(item: item, index: indexPath.item)
        
        cell.payDistancePrice = {
            self.goToAgreement(on: self,
                               agreementType: .editAdvanced,
                               vehicleModel: nil,
                               urlString: nil)
        }
        return cell
    }
    
    ///Pay Rental Price UICollectionViewCell
    private func payRentalPriceCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservetionWithPayRentalPriceCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithPayRentalPriceCell.identifier, for: indexPath) as!  ReservetionWithPayRentalPriceCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.payRentalPrice = {
            self.goToAgreement(on: self,
                               agreementType: .editAdvanced,
                               vehicleModel: nil,
                               urlString: nil)
        }
        return cell
    }
    
    
    ///Driver Waithing Approval  UICollectionViewCell
    private func driverWaithingApprovalCell(indexPath: IndexPath) -> AdditionalDriverWaithingApplovalCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: AdditionalDriverWaithingApplovalCell.identifier, for: indexPath) as!  AdditionalDriverWaithingApplovalCell
        cell.drivers = drivers
        cell.setCellInfo()
        return cell
    }
}

//MARK: -- SwitchDriversTableViewDelegate
//MARK: ----------------------------------
extension MyReservationsViewController: SwitchDriversTableViewDelegate {
    
    func didPressCell(item: MyDriversModel) {
       // hideSwitchTable(driver: item.fullname)
    }

        
}
