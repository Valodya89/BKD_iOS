//
//  EditMyDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-01-22.
//

import UIKit



protocol EditMyDriversViewControllerDelegate: AnyObject {
    func selectedDrivers(_ isSelecte: Bool,
                         additionalDrivers: [MyDriversModel]?,
                         oldReservDrivers: [DriverToRent]?,
                         editReservationModel: EditReservationModel?)
}

class EditMyDriversViewController: BaseViewController {
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
    weak var delegate: EditMyDriversViewControllerDelegate?
    lazy var myDriversVM = MyDriversViewModel()
    lazy var editMyDriversVM = EditMyDriversViewModel()
    var totalPrice: Double = 0.0
    var driver: MainDriver?
    
    public var additionalDrivers: [MyDriversModel]?
    public var oldReservDrivers: [DriverToRent]?
    public var editReservationModel:EditReservationModel?
    public var rent: Rent?
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationControll(navControll: navigationController, barBtn: mRightBarBtn)
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyDriverList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mConfirmV.initConfirm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    func setupView() {
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        mAddDriverBckgV.layer.cornerRadius = mAddDriverBckgV.frame.height/2
        mAddBtn.layer.cornerRadius = mAddBtn.frame.size.width/2
        mAddBtn.clipsToBounds = true
        configureDelegates()
        configureViewForEdit()
        handlerConfirm()
    }
    
    ///Set edit additional drivers
    func setEditDrivers() {
        oldReservDrivers = myDriversVM.getEditDrivers(drivers: additionalDrivers)
        if editReservationModel?.additionalDrivers == nil {
            editReservationModel?.additionalDrivers = oldReservDrivers
        }
    }
    ///Set total price
    func setTotalPrice() {
        mPriceLb.text = String(format: "%.2f", Float(totalPrice))
    }
    
    private func configureDelegates() {
        mMyDriverCollectionV.delegate = self
        mMyDriverCollectionV.dataSource = self
    }
    
    ///Configure view wehn it open for edit
    func configureViewForEdit() {
            //checkisEditedDrivers()
            mConfirmV.isHidden = false
            mTotalPriceContentbottom.constant = 76
    }
    
    ///Get my driver list
    private func getMyDriverList () {
        myDriversVM.getMyDrivers { [self] (result, error) in
            guard let result = result else {
                if let _ = error {
                    showAlertSignIn()
                }
                return
            }
            
            if additionalDrivers == nil {
                additionalDrivers = myDriversVM.setActiveDriverList(allDrivers: result)
                let driversInfo = editMyDriversVM.getDriversEditList(rent: rent, drivers: additionalDrivers!)
                additionalDrivers = driversInfo.additionalDrivers
                totalPrice = driversInfo.totalPrice
                setEditDrivers()
                mMyDriverCollectionV.reloadData()
            } else {
                totalPrice =  myDriversVM.countTotalPrice(additionalDrivers: additionalDrivers, price: driverPrice)
            }
            getDriverToContinue(driverList: result)
            setTotalPrice()
            
        }
    }
    
    
    ///Get driver for draft
    func getDriverToContinue(driverList: [MainDriver]) {
        self.myDriversVM.getDriverToContinueToFill(allDrivers: driverList) { driver in
            guard let driver = driver else {return}
            self.driver = driver
        }
    }
    
    //Go to registeration bot screen
    func goToRegistrationBot(isDriverRegister:Bool,
                             tableData: [RegistrationBotModel],
                             mainDriver: MainDriver?) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.delegate = self
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
            self.updateDriverList(index: index,
                                  isSelected: true)
        }
        
    }
    
    ///Update driver list
    private func updateDriverList(index: Int, isSelected: Bool) {
        setTotalPrice()
        additionalDrivers?[index].isSelected = isSelected
        additionalDrivers?[index].totalPrice = totalPrice
        mMyDriverCollectionV.reloadData()
        eritReservedriverList(isSelected: isSelected, editDriver: (additionalDrivers?[index])!)
    }
    
    ///Edite reserved additional driver list
    func eritReservedriverList(isSelected: Bool, editDriver: MyDriversModel) {
        editMyDriversVM.editReservationDrivers(isSelected: isSelected,                                     editDriver: editDriver,
                                           editReservationDrivers: editReservationModel?.additionalDrivers ?? [], completion:{ reseult in
            self.editReservationModel?.additionalDrivers = reseult
            //self.checkisEditedDrivers()
            
        })
    }
    
    //    ///Check is edited additional driver list
    //    func checkisEditedDrivers() {
    //        if myDriversVM.isEdietedDriverList(oldDrivers: oldEditedReservDrivers ?? [], editedDrivers: editReservationModel?.additionalDrivers ?? []) {
    //            mConfirmV.enableView()
    //        } else {
    //            mConfirmV.disableView()
    //        }
    //    }
    
    //MARK: -- Actions
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerConfirm() {
        mConfirmV.didPressConfirm = { [self] in
            EditedPriceManager.shared.additionalDriversPrice = totalPrice
            delegate?.selectedDrivers(true, additionalDrivers: additionalDrivers,
                                      oldReservDrivers: oldReservDrivers,
                                      editReservationModel: editReservationModel)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension EditMyDriversViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return additionalDrivers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        let item = additionalDrivers?[indexPath.item]
        cell.delegate = self
        cell.setCellInfo(item:item!, index: indexPath.item)
        cell.isUserInteractionEnabled = editMyDriversVM.isEnabledCell(editedDrivers: oldReservDrivers, currItem: item!)
        return cell
    }
    
    //MARK: -- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width,
                      height: mydriver_cell_height)
    }
    
}


//MARK: -- MyDriverCollectionViewCellDelegate
extension EditMyDriversViewController: MyDriverCollectionViewCellDelegate {
    
    func didPressSelect(isSelected: Bool, cellIndex: Int) {
        
        if isSelected {
            showAlertSelecteDriver(index: cellIndex)
        } else {
            totalPrice -= driverPrice
            updateDriverList(index: cellIndex, isSelected: isSelected)
        }
        
    }
    
}


//MARK: -- RegistartionBotViewControllerDelegate
extension EditMyDriversViewController: RegistartionBotViewControllerDelegate
{
    func backToMyBKD() {
    }

    func backToMyDrivers(mainDriver: MainDriver?) {
        if mainDriver?.state == Constant.Texts.state_agree || mainDriver?.state == Constant.Texts.state_accepted {
            guard let _ = additionalDrivers else {return}
            let driver = additionalDrivers!.filter({ $0.driver!.id == mainDriver?.id ?? ""}).first
            if driver == nil {
                let newDriver = myDriversVM.setActiveDriverList(allDrivers: [mainDriver!])
                additionalDrivers?.append(contentsOf: newDriver)
                mMyDriverCollectionV.reloadData()
            }
        }
    }
}
