//
//  DetailsModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit


struct CarModel {
    public var carImage: UIImage
}

struct VehicleModel {
    public var vehicleId: String?
    public var vehicleName: String?
    public var vehicleType: String?
    public var vehicleImg: UIImage?
    public var vehicleLogo: UIImage?
    public var vehicleImgUrl: URL?
    public var vehicleLogoURL: URL?
    public var ifHasTowBar: Bool = false
    public var vehicleOffertValue: Double = 0.0
    public var vehicleDiscountValue: Double = 0.0
    
    //Prices
    public var priceForFlexible: Double = 0.0
    public var priceHour: Double?
    public var priceDay: Double?
    public var priceWeek: Double?
    public var priceMonth: Double?
    public var hasDiscount: Bool = false
    public var discountPercents: Double = 0.0
    public var freeKiloMeters: Double = 0.0
    
    public var depositPrice: Double = 0.0
    public var totalPrice: Double = 0.0
    public var priceForKm: Double = 0.0

    //Vehicle general short info
    public var drivingLicense: String?
    public var vehicleCube: String?
    public var vehicleWeight: String?
    public var vehicleSize: String?

    public var ifTailLift: Bool = false
    public var ifHasAccessories: Bool = false
    public var ifHasAditionalDriver: Bool = false
    
//    public var accessoriesTotalPrice: Double = 0.0
//    public var driversTotalPrice: Double = 0.0

    public var tailLiftList: [TailLiftModel]?
    public var detailList: [DetailsModel]?
    public var searchModel: SearchModel?
    public var additionalAccessories: [AccessoriesEditModel]?
    public var additionalDrivers: [MyDriversModel]?
    public var images: [CarImageResponse]?
    public var carImagesList:[UIImage]?
    
    public var rent: Rent?
    
    
    mutating func setVehicle(car: CarsModel)  {
        self.vehicleId = car.id
        self.vehicleName = car.name
        self.vehicleType = car.type
        self.vehicleImgUrl = car.image.getURL()
        self.vehicleLogoURL = car.logo?.getURL()
        
        let data = try? Data(contentsOf: ((car.image.getURL() ?? URL(string: ""))!)) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        self.vehicleImg = UIImage(data: data!)
        self.ifHasTowBar = car.towbar
       // self.vehicleOffertValue =
       // self.vehicleDiscountValue =
        
        //Prices
        self.priceForFlexible = car.priceForFlexible
        self.priceHour = car.priceHour
        self.priceDay = car.priceDay
        self.priceWeek = car.priceWeek
        self.priceMonth = car.priceMonth
        self.hasDiscount = car.hasDiscount
        self.discountPercents = car.discountPercents
        self.freeKiloMeters = car.freeKiloMeters
        self.depositPrice = car.depositPrice
        //self.totalPrice =
        self.priceForKm = car.priceForKm
        
        //Vehicle general short info
        self.drivingLicense = car.driverLicenseType
        self.vehicleCube = String(car.volume) + Constant.Texts.mCuadrad
        self.vehicleWeight = String(car.loadCapacity) + Constant.Texts.kg
        self.vehicleSize = car.exterior?.getExterior()
        
        self.ifTailLift = car.tailgate
        let mainVM = MainViewModel()
        if self.ifTailLift  {
            self.tailLiftList = mainVM.getTailLiftList(carModel: car)
        }
        self.detailList = mainVM.getDetail(carModel: car)
        self.images = car.images
    }
}

