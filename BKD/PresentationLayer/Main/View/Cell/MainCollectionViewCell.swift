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
    
    @IBAction func mSwitch(_ sender: Any) {
    }
    
    let mainViewModel: MainViewModel = MainViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
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
        vehicleModel.vehicleName = mCarNameLb.text
        vehicleModel.ifHasTowBar = true
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

        let carType = ApplicationSettings.shared.carTypes?.filter{
              $0.id == carModel.type
      }
        vehicleModel.vehicleType = carType?.first?.name
        
        let price: Double = mOffertBackgV.isHidden ? (mValueLb.text!  as NSString).doubleValue : (mOffertPriceLb.text!  as NSString).doubleValue
        vehicleModel.vehicleValue = price
        
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
        mOffertBackgV.isHidden = false
        mIgnorValueContentV.isHidden = false
        mValueBckgV.isHidden = false
        mIgnorValueLb.text = ""
        mOffertPriceLb.text = ""
        mValueLb.text = ""
        mTowBarLb.isHidden = false
        mTowBarIngV.isHidden = false
        mInactiveCarNameLb.isHidden = true
        mBlurV.isHidden = true
    }
    
    /// Set cell info
    func setCellInfo(item: CarsModel) {
        self.mCarImgV.sd_setImage(with:item.image.getURL()!, placeholderImage: nil)
       // mCarImgV.kf.setImage(with: item.image.getURL()!)
        mCarNameLb.text = item.name
        mCardLb.text = item.driverLicenseType
        mCubeLb.text = String(item.volume) + Constant.Texts.mCuadrad
        mKgLb.text = String(item.loadCapacity) + Constant.Texts.kg
        mCarSizeLb.text = item.exterior?.getExterior()
        mOffertBackgV.isHidden = !item.hasSpecialPrice
        mIgnorValueContentV.isHidden = !item.hasSpecialPrice
        mValueBckgV.isHidden = item.hasSpecialPrice
        if item.hasSpecialPrice {
            mIgnorValueLb.text = "€  \(item.price) / " + Constant.Texts.day
            mOffertPriceLb.text = String(item.specialPrice ?? 0.0)
        } else {
            mValueLb.text = String(item.price)
        }
        mTowBarLb.isHidden = !item.towbar
        mTowBarIngV.isHidden = !item.towbar
        mBlurV.isHidden = item.active
        mInactiveCarNameLb.isHidden = item.active
        mInactiveCarNameLb.text = item.name
        
        if item.logo != nil {
            mFiatImgV.sd_setImage(with:item.logo!.getURL()!, placeholderImage: nil)
          //  mFiatImgV.kf.setImage(with: (item.logo!.getURL() ?? URL(string: ""))!)

//            UIImage.loadFrom(url: (item.logo!.getURL() ?? URL(string: ""))!) { image in
//                self.mFiatImgV.image = image ?? UIImage()
//            }
        }
        guard let start = item.reservations?.getStart(), let end = item.reservations?.getEnd()  else { return }
        let isActiveCar: Bool = mainViewModel.isCarActiveNow(start: start, end: end)
        mBlurV.isHidden = isActiveCar
        mInactiveCarNameLb.isHidden = isActiveCar
        
    }

}

