//
//  CarParametersCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-05-21.
//

import UIKit

class FilterSearchResultCell: UICollectionViewCell {
    static let identifier = "FilterSearchResultCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mTransmissionLb: UILabel!
    @IBOutlet weak var mManualBtn: UIButton!
    @IBOutlet weak var mManualLb: UILabel!
    @IBOutlet weak var mManualImgV: UIImageView!
    
    @IBOutlet weak var mAutomaticBtn: UIButton!
    @IBOutlet weak var mAutomaticLb: UILabel!
    @IBOutlet weak var mAutomaticImgV: UIImageView!
    
    @IBOutlet weak var mExteriorLb: UILabel!
    @IBOutlet weak var mCarSizeLb: UILabel!
    
    @IBOutlet weak var mBackgroundV: UIView!
    @IBOutlet weak var mCarEquipmentCollectionV: UICollectionView!
    @IBOutlet weak var mExteriorCollcetionV: UICollectionView!
    
    var equipmentModel:[EquipmentModel]?
    var selectedItem:Int = 0
    var currentCarType:CarTypes?
    let searchResultModelView = SearchResultModelView()
    var exteriors: [ExteriorModel]? = []
    var selectedExteriors: [Exterior]? = []
    var selectedTranssmitions:[String]? = []
    var criteriaParam: [[String : Any]]? = []
    
    var filterCars: (([CarsModel]?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUpView()
        getExteriorSizes()
        
    }
    
    func setUpView() {
        equipmentModel = EquipmentData.equipmentModel
        for  i in 0 ..< exteriors!.count  {
            self.exteriors![i].didSelect = false
        }
        initTransmission(sender: mAutomaticBtn, title: mAutomaticLb, imgV: mAutomaticImgV)
       initTransmission(sender: mManualBtn, title: mManualLb, imgV: mManualImgV)
       
        registerCollectionViews()
        // set the corner radius
       
        self.setShadow(color:  color_shadow!)
        //Border
        mCarSizeLb.layer.borderWidth = 1.0
        mCarSizeLb.layer.borderColor = color_navigationBar?.cgColor
        mBackgroundV.setBorder(color: .lightGray, width: 0.2)
        // add cornerRadius
        mBackgroundV.layer.cornerRadius = 20.0
        mBackgroundV.layer.masksToBounds = true
        mManualBtn.layer.cornerRadius = mManualBtn.frame.size.height/2.5
        mAutomaticBtn.layer.cornerRadius = mAutomaticBtn.frame.size.height/2.5
        mCarSizeLb.layer.cornerRadius = mCarSizeLb.frame.size.height/2.5
        
        mCarEquipmentCollectionV.reloadData()
        mExteriorCollcetionV.reloadData()
    }
    
    func registerCollectionViews() {
        //Register collectionView
        self.mCarEquipmentCollectionV.delegate = self
        self.mCarEquipmentCollectionV.dataSource = self
        self.mExteriorCollcetionV.delegate = self
        self.mExteriorCollcetionV.dataSource = self
        self.mCarEquipmentCollectionV.register(CarEquipmentCollectionViewCell.nib(), forCellWithReuseIdentifier: CarEquipmentCollectionViewCell.identifier)
        self.mExteriorCollcetionV.register(ExteriorCollectionViewCell.nib(), forCellWithReuseIdentifier: ExteriorCollectionViewCell.identifier)
    }
    
    func initTransmission(sender:UIButton,
                          title:UILabel,
                          imgV:UIImageView) {
        sender.backgroundColor = .clear
        sender.addBorder(color: color_navigationBar!, width: 1.0)
        title.font = font_unselected_filter
        title.textColor = color_entered_date
        imgV.setTintColor(color: color_exterior_tint!)
    }
    
    
    func selectTransmission(sender:UIButton,
                          title:UILabel,
                          imgV:UIImageView) {
        
        if sender.backgroundColor == .clear {
            sender.backgroundColor = color_btn_pressed
            sender.layer.borderWidth = 0.0
            title.font = font_selected_filter
            title.textColor = color_selected_filter_fields
            imgV.setTintColor(color: color_selected_filter_fields!)
        } else {
            sender.backgroundColor = .clear
            sender.addBorder(color: color_navigationBar!, width: 1.0)
            title.font = font_unselected_filter
            title.textColor = color_entered_date
            imgV.setTintColor(color: color_exterior_tint!)
        }
    }
    
    ///Get exterior sizes of the cars
    func getExteriorSizes() {
        searchResultModelView.getExteriorSizes { (exteriorList) in
            print(exteriorList)
            for  i in 0 ..< exteriorList.count {
                self.exteriors!.append(ExteriorModel(exterior: exteriorList[i], didSelect: false))
            }
            self.mExteriorCollcetionV.reloadData()
        }
    }

    //MARK: ACTIONS
    @IBAction func manual(_ sender: UIButton) {
        selectTransmission(sender: mManualBtn, title: mManualLb, imgV:mManualImgV)
        
        if mManualBtn.backgroundColor == color_btn_pressed {
            selectedTranssmitions?.append(Constant.Texts.manual)
        }  else  {
            selectedTranssmitions = selectedTranssmitions!.filter(){$0 != Constant.Texts.manual}
        }
        criteriaParam = searchResultModelView.setTransmissions(criteriaParams: criteriaParam, transmissions: selectedTranssmitions ?? [])
        filterCollectionView()
    }
    
    
    @IBAction func automatic(_ sender: UIButton) {
        selectTransmission(sender: mAutomaticBtn, title: mAutomaticLb, imgV:mAutomaticImgV)
        
        if mAutomaticBtn.backgroundColor == color_btn_pressed {
            selectedTranssmitions?.append(Constant.Texts.automatic)
        }  else  {
            selectedTranssmitions = selectedTranssmitions!.filter(){$0 != Constant.Texts.automatic}
        }
        criteriaParam = searchResultModelView.setTransmissions(criteriaParams: criteriaParam, transmissions: selectedTranssmitions ?? [])
        filterCollectionView()
    }
}


extension FilterSearchResultCell: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mCarEquipmentCollectionV {
            return equipmentModel?.count ?? 0
        }
        return exteriors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mCarEquipmentCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarEquipmentCollectionViewCell.identifier, for: indexPath) as! CarEquipmentCollectionViewCell
           
            cell.setCellInfo(item: equipmentModel![indexPath.item])
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExteriorCollectionViewCell.identifier, for: indexPath) as! ExteriorCollectionViewCell
        guard let _ = exteriors else { return cell }
        cell.setCellInfo(item:  exteriors![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = font_unselected_filter
        var size : CGSize = CGSize()
        size.height = collectionView.frame.height * 0.480519

       if collectionView == mCarEquipmentCollectionV {
            let equipment: EquipmentModel = equipmentModel![indexPath.item]
            _ = equipment.equipmentImg.size.height
            let widthInPoints = equipment.equipmentImg.size.width
            let width = equipment.equipmentName.size(OfFont: font!).width
            size.width =  width + widthInPoints + 65
            return size
        }

        let width = exteriors![indexPath.item].exterior!.getExterior().size(OfFont: font!).width
        size.width = width + 30
        return size
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell: UICollectionViewCell = collectionViewDidTouch(indexPath: indexPath, collectionView: collectionView)
        
        if cell.backgroundColor == .clear {
            selectedCell(collectionView: collectionView, cell: cell, index: indexPath.row)
        } else {
            unselectedCell(collectionView: collectionView, cell: cell, index: indexPath.row)
        }
    }
    
    ///Get touched CollectionCell
    private func collectionViewDidTouch(indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        
        if collectionView == mCarEquipmentCollectionV {
             return collectionView.cellForItem(at: indexPath) as! CarEquipmentCollectionViewCell
        } else {
             return collectionView.cellForItem(at: indexPath) as! ExteriorCollectionViewCell
        }
    }
    
    ///Selecte cell
    private func selectedCell(collectionView: UICollectionView, cell: UICollectionViewCell, index: Int) {
        
        cell.backgroundColor = color_btn_pressed
        cell.layer.borderWidth = 0.0
        if collectionView == mCarEquipmentCollectionV {
            (cell as! CarEquipmentCollectionViewCell).mImageV.setTintColor(color: color_selected_filter_fields!)
            (cell as! CarEquipmentCollectionViewCell).mTitleLb.font = font_selected_filter

            equipmentModel![index].didSelect = true
            criteriaParam = searchResultModelView.setEquipmentParam(index: index, criteriaParams: criteriaParam)
            
        } else {

            exteriors![index].didSelect = true
            selectedExteriors?.append(exteriors![index].exterior!)
            criteriaParam = searchResultModelView.setExteriorParam(criteriaParams: criteriaParam, exteriors: selectedExteriors!)
        }
        filterCollectionView()

    }
    
    ///Unselecte cell
    private func unselectedCell(collectionView: UICollectionView, cell: UICollectionViewCell, index: Int) {
        
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = .clear
        if collectionView == mCarEquipmentCollectionV {

            (cell as! CarEquipmentCollectionViewCell).mImageV.setTintColor(color: color_exterior_tint!)
            (cell as! CarEquipmentCollectionViewCell).mTitleLb.font = font_unselected_filter
            
            equipmentModel![index].didSelect = false
            criteriaParam = searchResultModelView.removeEquipmentParam(index: index, criteriaParams: criteriaParam)
        } else {

            exteriors![index].didSelect = false
            selectedExteriors = searchResultModelView.removeExterior(exteriors: selectedExteriors!, exterior: exteriors![index].exterior!)
            criteriaParam = searchResultModelView.setExteriorParam(criteriaParams: criteriaParam, exteriors: selectedExteriors!)
        }
        filterCollectionView()
    }
    
    /// Filter cars (search)
    private func filterCollectionView() {
        guard let _ = criteriaParam, let _ = currentCarType else {return}
        searchResultModelView.getCarsByFilter(carType: currentCarType!, criteria: criteriaParam!) { (carsModel) in
            self.filterCars!(carsModel)
            print(carsModel)
        }
    }
}


extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

