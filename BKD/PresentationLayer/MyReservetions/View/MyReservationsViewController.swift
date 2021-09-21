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
    @IBOutlet weak var mVisualEffectV: UIVisualEffectView!
    @IBOutlet weak var mGradientV: UIView!
    
    //MARK -- Variables
    var menu: SideMenuNavigationController?
    var isReservationHistory: Bool = false

    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mNoReservationContentV.isHidden = ReservationWithReservedPaidData.reservationWithReservedPaidModel.count > 0
        
        registerCollectionCells()
    }
    
    func registerCollectionCells() {
        self.mReservCollectionV.register(ReservationWithStartRideCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservationWithRegisterNumberCollectionViewCell.nib(), forCellWithReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier)
        self.mReservCollectionV.register(ReservationHistoryCell.nib(), forCellWithReuseIdentifier: ReservationHistoryCell.identifier)
    }
    
    ///Go to PayLater ViewController
    func goToPayLater() {
        let payLaterVC = PayLaterViewController.initFromStoryboard(name: Constant.Storyboards.payLater)
        self.navigationController?.pushViewController(payLaterVC, animated: true)
    }
    
    ///Go to VehicleCheck ViewController
    func goToVehicleCheck() {
        let vehicleCheckVC = VehicleCheckViewController.initFromStoryboard(name: Constant.Storyboards.vehicleCheck)
        self.navigationController?.pushViewController(vehicleCheckVC, animated: true)
    }
    
    
    
    //MARK: -- Actions
    @IBAction func menu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func reservation(_ sender: UISegmentedControl) {
        isReservationHistory = sender.selectedSegmentIndex == 1
        mReservCollectionV.reloadData()
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
            //cell.setInfoCell(item: item, index: indexPath.item)
            return cell
            
        } else if item.isRegisterNumber {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationWithRegisterNumberCollectionViewCell.identifier, for: indexPath) as!  ReservationWithRegisterNumberCollectionViewCell
            
            cell.setInfoCell(item: item, index: indexPath.item)
            cell.didPressStartRide = {
                self.goToPayLater()
            }
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationWithStartRideCollectionViewCell.identifier, for: indexPath) as!  ReservationWithStartRideCollectionViewCell
        
        cell.setInfoCell(item: item, index: indexPath.item)
        cell.pressStartRide = {
            self.goToVehicleCheck()
        }
        return cell
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isReservationHistory {
            return CGSize(width: collectionView.bounds.width,
                          height: 274)
        }
        if ReservationWithReservedPaidData.reservationWithReservedPaidModel[indexPath.item].isRegisterNumber {
            return CGSize(width: collectionView.bounds.width,
                          height: 307)
//            return CGSize(width: collectionView.bounds.width - 32,
//                          height: reservation_with_carNumber_height)
        }
       return CGSize(width: collectionView.bounds.width,
                    height: 245)
            //        return CGSize(width: collectionView.bounds.width - 32,
            //                      height: reservation_no_carNumber_height)

        
    }
    
}
