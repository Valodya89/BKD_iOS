//
//  MyDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

//let driverPrice = 9.99

protocol MyDriversViewControllerDelegate: AnyObject {
    func selectedDrivers(_ isSelecte: Bool,
                         additionalDrivers: [MyDriversModel]?,
                         oldReservDrivers: [DriverToRent]?,
                         editReservationModel: EditReservationModel?)
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
    lazy var myDriversVM: MyDriversViewModel = MyDriversViewModel()
    var totalPrice: Double = 0.0
    var driver: MainDriver?
    private var settings: Settings?

    
   // public var accessories: [AccessoriesEditModel]?
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
        settings = ApplicationSettings.shared.settings
        getMyDriverList()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.selectedDrivers(totalPrice > 0.0 ? true : false , additionalDrivers: additionalDrivers, oldReservDrivers: nil, editReservationModel: nil)
        PriceManager.shared.additionalDriversPrice = totalPrice
        
    }
    
    func setupView() {
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        mAddDriverBckgV.layer.cornerRadius = mAddDriverBckgV.frame.height/2
        mAddBtn.layer.cornerRadius = mAddBtn.frame.size.width/2
        mAddBtn.clipsToBounds = true
        configureDelegates()
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

    
//    /// check if reservetion time in range
//    func getSettings() {
//        settings = ApplicationSettings.shared.settings
//        guard let _ = settings else { return }
//
//    }
    
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
                mMyDriverCollectionV.reloadData()
            }
            getDriverToContinue(driverList: result)
            
            totalPrice =  myDriversVM.countTotalPrice(additionalDrivers: additionalDrivers, price: Double(settings?.metadata.AdditionalDriverValue ?? "0.0") ?? 0.0)
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
                             message: String(format: Constant.Texts.addDriverService, Double(settings?.metadata.AdditionalDriverValue ?? "0.0") ?? 0.0), cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm) {
            
        } okAction: {
            self.totalPrice += Double(self.settings?.metadata.AdditionalDriverValue ?? "0.0") ?? 0.0
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
        
    }
    
    
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
    
}


// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension MyDriversViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return additionalDrivers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        let item = additionalDrivers?[indexPath.item]
        cell.delegate = self
        cell.setCellInfo(item:item!, index: indexPath.item)
        return cell
    }
    
    //MARK: -- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width,
                      height: mydriver_cell_height)
    }
    
}


//MARK: -- MyDriverCollectionViewCellDelegate
extension MyDriversViewController: MyDriverCollectionViewCellDelegate {
    
    func didPressSelect(isSelected: Bool, cellIndex: Int) {
        
        if isSelected {
            showAlertSelecteDriver(index: cellIndex)
        } else {
            totalPrice -= Double(settings?.metadata.AdditionalDriverValue ?? "0.0") ?? 0.0
            updateDriverList(index: cellIndex, isSelected: isSelected)
        }
        
    }
    
    
}


//MARK: -- RegistartionBotViewControllerDelegate
extension MyDriversViewController: RegistartionBotViewControllerDelegate
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
