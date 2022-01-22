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
    
    //MARK: -- Outlets
    @IBOutlet weak var mAccessoriesCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mConfirmV: ConfirmView!
    @IBOutlet weak var mTotalPriceBottom: NSLayoutConstraint!
    
    //MARK: -- Variables
    weak var delegate: AccessoriesUIViewControllerDelegate?
    lazy var accessoriesVM = AccessoriesViewModel()
    var totalPrice: Double = 0
    var carId: String = ""
    
    public var isEditReservation: Bool = false
    public var accessoriesEditList: [AccessoriesEditModel]?
    public var vehicleModel: VehicleModel?
    public var currRent: Rent?
    public var editReservationModel: EditReservationModel?


    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mConfirmV.initConfirm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isEditReservation {
            PriceManager.shared.accessoriesPrice = totalPrice
            self.delegate?.addedAccessories(self.mPriceLb.text == "0.0" ? false : true , totalPrice: totalPrice, accessoriesEditList: accessoriesEditList)
        }
    }
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        carId = isEditReservation ? (currRent?.carDetails.id ?? "") : (vehicleModel?.vehicleId ?? "")

        getAccessories()
        configureDelegates()
        configureViewForEdit()
        handlerConfirm()

    }
    
    ///Set edited accessories
    func setEditAccessories() {
        editReservationModel?.accessories = accessoriesVM.getEditAccessories(accessories: accessoriesEditList)
    }
    
    ///Get accessories list
    func getAccessories() {
        accessoriesVM.getAccessories(carID: carId) { [self] result, error in
            guard let _ = result else { return }
            if accessoriesEditList == nil {
                if !isEditReservation {
                    accessoriesEditList = accessoriesVM.getActiveAccessoryList(accessories: result!)
                } else {
                    let accessoriesEditInfo = accessoriesVM.getAccessoriesEditList(rent: currRent, accessories:  result!)
                    accessoriesEditList = accessoriesEditInfo.accessories
                    totalPrice = accessoriesEditInfo.totalPrice
                    setEditAccessories()
                }
            } else {
                totalPrice = PriceManager.shared.accessoriesPrice ?? 0.0
            }
            mPriceLb.text = String(format: "%.2f", Float(totalPrice))
            mAccessoriesCollectionV.reloadData()        }
    }
    
    ///Configure view when it open for edit
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
  
    
    ///Edite reserv accessory list
    func eritReserveAccessoryList(isAdd: Bool, accessory: AccessoriesEditModel) {
        accessoriesVM.editReservationAccessories(isAdd: isAdd,
                                                                                      editAccessiries: accessory,
                                                 editReservationAccessories: editReservationModel?.accessories) { result in
            self.editReservationModel?.accessories = result
        }
    }
    
    //MARK: -- ACTION
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerConfirm() {
        mConfirmV.didPressConfirm = {
            self.goToEditReservationAdvanced(rent: self.currRent, accessories: nil,
                                             editReservationModel: self.editReservationModel)
        }
    }
}


// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension AccessoriesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessoriesEditList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccessoriesCollectionViewCell.identifier, for: indexPath) as!  AccessoriesCollectionViewCell

        let editItem = accessoriesEditList![indexPath.row]
        cell.setCellInfo(editItem: editItem,  index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    //MARK: -- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width,
                      height: self.view.bounds.height * 0.153465)
    }
}

//MARK: -- AccessoriesCollectionViewCellDelegate
extension AccessoriesUIViewController: AccessoriesCollectionViewCellDelegate {
    
    func didPressAdd(isAdd: Bool, cellIndex: Int,
                     id: String?, name: String?,
                     image: UIImage?) {
        accessoriesEditList![cellIndex].isAdded = isAdd
        accessoriesEditList![cellIndex].id = id
        accessoriesEditList![cellIndex].count =  accessoriesEditList![cellIndex].count ?? 1
        
        if isEditReservation {
            eritReserveAccessoryList(isAdd: isAdd, accessory: accessoriesEditList![cellIndex])
             }
    }
    
    func didChangeCount(isAdd: Bool, cellIndex: Int, count: Int) {
        accessoriesEditList![cellIndex].count = count
        if isEditReservation && isAdd {
            eritReserveAccessoryList(isAdd: isAdd, accessory: accessoriesEditList![cellIndex])
        }
    }
    
    
    ///increase or decrease Accessory
    func increaseOrDecreaseAccessory(accessoryPrice: Double,
                                     isIncrease: Bool) {
        totalPrice = (mPriceLb.text! as NSString).doubleValue
        
        accessoriesVM.getTotalAccesories(accessoryPrice: accessoryPrice, totalPrice: totalPrice, isIncrease: isIncrease) { [self] (totalValue) in
            self.mPriceLb.text = totalValue
            self.totalPrice = (totalValue as NSString).doubleValue
            
            if self.isEditReservation {
                self.mConfirmV.enableView()
            }
        }
    }
    
    
}

