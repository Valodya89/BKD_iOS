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
    lazy var myReservationVM: MyReservationViewModel = MyReservationViewModel()
    var menu: SideMenuNavigationController?
    var isReservationHistory: Bool = false
    var drivers:[MyDriversModel]? = MyDriversData.myDriversModel
    var myReservations: [Rent]?
    var myHistoryReservations: [Rent]?

    var cellRowToTimerMapping: [Int: Timer] = [:]
    var cellRowToPauseFlagMapping: [Int: Bool] = [:]

    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        getRents()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        NotificationCenter.default.addObserver(self, selector: #selector(MyReservationsViewController.handleMenuToggle), name: Constant.Notifications.dismissMenu, object: nil)
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mNoReservationContentV.isHidden = ReservationWithReservedPaidData.reservationWithReservedPaidModel.count > 0
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mSwitchDriversTbV.switchDriversDelegate = self
        registerCollectionCells()
    }
    
    ///Register cells
    func registerCollectionCells() {
        self.mReservCollectionV.register(ReservationWithStartRideCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservationWithRegisterNumberCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservetionWithDistancePriceCell.nib(), forCellWithReuseIdentifier: ReservetionWithDistancePriceCell.identifier)
//        self.mReservCollectionV.register(ReservetionWithPayRentalPriceCell.nib(), forCellWithReuseIdentifier: ReservetionWithPayRentalPriceCell.identifier)
        self.mReservCollectionV.register(ReservetionMakePaymentCell.nib(), forCellWithReuseIdentifier: ReservetionMakePaymentCell.identifier)
        self.mReservCollectionV.register(OnRideCollectionViewCell.nib(), forCellWithReuseIdentifier: OnRideCollectionViewCell.identifier)
//        self.mReservCollectionV.register(AdditionalDriverWaithingApplovalCell.nib(), forCellWithReuseIdentifier: AdditionalDriverWaithingApplovalCell.identifier)
        self.mReservCollectionV.register(WaithingAdminApplovalCell.nib(), forCellWithReuseIdentifier: WaithingAdminApplovalCell.identifier)
        self.mReservCollectionV.register(WaitingForDistancePriceTableViewCell.nib(), forCellWithReuseIdentifier: WaitingForDistancePriceTableViewCell.identifier)
        
        self.mReservCollectionV.register(ReservationHistoryCell.nib(), forCellWithReuseIdentifier: ReservationHistoryCell.identifier)
    }
    
    ///Get reservations
    private func getRents() {
        myReservationVM.getReservations { result in
            guard let result = result else {return}
            let reservations = self.myReservationVM.filterReservations(rents: result)
            self.myReservations = reservations.rent
            self.myHistoryReservations = reservations.historys
            self.mReservCollectionV.reloadData()
        }
    }
    
    ///Switch driver
    func changeDriver(index: Int, driverId: String ) {
        let currRent = self.myReservations![index]
        myReservationVM.changeDriver(rentId: currRent.id, driverId: driverId) { result in
            guard let rent =  result else {return}
            self.hideSwitchTable()
            self.myReservations?[index] = rent
            self.mReservCollectionV.reloadItems(at: [IndexPath(item: index, section: 0)])
            
        }
    }
    
    ///Go to my reservation advanced ViewController
    func goToMyReservation(myReservationState: MyReservationState,
                           paymentOption: PaymentOption,
                           paymentStatusArr: [PaymentStatusModel]?,
                           registerNumberArr:[String]?,
                           onRideArr:[OnRideModel]?, rent: Rent) {
        
        let myReservetionAdvancedVC = MyReservetionAdvancedViewController.initFromStoryboard(name: Constant.Storyboards.myReservetionAdvanced)
        myReservetionAdvancedVC.myReservationState = myReservationState
        myReservetionAdvancedVC.paymentStatusArr = paymentStatusArr
        myReservetionAdvancedVC.registerNumberArr = registerNumberArr
        myReservetionAdvancedVC.onRideArr = onRideArr
        myReservetionAdvancedVC.currRent = rent
        myReservetionAdvancedVC.paymentOption = paymentOption
        self.navigationController?.pushViewController(myReservetionAdvancedVC, animated: true)
    }
    
    
    ///Show switch drivers table view
    private func animateSwitchDriversTable(additionalDrivers: [DriverToRent] ) {
        
        self.mSwitchDriversTbV.switchDriversList = additionalDrivers
        self.mSwitchDriversTbV.reloadData()
        self.mSwitchDriversTbV.isScrollEnabled = false
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
    private func hideSwitchTable(){
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = -500
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        } completion: { _ in
            self.mVissualEffectV.isHidden = true
        }
    }
    
    //MARK: -- Alerts
    ///Show alert for switch driver
    private func showAlertForSwitchDriver(index: Int,
                                          driver: DriverToRent?) {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.confirmSwitchDriver, driver?.getFullName() ?? ""),
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm,
                             cancelAction: nil) {
            self.changeDriver(index: index,
                              driverId: driver?.id ?? "")
        }
    }
        
        ///Show alert for inactive start ride
        private func showAlertForInactiveStartRide() {
            BKDAlert().showAlert(on: self, message: Constant.Texts.activeStartRide, cancelTitle: nil, okTitle: Constant.Texts.gotIt, cancelAction: nil) {
                
            }
    }
    
    //MARK: -- Actions
    @IBAction func menu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func reservation(_ sender: UISegmentedControl) {
        isReservationHistory = sender.selectedSegmentIndex == 1
        getRents()
    }
    
    @IBAction func swipeSwitchTable(_ sender: UISwipeGestureRecognizer) {
        hideSwitchTable()
    }
    
    ///Dismiss left menu and open chant screen
    @objc private func handleMenuToggle(notification: Notification) {
        menu?.dismiss(animated: true, completion: nil)
        openChatPage(viewCont: self)
    }
    
}


// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension MyReservationsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isReservationHistory {
            return myHistoryReservations?.count ?? 0
        }
        return myReservations?.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = myReservations![indexPath.item]
        var paymentType = myReservationVM.getReservationState(rent: item)
        let rentState = RentState.init(rawValue: item.state ?? Constant.Keys.draft)
        
        if isReservationHistory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationHistoryCell.identifier, for: indexPath) as!  ReservationHistoryCell
            guard let item = myHistoryReservations?[indexPath.item] else {return cell}
            cell.setCellInfo(item: item, index: indexPath.item)
            return cell
            
        } else {
            
            switch rentState {
            case .DRAFT:
                return waithingAdminApprovalCell(item: item, indexPath: indexPath, paymentType: paymentType)
            case .COMPLETED,
                 .START_DEFECT_CHECK,
                 .START_ODOMETER_CHECK://start ride
                
                if paymentType != .startRide { //cell with pay button
                    return maykePaymentCell(item: item,
                                            indexPath: indexPath,
                                            paymentType: paymentType)
                } else { //start ride
                    if myReservationVM.isActiveStartRide(start: item.startDate) || item.carDetails.registrationNumber != nil /*item.isRegisterNumber*/ {
                      return startRideWithRegisterNumberCell(item: item, indexPath: indexPath)
                    }
                    return startRideCell(item: item, indexPath: indexPath)
                }
                
                
//            case .maykePayment:
//                return maykePaymentCell(item: item, indexPath: indexPath)
           
//                }
//                return payDistancePriceCell(item: item, indexPath: indexPath, paymentType: paymentType)
//            case .payRentalPrice:
//                return payRentalPriceCell(item: item, indexPath: indexPath)
            case .STARTED,
                 .END_DEFECT_CHECK,
                 .END_ODOMETER_CHECK:/*.stopRide:*/
                return stopRideCell(item: item, indexPath: indexPath)
                
            case .FINISHED://waiting for distance price calculation
                
                paymentType = .payDistancePrice
                return  waitingForDistancePriceCell(item: item, indexPath: indexPath, paymentType: paymentType)
                
            case .ADMIN_FINISHED://waithing for distance price
                return  payDistancePriceCell(item: item, indexPath: indexPath, paymentType: paymentType)
              
//            case .driverWaithingApproval:
//                return driverWaithingApprovalCell(indexPath: indexPath)
            default://Draft
                return waithingAdminApprovalCell(item: item, indexPath: indexPath, paymentType: paymentType)
            }
        }
    }
    
    //MARK: -- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = !isReservationHistory ? myReservations![indexPath.item] : myHistoryReservations![indexPath.item]

        
       // if !isReservationHistory {
            
           // let item = myReservations![indexPath.item]
            let paymentType = myReservationVM.getReservationState(rent: item)

            var paymentStatusModel: PaymentStatusModel?
            var registerNumberArr:[String]?
            var onRideArr:[OnRideModel]?
            let rentState = RentState.init(rawValue: item.state ?? "FINISHED")
            var myResrevationState: MyReservationState = .stopRide
            
            switch rentState {
            case .DRAFT:
                myResrevationState = .waithingApproval
                let cell: WaithingAdminApplovalCell = mReservCollectionV.cellForItem(at: indexPath) as! WaithingAdminApplovalCell
                paymentStatusModel = cell.getPaymentStatusModel()
                
            case .COMPLETED,
                 .START_DEFECT_CHECK,
                 .START_ODOMETER_CHECK /*.startRide*/:
                
                
                if paymentType != .startRide { //cell with pay button
                    myResrevationState = myReservationVM.getReservationState(rent: item)
                      let cell: ReservetionMakePaymentCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionMakePaymentCell
                      paymentStatusModel = cell.getPaymentStatusModel()
                } else {
                    myResrevationState = .startRide
                    if myReservationVM.isActiveStartRide(start: item.startDate) || item.carDetails.registrationNumber != nil {
                        let cell: ReservationWithRegisterNumberCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithRegisterNumberCollectionViewCell
                        paymentStatusModel = cell.getPaymentStatusModel()
                        registerNumberArr = [cell.mRegistrationNumberLb.text!]
                    } else {
                        let cell: ReservationWithStartRideCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithStartRideCollectionViewCell
                        paymentStatusModel = cell.getPaymentStatusModel()
                    }
                }
                
//            case .payRentalPrice:
  //              myResrevationState = .payRentalPrice
//                let cell: ReservetionWithPayRentalPriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithPayRentalPriceCell
//                paymentStatusModel = cell.getPaymentStatusModel()
           
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
                
            case .FINISHED:// waiting for admin approval distance price
                
                    myResrevationState = .waithingApproval
                    let cell: WaitingForDistancePriceTableViewCell = mReservCollectionV.cellForItem(at: indexPath) as! WaitingForDistancePriceTableViewCell
                    paymentStatusModel = cell.getPaymentStatusModel()
                
            case .ADMIN_FINISHED:// waiting for distance price
                myResrevationState = .payDistancePrice
                let cell: ReservetionWithDistancePriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithDistancePriceCell
                paymentStatusModel = cell.getPaymentStatusModel()
                
            case .CLOSED:
                myResrevationState = .closed
                let cell: ReservationHistoryCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationHistoryCell
                paymentStatusModel = cell.getPaymentStatusModel()
               
//            case .driverWaithingApproval:
     //           myResrevationState = .driverWaithingApproval
//                break
            default://Draft
                //myResrevationState = .driverWaithingApproval
                break
            }
            
            var paymentArr:[PaymentStatusModel]?
            if let payment = paymentStatusModel {
                paymentArr = []
                paymentArr!.append(payment)
            }
            let paymentOption = myReservationVM.getPaymentOption(reservationState: myResrevationState)
            goToMyReservation(myReservationState: myResrevationState,
                              paymentOption: paymentOption,
                              paymentStatusArr: paymentArr,
                              registerNumberArr: registerNumberArr,
                              onRideArr: onRideArr, rent: item )
            
      //  }
    }
    
    //MARK: --UICollectionViewDelegateFlowLayout
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
      
//        case .payRentalPrice:
//            return CGSize(width: collectionView.bounds.width,
//                          height: height285)
        case .STARTED,
             .END_DEFECT_CHECK,
             .END_ODOMETER_CHECK:/*.stopRide:*/
            return CGSize(width: collectionView.bounds.width,
                          height: height405)
        case .FINISHED:// waithinf bkd calculation
            return CGSize(width: collectionView.bounds.width,
                          height: height285)
     
//        case .driverWaithingApproval:
//            var driversCellHight = height48
//            if drivers?.count ?? 0 > 1 {
//                driversCellHight *= drivers!.count
//            }
//            return CGSize(width: collectionView.bounds.width,
//                          height: 230.0 + CGFloat(driversCellHight))
        default: //Draft
            return CGSize(width: collectionView.bounds.width,
                                 height: height245)
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
    private func maykePaymentCell(item: Rent,
                                  indexPath: IndexPath,
                                  paymentType: MyReservationState) -> ReservetionMakePaymentCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionMakePaymentCell.identifier, for: indexPath) as!  ReservetionMakePaymentCell
        
        cell.setCellInfo(item: item, index: indexPath.item, reservatiopnState:  paymentType)
        cell.makePayment = {
            if paymentType == .payRentalPrice {
                self.goToAgreement(on: self,
                                   agreementType: .myReservationCell, paymentOption: .rental,
                                   vehicleModel: nil,
                                   rent: item,
                                   urlString: nil)
            } else {
                self.goToPayLater(rent: item)
//                self.goToAgreement(on: self,
//                                   agreementType: .payLater, paymentOption: .depositRental,
//                                   vehicleModel: nil,
//                                   rent: item,
//                                   urlString: nil)
            }
        }
        return cell
    }
    
    ///Pay Distance Price UICollectionViewCell
    private func payDistancePriceCell(item: Rent, indexPath: IndexPath, paymentType: MyReservationState) -> ReservetionWithDistancePriceCell {

        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithDistancePriceCell.identifier, for: indexPath) as!  ReservetionWithDistancePriceCell

        cell.setCellInfo(item: item, index: indexPath.item)

        cell.payDistancePrice = {
            self.goToAgreement(on: self,
                               agreementType: .myReservationCell, paymentOption: .distance,
                               vehicleModel: nil,
                               rent: item,
                               urlString: nil)
        }
        return cell
    }
    
 
//    ///Pay Rental Price UICollectionViewCell
//    private func payRentalPriceCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservetionWithPayRentalPriceCell {
//
//        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithPayRentalPriceCell.identifier, for: indexPath) as!  ReservetionWithPayRentalPriceCell
//
//        cell.setInfoCell(item: item, index: indexPath.item)
//        cell.payRentalPrice = {
//            self.goToAgreement(on: self,
//                               agreementType: .editAdvanced,
//                               vehicleModel: nil,
//                               rent: item,
//                               urlString: nil)
//        }
//        return cell
//    }
    
    
    ///Driver Waithing Approval  UICollectionViewCell
    private func driverWaithingApprovalCell(indexPath: IndexPath) -> AdditionalDriverWaithingApplovalCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: AdditionalDriverWaithingApplovalCell.identifier, for: indexPath) as!  AdditionalDriverWaithingApplovalCell
        cell.drivers = drivers
        cell.setCellInfo()
        return cell
    }
    
    ///Waithing admin Approval  UICollectionViewCell (Draft)
    private func waithingAdminApprovalCell(item: Rent, indexPath: IndexPath,  paymentType: MyReservationState) -> WaithingAdminApplovalCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: WaithingAdminApplovalCell.identifier, for: indexPath) as!  WaithingAdminApplovalCell
        cell.drivers = drivers
        cell.setCellInfo(item: item, reservatiopnState: paymentType)
        return cell
    }
    
    ///Waiting for BKD distance price calculation
    private func waitingForDistancePriceCell(item: Rent, indexPath: IndexPath,  paymentType: MyReservationState) -> WaitingForDistancePriceTableViewCell {
        
//        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: WaitingForDistancePriceTableViewCell.identifier, for: indexPath) as?  WaitingForDistancePriceTableViewCell
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: WaitingForDistancePriceTableViewCell.identifier, for: indexPath) as! WaitingForDistancePriceTableViewCell
        
        cell.setCellInfo(item: item, reservatiopnState: paymentType)
        return cell
    }
    
    
    ///Start ride UICollectionViewCell
    private func stopRideCell(item: Rent, indexPath: IndexPath) -> OnRideCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: OnRideCollectionViewCell.identifier, for: indexPath) as!  OnRideCollectionViewCell
        
        let stopRideTime = myReservationVM.getStopRideTime(endDate: item.endDate)
        
        cell.setInfoCell(item: item, index: indexPath.item, stopRideTime: stopRideTime)
        if stopRideTime.day != nil {
            setupTimer(for: cell, indexPath: indexPath, stopRideTime: stopRideTime)
        }

        ///Handler stop ride button
        cell.pressedStopRide = { index in
            let currItem = self.myReservations![index]
            if RentState.init(rawValue: currItem.state ?? "") == .END_DEFECT_CHECK || RentState.init(rawValue: currItem.state ?? "") == .END_ODOMETER_CHECK {
                self.goToStopRideOdometereCheck(rent: currItem)
            } else if RentState.init(rawValue: currItem.state ?? "") == .STARTED {
                self.goToStopRide(rent: currItem)
            }
        }
        //Handler add damage button
        cell.pressedAddDamages = { index in
            self.goToAddDamage(rent: self.myReservations![index])
        }
        //Handler switch driver button
        cell.pressedSwitchDriver = { index in
            
            let additionalDrivers = self.myReservationVM.getAdditionalDrives(rent: self.myReservations![index])
            self.mSwitchDriversTbV.index = index
            if additionalDrivers.count == 1 {
                self.showAlertForSwitchDriver(index: index,
                                              driver: additionalDrivers[0])
            } else {
                self.animateSwitchDriversTable(additionalDrivers: additionalDrivers)
            }
        }
        //Handler map button
        cell.pressedSeeMap = { index in
            self.goToSeeMap(parking: item.returnLocation.parking, customLocation: item.returnLocation.customLocation)
        }
        return cell
    }
    
    ///Set up timer for stop ride
    private func setupTimer(for cell: OnRideCollectionViewCell, indexPath: IndexPath, stopRideTime: (day: Int?, hour: Int, minute: Int)) {
        let row = indexPath.row
        if cellRowToTimerMapping[row] == nil {
            var numberOfMinutssPassed = stopRideTime.minute
            let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { capturedTimer in
                
                if self.cellRowToPauseFlagMapping[row] != nil && self.cellRowToPauseFlagMapping[row] == true {
                    return
                }
                
                numberOfMinutssPassed -= 1
                
                let visibleCell = self.mReservCollectionV.cellForItem(at: indexPath) as? OnRideCollectionViewCell
                
                if let visibleCell = visibleCell,  numberOfMinutssPassed >= 0{
                    let minutes = String(numberOfMinutssPassed)
                    visibleCell.mMinuteLb.text = ((minutes.count == 1) ? ("0" + minutes) : minutes) + " \(Constant.Texts.m)"
                }
                
                if numberOfMinutssPassed == 0 {
                    self.mReservCollectionV.reloadItems(at: [indexPath])
                    numberOfMinutssPassed = 60
                    self.cellRowToPauseFlagMapping[row] = true
                    
                    self.makeNetworkCall {
                        self.cellRowToPauseFlagMapping[row] = false
                    }
                }
            }
            cellRowToTimerMapping[row] = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    
    private func makeNetworkCall(completion: @escaping () -> Void) {
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
}

//MARK: -- SwitchDriversTableViewDelegate
extension MyReservationsViewController: SwitchDriversTableViewDelegate {
    
    func didPressCell(index: Int, item: DriverToRent) {
        showAlertForSwitchDriver(index: index,
                                 driver: item)
    }
}
