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
    var menu: SideMenuNavigationController?
    var isReservationHistory: Bool = false
    var drivers:[MyDriversModel]? = MyDriversData.myDriversModel


    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
   
    
    ///Open agree Screen
    private func goToAgreement() {
        
        let bkdAgreementVC = UIStoryboard(name: Constant.Storyboards.registrationBot, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.bkdAgreement) as! BkdAgreementViewController
        bkdAgreementVC.isMyReservationCell = true
        self.navigationController?.pushViewController(bkdAgreementVC, animated: true)
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
    private func hideSwitchTable(driverName: String?){
        UIView.animate(withDuration: 0.5) {
            self.mSwitchDriversBottom.constant = -500
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        } completion: { _ in
            self.mVissualEffectV.isHidden = true
            guard let driverName = driverName else {return}
            self.showAlertForSwitchDriver(driverName: driverName)
        }
    }
    
    ///Show alert for switch driver
    private func showAlertForSwitchDriver(driverName: String) {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.confirmSwitchDriver, driverName),
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
    
    
    
    
    
    //MARK: -- Actions
    @IBAction func menu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func reservation(_ sender: UISegmentedControl) {
        isReservationHistory = sender.selectedSegmentIndex == 1
        mReservCollectionV.reloadData()
    }
    
    @IBAction func swipeSwitchTable(_ sender: UISwipeGestureRecognizer) {
        hideSwitchTable(driverName: nil)
    }
    
}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension MyReservationsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReservationWithReservedPaidData.reservationWithReservedPaidModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
        
        if isReservationHistory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationHistoryCell.identifier, for: indexPath) as!  ReservationHistoryCell
            return cell
            
        } else {
            switch item.myReservationState {
            case .startRide:
                if item.isRegisterNumber {
                  return startRideWithRegisterNumberCell(item: item, indexPath: indexPath)
                }
                return startRideCell(item: item, indexPath: indexPath)
            case .maykePayment:
                return maykePaymentCell(item: item, indexPath: indexPath)
            case .payDistancePrice:
                return payDistancePriceCell(item: item, indexPath: indexPath)
            case .payRentalPrice:
                return payRentalPriceCell(item: item, indexPath: indexPath)
            case .stopRide:
                return stopRideCell(item: item, indexPath: indexPath)
            case .driverWaithingApproval:
                return driverWaithingApprovalCell(indexPath: indexPath)
            }
        }
    }
    
    //MARK: UICollectionViewDelegate
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isReservationHistory {
            
            let item = ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
            var paymentStatusModel: PaymentStatusModel?
            var registerNumberArr:[String]?
            var onRideArr:[OnRideModel]?
            
            switch item.myReservationState {
            case .startRide:
                if item.isRegisterNumber {
                    let cell: ReservationWithRegisterNumberCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithRegisterNumberCollectionViewCell
                    paymentStatusModel = cell.getPaymentStatusModel()
                    registerNumberArr = [cell.mRegistrationNumberLb.text!]
                } else {
                    let cell: ReservationWithStartRideCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservationWithStartRideCollectionViewCell
                    paymentStatusModel = cell.getPaymentStatusModel()
                }
            case .payRentalPrice:
                let cell: ReservetionWithPayRentalPriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithPayRentalPriceCell
                paymentStatusModel = cell.getPaymentStatusModel()
            case .payDistancePrice:
                let cell: ReservetionWithDistancePriceCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionWithDistancePriceCell
                paymentStatusModel = cell.getPaymentStatusModel()
            case .maykePayment:
                let cell: ReservetionMakePaymentCell = mReservCollectionV.cellForItem(at: indexPath) as! ReservetionMakePaymentCell
                paymentStatusModel = cell.getPaymentStatusModel()
            case .stopRide:
                let cell: OnRideCollectionViewCell = mReservCollectionV.cellForItem(at: indexPath) as! OnRideCollectionViewCell
               let onRideModel = cell.getOnRideModel()
                onRideArr = [onRideModel]
            case .driverWaithingApproval:
                break
            }
            
            var paymentArr:[PaymentStatusModel]?
            if let payment = paymentStatusModel {
                paymentArr = []
                paymentArr!.append(payment)
            }
            
            goToMyReservation(myReservationState: item.myReservationState,
                              paymentStatusArr: paymentArr,
                              registerNumberArr: registerNumberArr,
                              onRideArr: onRideArr )
            
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isReservationHistory {
            return CGSize(width: collectionView.bounds.width,
                          height: height274)
        }
        
       let item =  ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item]
           
        switch item.myReservationState {
        case .startRide:
            if item.isRegisterNumber {
                return CGSize(width: collectionView.bounds.width,
                              height: height307)
            }
            return CGSize(width: collectionView.bounds.width,
                          height: height245)
        case .maykePayment:
            return CGSize(width: collectionView.bounds.width,
                          height: height240)
        case .payDistancePrice:
            return CGSize(width: collectionView.bounds.width,
                          height: height285)
        case .payRentalPrice:
            return CGSize(width: collectionView.bounds.width,
                          height: height285)
        case .stopRide:
            return CGSize(width: collectionView.bounds.width,
                          height: height405)
        case .driverWaithingApproval:
            var driversCellHight = height48
            if drivers?.count ?? 0 > 1 {
                driversCellHight *= drivers!.count
            }
            return CGSize(width: collectionView.bounds.width,
                          height: 230.0 + CGFloat(driversCellHight))
        }
    }
    
    ///Start ride UICollectionViewCell
    private func startRideCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservationWithStartRideCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier, for: indexPath) as!  ReservationWithStartRideCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.pressInactiveStartRide = {
            self.showAlertForInactiveStartRide()
        }
        return cell
    }
    
    ///Start ride UICollectionViewCell
    private func stopRideCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> OnRideCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: OnRideCollectionViewCell.identifier, for: indexPath) as!  OnRideCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.pressedStopRide = {
            self.goToVehicleCheck()
        }
        cell.pressedAddDamages = {
            self.goToAddDamage()
        }
        cell.pressedSwitchDriver = {
            self.animateSwitchDriversTable()
           // self.showAlertForSwitchDriver()
        }
        cell.pressedSeeMap = {
            self.goToSeeMap(parking: testParking)
        }
        return cell
    }
    
    ///Start Ride with registretion number UICollectionViewCell
    private func startRideWithRegisterNumberCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservationWithRegisterNumberCollectionViewCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier, for: indexPath) as!  ReservationWithRegisterNumberCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.didPressStartRide = {
            self.goToVehicleCheck()
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
    private func payDistancePriceCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservetionWithDistancePriceCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithDistancePriceCell.identifier, for: indexPath) as!  ReservetionWithDistancePriceCell
        
        cell.setCellInfo(item: item, index: indexPath.item)
        
        cell.payDistancePrice = {
            self.goToAgreement()
        }
        return cell
    }
    
    ///Pay Rental Price UICollectionViewCell
    private func payRentalPriceCell(item: ReservationWithReservedPaidModel, indexPath: IndexPath) -> ReservetionWithPayRentalPriceCell {
        
        let cell = mReservCollectionV.dequeueReusableCell(withReuseIdentifier: ReservetionWithPayRentalPriceCell.identifier, for: indexPath) as!  ReservetionWithPayRentalPriceCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.payRentalPrice = {
            self.goToAgreement()
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
        hideSwitchTable(driverName: item.fullname)
    }

        
}
