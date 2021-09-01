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
    public var vehicleName: String?
    public var vehicleType: String?
    public var vehicleImg: UIImage?
    public var vehicleLogo: UIImage?
    public var ifHasTowBar: Bool = false
    public var vehicleValue: Double = 0.0
    public var vehicleOffertValue: Double = 0.0
    public var vehicleDiscountValue: Double = 0.0

    //Vehicle general short info
    public var drivingLicense: String?
    public var vehicleCube: String?
    public var vehicleWeight: String?
    public var vehicleSize: String?

    public var ifTailLift: Bool = false
    public var ifHasAccessories: Bool = false
    public var ifHasAditionalDriver: Bool = false
    
    public var accessoriesTotalPrice: Double = 0.0
    public var driversTotalPrice: Double = 0.0
    public var customLocationTotalPrice: Double = 0.0
    public var noWorkingTimeTotalPrice: Double = 0.0

    public var tailLiftList: [TailLiftModel]?
    public var detailList: [DetailsModel]?
    public var searchModel: SearchModel?
    public var additionalAccessories: [AccessoriesModel]?
    public var additionalDrivers: [MyDriversModel]?
    public var images: [CarImageResponse]?
    public var carImagesList:[UIImage]?
}

