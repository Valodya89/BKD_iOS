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
    var selectedItem:Int = 0
    
    let searchResultModelView = SearchResultModelView()
    var exteriorSizes: [Exterior]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        getExteriorSizes()
        
    }
    
    func setUpView() {
        initTransmission(firstBtn: mAutomaticBtn,
                         secondBtn: mManualBtn,
                         firstLb: mAutomaticLb,
                         secondLb: mManualLb,
                         firstImgV: mAutomaticImgV,
                         secondImgV: mManualImgV )
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
    
    func initTransmission(firstBtn:UIButton, secondBtn: UIButton,
                          firstLb:UILabel, secondLb: UILabel, firstImgV:UIImageView, secondImgV: UIImageView) {
        firstBtn.backgroundColor = color_btn_pressed
        firstBtn.layer.borderWidth = 0.0
        firstLb.font = font_selected_filter
        firstLb.textColor = color_selected_filter_fields
        firstImgV.setTintColor(color: color_selected_filter_fields!)

        secondBtn.backgroundColor = .clear
        secondBtn.addBorder(color: color_navigationBar!, width: 1.0)
        secondLb.font = font_unselected_filter
        secondLb.textColor = color_entered_date
        secondImgV.setTintColor(color: color_exterior_tint!)

    }
    
    func getExteriorSizes() {
        searchResultModelView.getExteriorSizes { (exteriorList) in
            print(exteriorList)
            self.exteriorSizes = exteriorList
            self.mExteriorCollcetionV.reloadData()
        }
    }

    //MARK: ACTIONS
    @IBAction func manual(_ sender: UIButton) {
        initTransmission(firstBtn: mManualBtn,
                         secondBtn: mAutomaticBtn,
                         firstLb: mManualLb,
                         secondLb: mAutomaticLb,
                         firstImgV: mManualImgV,
                         secondImgV: mAutomaticImgV)
        
    }
    @IBAction func automatic(_ sender: UIButton) {
        initTransmission(firstBtn: mAutomaticBtn,
                         secondBtn: mManualBtn,
                         firstLb: mAutomaticLb,
                         secondLb: mManualLb,
                         firstImgV: mAutomaticImgV,
                         secondImgV: mManualImgV)
    }
    
  
}

extension FilterSearchResultCell: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mCarEquipmentCollectionV {
            return EquipmentData.equipmentModel.count
        }
        
        return exteriorSizes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mCarEquipmentCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarEquipmentCollectionViewCell.identifier, for: indexPath) as! CarEquipmentCollectionViewCell
            let equipmentModel: EquipmentModel = (EquipmentData.equipmentModel[indexPath.item])
            cell.setCellInfo(item: equipmentModel)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExteriorCollectionViewCell.identifier, for: indexPath) as! ExteriorCollectionViewCell
        guard let _ = exteriorSizes else { return cell }
        cell.mTitleLb.text = exteriorSizes![indexPath.row].getExterior()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = font_unselected_filter
        var size : CGSize = CGSize()
        size.height = collectionView.frame.height * 0.480519

       if collectionView == mCarEquipmentCollectionV {
            let equipmentModel: EquipmentModel = (EquipmentData.equipmentModel[indexPath.item])
            _ = equipmentModel.equipmentImg.size.height
            let widthInPoints = equipmentModel.equipmentImg.size.width
            let width = equipmentModel.equipmentName.size(OfFont: font!).width
            size.width =  width + widthInPoints + 60
            return size
        }

        let width = exteriorSizes![indexPath.item].getExterior().size(OfFont: font!).width
        size.width = width + 30
        return size
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell: UICollectionViewCell
        if collectionView == mCarEquipmentCollectionV {
             cell = collectionView.cellForItem(at: indexPath) as! CarEquipmentCollectionViewCell
            
        } else {
             cell = collectionView.cellForItem(at: indexPath) as! ExteriorCollectionViewCell
        }
        if cell.backgroundColor == .clear {
            cell.backgroundColor = color_btn_pressed
            cell.layer.borderWidth = 0.0
            if collectionView == mCarEquipmentCollectionV {
                (cell as! CarEquipmentCollectionViewCell).mImageV.setTintColor(color: color_selected_filter_fields!)
                (cell as! CarEquipmentCollectionViewCell).mTitleLb.font = font_selected_filter
                (cell as! CarEquipmentCollectionViewCell).mTitleLb.textColor = color_selected_filter_fields
            } else {
                (cell as! ExteriorCollectionViewCell).mTitleLb.textColor = color_selected_filter_fields
            }
        } else {
            cell.layer.borderWidth = 1.0
            cell.backgroundColor = .clear
            if collectionView == mCarEquipmentCollectionV {
                (cell as! CarEquipmentCollectionViewCell).mImageV.setTintColor(color: color_exterior_tint!)
                (cell as! CarEquipmentCollectionViewCell).mTitleLb.font = font_unselected_filter
                (cell as! CarEquipmentCollectionViewCell).mTitleLb.textColor = color_filter_fields
            } else {
                (cell as! ExteriorCollectionViewCell).mTitleLb.textColor = color_filter_fields
            
            }
        }
    }
}


extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

