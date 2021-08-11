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
    
    
    @IBAction func mSwitch(_ sender: Any) {
    }
    
    let mainViewModel: MainViewModel = MainViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
     
        // corner radius
        mInfoBckV.layer.cornerRadius = 10
        mValueBckV.clipsToBounds = true
        mValueBckV.layer.cornerRadius = 10
        mValueBckV.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        // shadow
        mInfoBckV.setShadow(color: color_shadow!)
        
        //gradient
        mValueBckV.setGradient(startColor: UIColor(named:"gradient_start")!, endColor: UIColor(named:"gradient_end")!)
        
        
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
        vehicleModel.vehicleDesctiption = "Double cabin"
        vehicleModel.vehicleImg = mCarImgV.image
        vehicleModel.drivingLicense = mCardLb.text
        vehicleModel.vehicleCube = mCubeLb.text
        vehicleModel.vehicleWeight = mKgLb.text
        vehicleModel.vehicleSize = mCarSizeLb.text
        vehicleModel.ifTailLift = carModel.tailgate
        vehicleModel.ifHasAccessories = false
        vehicleModel.ifHasAditionalDriver = false
        let price: Double = mOffertBackgV.isHidden ? (mValueLb.text!  as NSString).doubleValue : (mOffertPriceLb.text!  as NSString).doubleValue
        vehicleModel.vehicleValue = price
        
        if vehicleModel.ifTailLift  {
            vehicleModel.tailLiftList = mainViewModel.getTailLiftList(carModel: carModel)
        }
        vehicleModel.detailList = mainViewModel.getDetail(carModel: carModel)
        return vehicleModel
    }
    
    override func prepareForReuse() {
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
    }
    
    /// Set cell info
    func setCellInfo(item: CarsModel) {
        UIImage.loadFrom(url: item.image.getURL()!) { image in
            self.mCarImgV.image = image
        }
        mCarNameLb.text = item.name
        mCardLb.text = item.driverLicenseType
        mCubeLb.text = String(item.volume) + "m²"
        mKgLb.text = String(item.loadCapacity) + Constant.Texts.m
        mCarSizeLb.text = String(item.liftingCapacityTailLift) + "x" + String(item.tailLiftLength) + "x" + String(item.heightOfLoadingFloor) + Constant.Texts.m
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
    }

}

/*
{
           "id": "606078d06ab52e76c71ec7b3",
           "name": "Ducato Koelwagen",
           "vendor": "Ducato",
           "model": "Koelwagen",
           "volume": 16.5,
           "loadCapacity": 499.0,
           "interior": null,
           "exterior": null,
           "type": "607c83fab223c86a33f6503a",
           "image": {
               "id": "14122AFE1F760709174A3F2B166B05ABE0658A36E274E1DDC5CC3047E7A7951DD64C0AA887918A7978C2C4A5C848E404",
               "node": "dev-node1"
           },
           "driverLicenseType": "B",
           "price": 99.8,
           "hasSpecialPrice": false,
           "specialPrice": null,
           "seats": 0,
           "fuel": null,
           "transmission": null,
           "motor": 0.0,
           "euroNorm": 0,
           "withBetweenWheels": 0.0,
           "airConditioning": false,
           "towbar": false,
           "sideDoor": false,
           "tailgate": false,
           "liftingCapacityTailLift": 0.0,
           "tailLiftLength": 0.0,
           "heightOfLoadingFloor": 0.0,
           "active": true,
           "inRent": false,
           "reservations": {
               "785046be-2296-40bb-a678-6cff41e74fa8": {
                   "start": 1617645253518,
                   "end": 1618250053518
               }
           },
           "gpsnavigator": false
       },
*/
