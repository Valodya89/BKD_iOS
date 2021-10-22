//
//  CompareViewController.swift
//  CompareViewController
//
//  Created by Karine Karapetyan on 05-10-21.
//

import UIKit


enum TableState {
    case category
    case firstVehicle
    case secondVehicle
    case close
}

class CompareViewController: BaseViewController {

   //MARK: -- Outlets
    
    ///Category
    @IBOutlet weak var mCategoryContentV: UIView!
    @IBOutlet weak var mCategoryDropDownImgV: UIImageView!
    @IBOutlet weak var mCategoryBtn: UIButton!
    @IBOutlet weak var mCategoryTableV: DropDownTableView!
    
    ///Choose vehicles
    @IBOutlet weak var mFirstVehicleContentV: UIView!
    @IBOutlet weak var mSecondVehicleContentV: UIView!
    @IBOutlet weak var mFirstVehicleDropDownImgV: UIImageView!
    @IBOutlet weak var mSecondVehicleDropDownImgV: UIImageView!
    @IBOutlet weak var mFirstVehicleBtn: UIButton!
    @IBOutlet weak var mSecondVehicleBtn: UIButton!
    @IBOutlet weak var mVehicleTableV: DropDownTableView!
    
    ///Compare views
    @IBOutlet weak var mFirstVehicleInfoV: CompareVehicleInfoView!
    @IBOutlet weak var mSecondVehicleInfoV: CompareVehicleInfoView!
    
    ///Navigation
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: -- Variables
    let compareViewModel = CompareViewModel()
    public var vehicleModel:VehicleModel?
    private var currVehicleInfoV: CompareVehicleInfoView?
    private var isOpenTable: Bool = false
    
    
    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_navigationBar!)
        mRightBarBtn.image = img_bkd
        mCategoryContentV.layer.cornerRadius = 3
        mCategoryContentV.setShadow(color: color_shadow!)
        mFirstVehicleContentV.layer.cornerRadius = 8
        mSecondVehicleContentV.layer.cornerRadius = 8
        mCategoryTableV.categoryList = ApplicationSettings.shared.carTypes
        mFirstVehicleInfoV.delegate = self
        mSecondVehicleInfoV.delegate = self
        configureFirstVehicleUI()
        handlerCategory()
        handlerFirstVehicle()
        handlerSecondVehicle()
        handlerTableCell()
    }
    
    
    
    //Configure first vehicle UI
    func configureFirstVehicleUI() {
        mCategoryBtn.setTitle(vehicleModel?.vehicleType, for: .normal)
        let categoryId = compareViewModel.getCurrentCarType(typeName: vehicleModel?.vehicleType ?? "")
        let carList: [CarsModel]? = ApplicationSettings.shared.carsList?[categoryId]!
        self.mVehicleTableV.carList = carList
        self.mFirstVehicleInfoV.carModel =  compareViewModel.getCurrentCarModel(carsList: carList, carId: vehicleModel?.vehicleId)
        self.mFirstVehicleBtn.setTitle(vehicleModel?.vehicleName, for: .normal)
        self.mFirstVehicleInfoV.configureUI()
    }

    ///Drop down or drop up image view
    func animateDropDown(willOpen:Bool, dropDownImgV: UIImageView) {
        let rotationAngle = willOpen ? CGFloat(Double.pi) : CGFloat(Double.pi * -2)
        dropDownImgV.rotateImage(rotationAngle: rotationAngle)
    }
    
    //Close tables if it´s open
    func closeTable(){
        checkFirstTable()
        checkSecondTabel()
    }
    
    //Check if open first vehicle Table view
    func checkFirstTable() {
        if mVehicleTableV.tableState == .firstVehicle && isOpenTable {
            animateDropDown(willOpen: !isOpenTable, dropDownImgV: mFirstVehicleDropDownImgV)
            updateTableHeight(willOpen: !isOpenTable,
                              view: mVehicleTableV)
            mVehicleTableV.tableState = .close
            isOpenTable = !isOpenTable
        }
    }
    
    ///Update table height
    public func updateTableHeight(willOpen:Bool, view: DropDownTableView)  {
        
        UIView.animate(withDuration: 0.5) {
            view.mTableHeight.constant = willOpen ? view.contentSize.height : 0.0
            self.view.layoutIfNeeded()

        }

    }
    
    //Check if open second vehicle Table view
    func checkSecondTabel() {
        if mVehicleTableV.tableState == .secondVehicle && isOpenTable {
            animateDropDown(willOpen: !isOpenTable, dropDownImgV: mSecondVehicleDropDownImgV)
            updateTableHeight(willOpen: !isOpenTable, view: mVehicleTableV)
            mVehicleTableV.tableState = .close
            isOpenTable = !isOpenTable
        }
    }
    
    
   
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func category(_ sender: UIButton) {
        closeTable()
        mCategoryTableV.tableState = .category
        mCategoryTableV.reloadData()

        updateTableHeight(willOpen: !isOpenTable,
                          view: mCategoryTableV)
        animateDropDown(willOpen: !isOpenTable, dropDownImgV:mCategoryDropDownImgV )
        isOpenTable = !isOpenTable
    }
    
    @IBAction func firstVehicle(_ sender: UIButton) {
        checkSecondTabel()
        mVehicleTableV.tableState = .firstVehicle
        mVehicleTableV.reloadData()
        
        updateTableHeight(willOpen: !isOpenTable,
                          view: mVehicleTableV)
        animateDropDown(willOpen: !isOpenTable,
                        dropDownImgV: mFirstVehicleDropDownImgV)
        isOpenTable = !isOpenTable
    }
    
    @IBAction func secondVehicle(_ sender: UIButton) {
        checkFirstTable()
            mVehicleTableV.tableState = .secondVehicle
            mVehicleTableV.reloadData()
            
        updateTableHeight(willOpen: !isOpenTable,
                          view: mVehicleTableV)
            animateDropDown(willOpen: !isOpenTable, dropDownImgV: mSecondVehicleDropDownImgV)
            isOpenTable = !isOpenTable
    }
    
    ///Did select category
    func handlerCategory() {
        mCategoryTableV.didSelectCategory = { currCategory in
            guard let category = currCategory else {return}
            let carList = ApplicationSettings.shared.carsList?[category.id]
            self.mVehicleTableV.carList = carList as? [CarsModel]
            self.animateDropDown(willOpen: false, dropDownImgV: self.mCategoryDropDownImgV)
            self.isOpenTable = false
            self.mCategoryBtn.setTitle(category.name, for: .normal)
            self.mSecondVehicleBtn.setTitle(Constant.Texts.vehicle2, for: .normal)
            self.mSecondVehicleInfoV.isHidden = true
        }
    }    
    
    //Did select First vehicle
    func handlerFirstVehicle() {
        mVehicleTableV.didSelectFirstVehicle = { carModel in
            guard let carModel = carModel else {return}
            self.animateDropDown(willOpen: false, dropDownImgV: self.mFirstVehicleDropDownImgV)
            self.isOpenTable = false
            self.mFirstVehicleInfoV.carModel = carModel
            self.mFirstVehicleBtn.setTitle(carModel.name, for: .normal)
            self.mFirstVehicleInfoV.configureUI()
            self.mFirstVehicleInfoV.isHidden = false
        }
    }
    
    //Did select second vehicle
    func handlerSecondVehicle() {
        mVehicleTableV.didSelectSecondVehicle = { carModel in
            guard let carModel = carModel else {return}
            self.animateDropDown(willOpen: false, dropDownImgV: self.mSecondVehicleDropDownImgV)
            self.isOpenTable = false
            self.mSecondVehicleInfoV.carModel = carModel
            self.mSecondVehicleBtn.setTitle(carModel.name, for: .normal)
            self.mSecondVehicleInfoV.configureUI()
            self.mSecondVehicleInfoV.isHidden = false
        }
    }
    
    //Did select table cell
    func handlerTableCell() {
        mVehicleTableV.didCloseTable = {
            self.updateTableHeight(willOpen: false, view: self.mVehicleTableV)
        }
        mCategoryTableV.didCloseTable = {
            self.updateTableHeight(willOpen: false, view: self.mCategoryTableV)
        }
    }
    
}

//MARK: -- CompareVehicleInfoViewDelegate
//MARK: ----------------------------------
extension CompareViewController: CompareVehicleInfoViewDelegate {
    func didSelectMore(carModel: CarsModel) {
        self.goToMore(vehicleModel:nil, carModel:carModel)
    }
}
