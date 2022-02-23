//
//  MainCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 07-05-21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
static let identifier = "MainCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK: -- Outlets
    @IBOutlet weak var mOffertPriceLb: UILabel!
    @IBOutlet weak var mInfoBckV: UIView!
    @IBOutlet weak var mOffertBackgV: UIView!
    @IBOutlet weak var mValueBckV: UIView!
    
    @IBOutlet weak var mIgnorValueContentV: UIView!
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mCardImgV: UIImageView!
    @IBOutlet weak var mCubeImgV: UIImageView!
    @IBOutlet weak var mKgImgV: UIImageView!
    @IBOutlet weak var mCarSizeImgV: UIImageView!
    @IBOutlet weak var mOffertImgV: UIImageView!
    @IBOutlet weak var mFiatImgV: UIImageView!
    @IBOutlet weak var mTowBarIngV: UIImageView!
    
    @IBOutlet weak var mDeleteLineV: UIView!
    @IBOutlet weak var mCardLb: UILabel!
    @IBOutlet weak var mCubeLb: UILabel!
    @IBOutlet weak var mKgLb: UILabel!
    @IBOutlet weak var mCarNameLb: UILabel!
    @IBOutlet weak var mCarSizeLb: UILabel!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mIgnorValueLb: UILabel!
    
    @IBOutlet weak var mValueBckgV: UIView!
    @IBOutlet weak var mValueLb: UILabel!
    @IBOutlet weak var mValueDayLb: UILabel!
    @IBOutlet weak var mBlurV: UIVisualEffectView!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mInactiveCarNameLb: UILabel!
    
    //MARK: -- Variable
    let mainViewModel: MainViewModel = MainViewModel()
    
    //MARK: -- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mValueBckV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mValueBckV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
    }
    
    func setup() {
        // corner radius
        mInfoBckV.layer.cornerRadius = 10
        mValueBckV.clipsToBounds = true
        mValueBckV.layer.cornerRadius = 10
        mBlurV.clipsToBounds = true
        mBlurV.layer.cornerRadius = 10
        mValueBckV.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        // shadow
        mInfoBckV.setShadow(color: color_shadow!)
        
        //gradient
        mValueBckV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        
        let amountText = NSMutableAttributedString.init(string: mValueLb.text!)

        // set the custom font and color for the 0,1 range in string
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                  NSAttributedString.Key.foregroundColor: UIColor(named: "value") as Any],
                                     range: NSMakeRange(0, 1))
        mValueLb.attributedText = amountText
        
    }

    ///Set  values to vehicle model
     func setVehicleModel(carModel: CarsModel) -> VehicleModel {
        var vehicleModel = VehicleModel()
        vehicleModel.vehicleId = carModel.id
        vehicleModel.vehicleName = mCarNameLb.text
         vehicleModel.ifHasTowBar = carModel.towbar
        vehicleModel.vehicleImg = mCarImgV.image
        vehicleModel.drivingLicense = mCardLb.text
        vehicleModel.vehicleCube = mCubeLb.text
        vehicleModel.vehicleWeight = mKgLb.text
        vehicleModel.vehicleSize = mCarSizeLb.text
        vehicleModel.ifTailLift = carModel.tailgate
        vehicleModel.ifHasAccessories = false
        vehicleModel.ifHasAditionalDriver = false
        vehicleModel.vehicleLogo = mFiatImgV.image
        vehicleModel.vehicleImg = mCarImgV.image
        vehicleModel.images = carModel.images
        vehicleModel.reservations = carModel.reservations
         
        let carType = ApplicationSettings.shared.carTypes?.filter{
              $0.id == carModel.type
      }
        vehicleModel.vehicleType = carType?.first?.name
        
         //set Price
         vehicleModel.priceForFlexible = carModel.priceForFlexible
         vehicleModel.priceHour = carModel.priceHour
         vehicleModel.priceDay = carModel.priceDay
         vehicleModel.priceWeek = carModel.priceWeek
         vehicleModel.priceMonth = carModel.priceMonth
         vehicleModel.depositPrice = carModel.depositPrice
         vehicleModel.priceForKm = carModel.priceForKm
         vehicleModel.hasDiscount = carModel.hasDiscount
         vehicleModel.discountPercents = carModel.discountPercents
         vehicleModel.freeKiloMeters = carModel.freeKiloMeters
         
        if vehicleModel.ifTailLift  {
            vehicleModel.tailLiftList = mainViewModel.getTailLiftList(carModel: carModel)
        }
        vehicleModel.detailList = mainViewModel.getDetail(carModel: carModel)
        return vehicleModel
    }
    
    override func prepareForReuse() {
        
        //gradient
        mValueBckV.setGradient(startColor: color_gradient_start!, endColor: color_gradient_end!)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
        mCarImgV.image = nil
        mCarNameLb.text = ""
        mCardLb.text = ""
        mCubeLb.text = ""
        mKgLb.text = ""
        mCarSizeLb.text = ""
        mOffertBackgV.isHidden = true
        mDeleteLineV.isHidden = true
        mValueBckgV.isHidden = false
        mIgnorValueLb.text = ""
        mOffertPriceLb.text = ""
        mValueLb.text = ""
        mTowBarLb.isHidden = false
        mTowBarIngV.isHidden = false
        mInactiveCarNameLb.isHidden = true
        mBlurV.isHidden = true
        mIgnorValueContentV.isHidden = true

    }
    
    /// Set cell info
    func setCellInfo(item: CarsModel) {
        self.mCarImgV.sd_setImage(with:item.image.getURL()!, placeholderImage: nil)
        mCarNameLb.text = item.name
        mCardLb.text = item.driverLicenseType
        mCubeLb.text = String(item.volume) + Constant.Texts.mCuadrad
        mKgLb.text = String(item.loadCapacity) + Constant.Texts.kg
        mCarSizeLb.text = item.exterior?.getExterior()
        updatePriceFiled(item:item)

        mTowBarLb.isHidden = !item.towbar
        mTowBarIngV.isHidden = !item.towbar
        mBlurV.isHidden = item.active
        mInactiveCarNameLb.isHidden = item.active
        mInactiveCarNameLb.text = item.name
        
        if item.logo != nil {
            mFiatImgV.sd_setImage(with:item.logo!.getURL()!, placeholderImage: nil)
        }
                
        let isActiveCar: Bool = mainViewModel.isCarActiveNow(reservation: item.reservations)
        mBlurV.isHidden = isActiveCar
        mInactiveCarNameLb.isHidden = isActiveCar  
    }
    
    
    func updatePriceFiled(item: CarsModel) {
        
        if item.hasDiscount == true &&
            item.priceDay != nil{
            
            let specialPrice = item.priceDay! - (item.priceDay! * (item.discountPercents/100))
            mOffertPriceLb.text = String(format: "%.2f", specialPrice)
            mOffertBackgV.isHidden = false
            
            mIgnorValueContentV.isHidden = false
            mIgnorValueLb.text = "€  \(item.priceDay!) / " + Constant.Texts.day
            mValueBckgV.isHidden = true
            
        } else {
            
            mValueLb.text = String(item.priceDay ?? 0.0)
            mValueBckgV.isHidden = false
            
            mOffertBackgV.isHidden = true
            mIgnorValueContentV.isHidden = true
        }
    }

}

