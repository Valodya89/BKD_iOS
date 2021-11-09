//
//  AccessoriesUIViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit


protocol AccessoriesUIViewControllerDelegate: AnyObject {
    func addedAccessories(_ isAdd: Bool,
                          totalPrice: Double,
                          accessoriesEditList: [AccessoriesEditModel]?)
}
class AccessoriesUIViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mAccessoriesCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mConfirmV: ConfirmView!
    @IBOutlet weak var mTotalPriceBottom: NSLayoutConstraint!
    
    //MARK: -- Variables
    public var isEditReservation: Bool = false
    var accessoriesList: [Accessories]?
    let accessoriesViewModel = AccessoriesViewModel()
    var totalPrice: Double = 0
    weak var delegate: AccessoriesUIViewControllerDelegate?
    
    public var accessoriesEditList: [AccessoriesEditModel]?
    public var vehicleModel: VehicleModel?

    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        
        getAccessories()
        configureDelegates()
        configureViewForEdit()
        handlerConfirm()

    }
    
    ///Get accessories list
    func getAccessories() {
        accessoriesViewModel.getAccessories(carID: vehicleModel?.vehicleId ?? "") { result in
            guard let _ = result else {return}
            self.accessoriesList = self.accessoriesViewModel.getActiveAccessoryList(accessories: result!)
            
            if self.accessoriesEditList == nil {
                self.accessoriesEditList = Array(repeating: AccessoriesEditModel(accessoryCount: 0, isAdded: false, totalPrice: 0.0), count: self.accessoriesList!.count)
            }
            self.mAccessoriesCollectionV.reloadData()        }
    }
    
    ///Configure view wehn it open for edit
    func configureViewForEdit() {
        if isEditReservation {
            mConfirmV.isHidden = !isEditReservation
            mTotalPriceBottom.constant = -76
        }
    }
  
   ///configure Delegates
    private func configureDelegates() {
        mAccessoriesCollectionV.delegate = self
        mAccessoriesCollectionV.dataSource = self
    }
    
    ///Show alert for sign in account
    private func showAlertSignIn() {
        BKDAlert().showAlert(on: self,
                             title: nil,
                             message: Constant.Texts.loginAccessories,
                             messageSecond: nil,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.signIn,
                             cancelAction: nil) {
            self.goToSignInPage()
        }
    }
    
    //MARK: -- ACTION
    @IBAction func back(_ sender: Any) {
        
        self.delegate?.addedAccessories(self.mPriceLb.text == "0.0" ? false : true , totalPrice: totalPrice, accessoriesEditList: accessoriesEditList)
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
extension AccessoriesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessoriesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccessoriesCollectionViewCell.identifier, for: indexPath) as!  AccessoriesCollectionViewCell
        guard  let _ = accessoriesList else {
            return cell
        }
        let item = accessoriesList![indexPath.row]
        let editItem = accessoriesEditList![indexPath.row]
        cell.setCellInfo(item: item, editItem: editItem,  index: indexPath.row)
        
        if editItem.isAdded {
            totalPrice += Double(editItem.accessoryCount!) * item.price
            self.mPriceLb.text = String(totalPrice)

        }
        cell.delegate = self
        return cell
    }
    
//    //MARK: UICollectionViewDelegateFlowLayout
//    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width,
                      height: self.view.bounds.height * 0.153465)
    }
}

//MARK: AccessoriesCollectionViewCellDelegate
//MARK: ------------------------
extension AccessoriesUIViewController: AccessoriesCollectionViewCellDelegate {
    
    func didChangeCount(cellIndex: Int, count: Int) {
            accessoriesEditList![cellIndex].accessoryCount = count
        
    }

    func didPressAdd(isAdd: Bool, cellIndex: Int, id: String?) {
        if KeychainManager().isUserLoggedIn() {
            accessoriesEditList![cellIndex].isAdded = isAdd
            accessoriesEditList![cellIndex].accessoryId = id
        } else {
            showAlertSignIn()
        }
    }
    
    
    ///increase or decrease Accessory
    func increaseOrDecreaseAccessory(accessoryPrice: Double,
                     isIncrease: Bool) {
        totalPrice = (mPriceLb.text! as NSString).doubleValue
        
        accessoriesViewModel.getTotalAccesories(accessoryPrice: accessoryPrice, totalPrice: totalPrice, isIncrease: isIncrease) { [self] (totalValue) in
            self.mPriceLb.text = totalValue
            self.totalPrice = (totalValue as NSString).doubleValue
            
            if self.isEditReservation {
                self.mConfirmV.enableView()
            }
        }
    }
    
    
}

