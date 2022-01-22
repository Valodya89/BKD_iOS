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
}

