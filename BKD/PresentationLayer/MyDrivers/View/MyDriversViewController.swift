//
//  MyDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

let driverPrice = 9.99

protocol MyDriversViewControllerDelegate: AnyObject {
    func selectedDrivers(_ isSelecte: Bool, additionalDrivers: [MyDriversModel]?)
}

class MyDriversViewController: BaseViewController {
//MARK: Outlets
    @IBOutlet weak var mMyDriverCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mAddDriverBckgV: UIView!
    @IBOutlet weak var mAddDriverLb: UILabel!
    @IBOutlet weak var mAddBtn: UIButton!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mTotalPriceContentbottom: NSLayoutConstraint!
 
    //Confirm
    @IBOutlet weak var mConfirmV: ConfirmView!
    
    //MARK: --Variables
    weak var delegate: MyDriversViewControllerDelegate?
    lazy var myDriversViewModel: MyDriversViewModel = MyDriversViewModel()
    var totalPrice:Double = PriceManager.shared.additionalDriversPrice ?? 0.0
    var driver: MainDriver?
    
    public var isEditReservation:Bool = false
    public var additionalDrivers: [MyDriversModel]?
    

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if additionalDrivers == nil {
            getMyDriverList()
        } else {
            mPriceLb.text = String(format: "%.2f", Float(PriceManager.shared.additionalDriversPrice ?? 0.0))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PriceManager.shared.additionalDriversPrice = totalPrice
        self.delegate?.selectedDrivers(totalPrice > 0.0 ? true : false , additionalDrivers: additionalDrivers)
    }
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
       
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        mAddDriverBckgV.layer.cornerRadius = mAddDriverBckgV.frame.height/2
        mAddBtn.layer.cornerRadius = mAddBtn.frame.size.width/2
        mAddBtn.clipsToBounds = true
        configureDelegates()
        configureViewForEdit()
        handlerConfirm()
    }
     
     private func configureDelegates() {
        mMyDriverCollectionV.delegate = self
        mMyDriverCollectionV.dataSource = self
     }
    
    ///Configure view wehn it open for edit
    func configureViewForEdit() {
        if isEditReservation {
            mConfirmV.isHidden = !isEditReservation
            mTotalPriceContentbottom.constant = 76
        }
    }
    
    ///Get my driver list
    private func getMyDriverList () {
        myDriversViewModel.getMyDrivers { (result, error) in
            guard let result = result else {
                if let _ = error {
                    self.showAlertSignIn()
                }
                return
            }
            self.additionalDrivers = self.myDriversViewModel.setActiveDriverList(allDrivers: result)
            self.mMyDriverCollectionV.reloadData()
            self.myDriversViewModel.getDriverToContinueToFill(allDrivers: result) { driver in
                guard let driver = driver else {return}
                self.driver = driver
            }
        }
    }
    
    
    //Go to registeration bot screen
    func goToRegistrationBot(isDriverRegister:Bool,
                             tableData: [RegistrationBotModel],
                             mainDriver: MainDriver?) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = tableData
        registrationBotVC.isDriverRegister = isDriverRegister
        registrationBotVC.mainDriver = mainDriver
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
    
    private func showAlertSelecteDriver(index: Int) {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.addDriverAlert, driverPrice), cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm) {
            
        } okAction: {
            self.mConfirmV.enableView()
            self.totalPrice += driverPrice
            self.updateTotalPrice(index: index,
                             isSelected: true)
        }

    }
    
    ///Update total price
    private func updateTotalPrice(index: Int, isSelected: Bool) {
        mPriceLb.text = String(totalPrice)
        additionalDrivers?[index].isSelected = isSelected
        additionalDrivers?[index].totalPrice = totalPrice
        mMyDriverCollectionV.reloadData()
    }

    
    //MARK: ACTIONS
    //MARK: ----------------
    @IBAction func addDriver(_ sender: UIButton) {
        if driver != nil {
            self.goToRegistrationBot(isDriverRegister: true,
                                     tableData: [RegistrationBotData.registrationBotModel[0]],
                                     mainDriver: self.driver)
        } else {
            self.goToRegistrationBot(isDriverRegister: true,
                                     tableData: [RegistrationBotData.registrationDriverModel[0]],
                                     mainDriver: nil)
        }
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
//        self.delegate?.selectedDrivers(totalPrice > 0.0 ? true : false , additionalDrivers: additionalDrivers)
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerConfirm() {
        mConfirmV.didPressConfirm = {
            self.goToEditReservationAdvanced()
        }
    }
}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension MyDriversViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return additionalDrivers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        let item = additionalDrivers?[indexPath.item]
        cell.delegate = self
        cell.setCellInfo(item:item!, index: indexPath.item)
        if item!.isSelected {
            totalPrice += item!.price
            self.mPriceLb.text = String(totalPrice)
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width,
                      height: mydriver_cell_height)
    }
    
}


//MARK: MyDriverCollectionViewCellDelegate
extension MyDriversViewController: MyDriverCollectionViewCellDelegate {
    
    func didPressSelect(isSelected: Bool, cellIndex: Int) {
        
        if isSelected {
           // if isEditReservation {
            showAlertSelecteDriver(index: cellIndex)
//            } else {
//                totalPrice += driverPrice
//            }
//
        } else {
            if isEditReservation {
                mConfirmV.enableView()
            } else {
                totalPrice -= driverPrice
            }
            updateTotalPrice(index: cellIndex, isSelected: isSelected)
        }
       
    }
    
    
}
