//
//  CompareVehicleInfoView.swift
//  CompareVehicleInfoView
//
//  Created by Karine Karapetyan on 06-10-21.
//

import UIKit

protocol CompareVehicleInfoViewDelegate: AnyObject {
    func didSelectMore(carModel: CarsModel)
}

class CompareVehicleInfoView: UIView {

    //MARK: -- Outlets
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mTowBarContentV: UIView!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarTypeLb: UILabel!
    @IBOutlet weak var mDetailsTableV: DetailsTableView!
    
    @IBOutlet weak var mStartingLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mMoreInfoBtn: UIButton!
    @IBOutlet weak var mShadowContentV: UIView!
   
    //MARK: -- Variables
    let compareViewModel = CompareViewModel()
    public var carModel:CarsModel?
    weak var delegate: CompareVehicleInfoViewDelegate?
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
         super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mShadowContentV.layer.cornerRadius = 3
        mShadowContentV.setShadow(color: color_shadow!)
        mMoreInfoBtn.layer.cornerRadius = 8
        mMoreInfoBtn.setBorder(color: color_menu!, width: 1.0)
        configureUI()
    }
    
    ///Configure UI
    func configureUI() {
        mDetailsTableV.layer.borderWidth = 0.0
        guard let car = carModel else {return}
        mCarImgV.sd_setImage(with:car.image.getURL()!, placeholderImage: nil)
        mCarNameLb.text = car.name
        mCarTypeLb.text = compareViewModel.getCarTypeName(carModel: car)
        mTowBarContentV.isHidden = !car.towbar
        mPriceLb.text = String(car.priceForHour)
        mDetailsTableV.detailList = compareViewModel.getCarInfoList(carModel: car)
        mDetailsTableV.reloadData()
    }
    
    //MARK: -- Actions
    @IBAction func moreInfo(_ sender: UIButton) {
        delegate?.didSelectMore(carModel:carModel!)
    }
    
}
