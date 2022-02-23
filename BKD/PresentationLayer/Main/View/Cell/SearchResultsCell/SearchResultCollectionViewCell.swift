//
//  SearchResultCollectionViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-05-21.
//

import UIKit
import SDWebImage

protocol SearchResultCellDelegate: AnyObject {
    func didPressMore(tag: Int)
    func didPressReserve(tag: Int)
}

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var mCarMarkaBckgV: UIView!
    @IBOutlet weak var mInfoV: UIView!
    @IBOutlet weak var mflipBtn: UIButton!
    @IBOutlet weak var mDetailsBtn: UIButton!
    @IBOutlet weak var mDetailsUnderLineV: UIView!
    
    @IBOutlet weak var mCarLogoImgV: UIImageView!
    @IBOutlet weak var mCarNameLb: UILabel!
    
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mGradientEuroLb: UILabel!
    @IBOutlet weak var mGradientValueLb: UILabel!
    
    @IBOutlet weak var mOffertBckgV: UIView!
    @IBOutlet weak var mOffertImgV: UIImageView!
    @IBOutlet weak var mOffertValueLB: UILabel!
    @IBOutlet weak var mOffertEuroLb: UILabel!
    @IBOutlet weak var mValueLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mValueDeleteV: UIView!
    
    @IBOutlet weak var mMoreInfoBtn: UIButton!
    @IBOutlet weak var mReserveBtn: UIButton!
    
    @IBOutlet weak var mFlipReserveBtn: UIButton!
    @IBOutlet weak var mFlipMoreInfoBtn: UIButton!
    
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mFlipInfoV: UIView!
    
    @IBOutlet var mCardImgV: UIImageView!
    @IBOutlet var mCubeImgV: UIImageView!
    @IBOutlet var mKgImgV: UIImageView!
    @IBOutlet var mMetrImgV: UIImageView!
    @IBOutlet weak var mFlipCarLogoImgV: UIImageView!
    @IBOutlet weak var mFlipCarNameLb: UILabel!
    
    @IBOutlet var mCardLb: UILabel!
    @IBOutlet var mCubeLb: UILabel!
    @IBOutlet var mKgLb: UILabel!
    @IBOutlet var mMetrLb: UILabel!
    @IBOutlet weak var containerV: UIView!
    
    @IBOutlet weak var mInactiveCarNameLb: UILabel!
    @IBOutlet weak var mVisualEffectV: UIVisualEffectView!
    @IBOutlet weak var mVidualGradientV: UIView!
    @IBOutlet weak var mCarImageViewCenterY: NSLayoutConstraint!
    
  lazy var mainViewModel = MainViewModel()
    weak var delegate:SearchResultCellDelegate?
    var startRendDate: Date?
    var endRendtDate: Date?
    
    private var isFlipView: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mVidualGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
    }
    
    func setupView() {
        // corner radius
        mInfoV.layer.cornerRadius = 10
        mFlipInfoV.layer.cornerRadius = 10

        // shadow
        mInfoV.setShadow(color:  color_shadow!)
        mFlipInfoV.setShadow(color:  color_shadow!)
        
        initButtons(btn: mMoreInfoBtn)
        initButtons(btn: mReserveBtn)
        initButtons(btn: mFlipMoreInfoBtn)
        initButtons(btn: mFlipReserveBtn)
        
        mVisualEffectV.clipsToBounds = true
        mVisualEffectV.layer.cornerRadius = 10
        
        //gradient
       // mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
                
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)
    }
    
    override func prepareForReuse() {
        
        mCarNameLb.text = ""
        mFlipCarNameLb.text = ""
        mCarLogoImgV.image = UIImage()
        mFlipCarLogoImgV.image = UIImage()
        mGradientV.isHidden = false
        mOffertBckgV.isHidden = true
        initButtons(btn: mMoreInfoBtn)
        initButtons(btn: mReserveBtn)
        initButtons(btn: mFlipMoreInfoBtn)
        initButtons(btn: mFlipReserveBtn)
    }
    
    func initButtons(btn:UIButton) {
        btn.addBorder(color: color_btn_pressed!, width: 1.0)
        btn.layer.cornerRadius = 8
    }
    
    ///Set  values to vehicle model
    func setVehicleModel(carModel: CarsModel, search: SearchModel?) -> VehicleModel {
        
         var vehicleModel = VehicleModel()
        vehicleModel.searchModel = search
         vehicleModel.vehicleId = carModel.id
        vehicleModel.vehicleName = carModel.name
        vehicleModel.ifHasTowBar = true
        vehicleModel.vehicleImg = mCarImgV.image
        vehicleModel.drivingLicense = mCardLb.text
        vehicleModel.vehicleCube = mCubeLb.text
        vehicleModel.vehicleWeight = mKgLb.text
        vehicleModel.vehicleSize = mMetrLb.text
        vehicleModel.ifTailLift = carModel.tailgate
        vehicleModel.ifHasAccessories = false
        vehicleModel.ifHasAditionalDriver = false
        vehicleModel.vehicleLogo = mCarLogoImgV.image
        vehicleModel.vehicleImg = mCarImgV.image
        vehicleModel.images = carModel.images
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

 
    // Set Search result cell info
    func setSearchResultCellInfo(item: CarsModel, index: Int) {
        mMoreInfoBtn.tag = index
        mFlipMoreInfoBtn.tag = index
        mReserveBtn.tag = index
        mFlipReserveBtn.tag = index
        mMoreInfoBtn.addTarget(self, action: #selector(moreInfoPressed(sender:)), for: .touchUpInside)
        mFlipMoreInfoBtn.addTarget(self, action: #selector(moreInfoPressed(sender:)), for: .touchUpInside)
        mReserveBtn.addTarget(self, action: #selector(reservePressed), for: .touchUpInside)
        mFlipReserveBtn.addTarget(self, action: #selector(reservePressed), for: .touchUpInside)
        
        if item.logo != nil {
            self.mCarLogoImgV.sd_setImage(with: item.logo!.getURL() ?? URL(string: ""), placeholderImage: nil)
            self.mFlipCarLogoImgV.sd_setImage(with: item.logo!.getURL() ?? URL(string: ""), placeholderImage: nil)
        }
        
        if item.priceDay != nil && item.hasDiscount &&  item.discountPercents > 0.0 {
            
            let specialPrice = item.priceDay! - (item.priceDay! * (item.discountPercents/100))
            self.mOffertValueLB.text = String(specialPrice) + Constant.Texts.inclVat
            self.mValueLb.text = String(item.priceDay!) + Constant.Texts.inclVat
        } else {
            self.mGradientValueLb.text = String(item.priceDay!) + Constant.Texts.inclVat
        }
        
        self.mCarNameLb.text = item.name
        self.mFlipCarNameLb.text = item.name
        
        self.mCarImgV.sd_setImage(with: item.image.getURL()!, placeholderImage: nil)
        self.mOffertBckgV.isHidden = !(item.hasDiscount)
        self.mGradientV.isHidden = (item.hasDiscount)
        self.mCardLb.text = item.driverLicenseType
        self.mCubeLb.text = String(item.volume) + Constant.Texts.mCuadrad
        self.mKgLb.text = String(item.loadCapacity) + Constant.Texts.kg
        
        self.mMetrLb.text = item.exterior?.getExterior()
        mInactiveCarNameLb.text = item.name
        
        let isActiveCar: Bool = SearchResultModelView().isCarAvailable(reservation: item.reservations,  currRentStart:  startRendDate!,
                              currRentEnd:  endRendtDate)
        self.mVisualEffectV.isHidden = isActiveCar
        self.mInactiveCarNameLb.isHidden = isActiveCar
        self.isUserInteractionEnabled = isActiveCar
        

    }
    
    
    @objc func moreInfoPressed(sender: UIButton) {
        delegate?.didPressMore(tag: sender.tag)
    }
    
    @objc func reservePressed (sender: UIButton) {
        delegate?.didPressReserve(tag: sender.tag)
    }
    
    //MARK: ACTIONS
    @IBAction func details(_ sender: UIButton) {
        if isFlipView {
            UIView.transition(with: mFlipInfoV, duration: 0.5, options: [.transitionFlipFromRight], animations: {
                
            }) { [self]_ in
                UIView.animate(withDuration: 0.7) {
                    self.mInfoV.isHidden = !self.mInfoV.isHidden
                    self.mFlipInfoV.isHidden = !self.mFlipInfoV.isHidden
                    self.mInfoV.alpha = 1
                    self.mFlipInfoV.alpha = 0
                    self.mCarImageViewCenterY.constant = 0
                    self.layoutIfNeeded()
                }
            }
        } else {
            UIView.transition(with: mInfoV, duration: 0.5 , options: [.transitionFlipFromLeft], animations: nil) { [self]_ in
                UIView.animate(withDuration: 0.7) {
                    self.mInfoV.isHidden = !self.mInfoV.isHidden
                    self.mFlipInfoV.isHidden = !self.mFlipInfoV.isHidden
                    self.mFlipInfoV.alpha = 1
                    self.mInfoV.alpha = 0
                    self.mCarImageViewCenterY.constant = -20
                    self.layoutIfNeeded()
                }
            }
        }
        isFlipView = !isFlipView
       
    }
    
    @IBAction func moreInfo(_ sender: UIButton) {
        mMoreInfoBtn.setClickColor(color_btn_pressed!, titleColor: color_navigationBar!)
        mFlipMoreInfoBtn.setClickColor(color_btn_pressed!, titleColor: color_navigationBar!)
//        mMoreInfoBtn.backgroundColor = color_btn_pressed
//        mFlipMoreInfoBtn.backgroundColor = color_btn_pressed
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        mReserveBtn.setClickTitleColor(color_email!)
        mFlipReserveBtn.setClickTitleColor(color_email!)
//        mReserveBtn.backgroundColor = color_btn_pressed
//        mFlipReserveBtn.backgroundColor = color_btn_pressed

    }
}


