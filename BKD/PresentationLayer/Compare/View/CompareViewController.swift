//
//  CompareViewController.swift
//  CompareViewController
//
//  Created by Karine Karapetyan on 05-10-21.
//

import UIKit

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
    var isOpenCategory: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView() {
        mRightBarBtn.image = img_bkd
        mCategoryContentV.layer.cornerRadius = 3
        mCategoryContentV.setShadow(color: color_shadow!)
        mFirstVehicleContentV.layer.cornerRadius = 8
        mSecondVehicleContentV.layer.cornerRadius = 8

        mCategoryTableV.categoryList = ApplicationSettings.shared.carTypes
    }

    ///Drop down or drop up image view
    func animateDropDown(willOpen:Bool, dropDownImgV: UIImageView) {
        let rotationAngle = willOpen ? CGFloat(Double.pi) : CGFloat(Double.pi * -2)
        dropDownImgV.rotateImage(rotationAngle: rotationAngle)
    }
    
    //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func category(_ sender: UIButton) {
        mCategoryTableV.isCategory = true
        mCategoryTableV.reloadData()

        mCategoryTableV.updateTableHeight(willOpen: !isOpenCategory)
        animateDropDown(willOpen: !isOpenCategory, dropDownImgV: mCategoryDropDownImgV)
        isOpenCategory = !isOpenCategory
    }
    
    @IBAction func firstVehicle(_ sender: UIButton) {
        
    }
    
    @IBAction func secondVehicle(_ sender: UIButton) {
        
    }
}
