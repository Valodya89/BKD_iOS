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
    public var vehicleDesctiption: String?
    public var vehicleImg: UIImage?
    public var ifHasTowBar: Bool = false
    public var vehicleValue: Double?
    
    //Vehicle general short info
    public var drivingLicense: String?
    public var vehicleCube: String?
    public var vehicleWeight: String?
    public var vehicleSize: String?

    public var ifTailLift: Bool = false
    public var ifHasAccessories: Bool = false
    public var ifHasAditionalDriver: Bool = false

}

