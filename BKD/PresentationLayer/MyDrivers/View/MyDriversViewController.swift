//
//  MyDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

protocol MyDriversViewControllerDelegate: AnyObject {
    func selectedDrivers(_ isSelecte: Bool, totalPrice: Double)
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
    public var isEditReservation:Bool = false
    var totalPrice:Double = 0
    var additionalDrivers: [MyDriversModel] = []

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMyDriverList()

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
        myDriversViewModel.getMyDrivers { (result) in
            guard let result = result else {
                return
            }
            self.additionalDrivers = self.myDriversViewModel.setActiveDriverList(allDrivers: result)
            self.mMyDriverCollectionV.reloadData()
        }
    }
    
    private func showAlertSelecteDriver() {
        BKDAlert().showAlert(on: self,
                             message: String(format: Constant.Texts.addDriverAlert, 9.99), cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.confirm) {
            
        } okAction: {
            self.mConfirmV.enableView()
        }

    }

    
    //MARK: ACTIONS
    //MARK: ----------------
    @IBAction func addDriver(_ sender: UIButton) {
//        BKDAlert().showAlert(on: self, message: String(format: Constant.Texts.addDriverAlert, 0.00) , cancelTitle: Constant.Texts.cancel, okTitle: Constant.Texts.confirm, cancelAction: nil) {
            
            self.goToRegistrationBot(isDriverRegister: true,
                                     tableData: [RegistrationBotData.registrationDriverModel[0]])
       // }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.delegate?.selectedDrivers(totalPrice > 0.0 ? true : false , totalPrice: totalPrice)
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
        return additionalDrivers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        let item = additionalDrivers[indexPath.item]
        cell.setCellInfo(item:item, index: indexPath.item)
        if item.isSelected {
            totalPrice += item.price
            self.mPriceLb.text = String(totalPrice)

        }
        cell.delegate = self
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
        
        let driverPrice = additionalDrivers[cellIndex].price
        if isSelected {
            if isEditReservation {
                showAlertSelecteDriver()
            } else {
                totalPrice += driverPrice
            }
            
        } else {
            if isEditReservation {
                mConfirmV.enableView()
            } else {
                totalPrice -= driverPrice
            }
        }
        mPriceLb.text = String(totalPrice)
        additionalDrivers[cellIndex].isSelected = isSelected
        additionalDrivers[cellIndex].totalPrice = totalPrice
    }
    
    
}
