////
////  CarResult.swift
////  CarResult
////
////  Created by Karine Karapetyan on 12-10-21.
////
//
//import UIKit
//
//struct CarResult {
//    
//    let id: String
//    let name: String
//    let vendor: String
//    let model: String
//    let volume: Double
//    let loadCapacity: Double
//    let type: String
//    let driverLicenseType: String
//    
//    
//    //Prices
//    let priceForFlexible: Double
//    let priceHour: PriceResult?
//    let priceDay: PriceResult?
//    let priceWeek: PriceResult?
//    let priceMonth: PriceResult?
//    let hasDiscount: Bool
//    let discountPercents: Double
//    let freeKiloMeters: Double
//    let depositPrice: Double
//    let priceForKm: Double
//    
//    
//    //Detail
//    let seats: Double
//    let fuel: String?
//    let transmission: String?
//    let motor: Double
//    let euroNorm: Double
//    let withBetweenWheels: Double
//    let airConditioning: Bool
//    let sideDoor: Bool
//    let GPSNavigator:Bool
//    let exterior: String?
//    
//    //Tail lift
//    let tailgate: Bool
//    let liftingCapacityTailLift: Double
//    let tailLiftLength: Double
//    let heightOfLoadingFloor: Double
//    
//    let towbar: Bool
//    let active: Bool
//    let inRent: Bool
//    let image: UIImage
//    let images: [CarImageResponse]?
//    let logo: UIImage?
//    let reservations: Reservation?
//    let supportedAccessories: [String]?
//    
//    init(car: CarsModel) {
//        self.id = car.id
//        self.name = car.name
//        self.vendor = car.vendor
//        self.model = car.model
//        self.volume = car.volume
//        self.loadCapacity = car.loadCapacity
//        self.type = car.type
//        self.driverLicenseType = car.driverLicenseType
//        //Prices
//        self.priceForFlexible = car.priceForFlexible
//        self.priceHour = PriceResult.init(price: car.priceHour!)
//        self.priceDay = PriceResult.init(price: car.priceDay!)
//        self.priceWeek = PriceResult.init(price: car.priceWeek!)
//        self.priceMonth = PriceResult.init(price: car.priceMonth!)
//
//        self.hasDiscount = car.hasDiscount
//        self.discountPercents = car.discountPercents
//        self.freeKiloMeters = car.freeKiloMeters
//        self.depositPrice = car.depositPrice
//        self.priceForKm = car.priceForKm
//        
//        //Detail
//        self.seats = car.seats
//        self.fuel = car.fuel
//        self.transmission = car.transmission
//        self.motor = car.motor
//        self.euroNorm = car.euroNorm
//        self.withBetweenWheels = car.withBetweenWheels
//        self.airConditioning = car.airConditioning
//        self.sideDoor = car.sideDoor
//        self.GPSNavigator = car.GPSNavigator
//        self.exterior = car.exterior?.getExterior()
//        
//        //Tail lift
//        self.tailgate = car.tailgate
//        self.liftingCapacityTailLift = car.liftingCapacityTailLift
//        self.tailLiftLength = car.tailLiftLength
//        self.heightOfLoadingFloor = car.heightOfLoadingFloor
//        
//        self.towbar = car.towbar
//        self.active = car.active
//        self.inRent = car.inRent
//        self.image.sd_setImage(with:car.image?.getURL(), placeholderImage: nil)
//        self.images = car.images
//        self.logo.sd_setImage(with:car.logo?.getURL(), placeholderImage: nil)
//        self.reservations = car.reservations
//        self.supportedAccessories = car.supportedAccessories
//        
//        
//        
//    }
//}
//
//
//struct PriceResult {
//    
//    var price: Double?
//    var hasSpecialPrice: Bool?
//    var specialPrice: Double?
//    init(price: Price) {
//        self.price = price.price
//        self.hasSpecialPrice = price.hasSpecialPrice
//        self.specialPrice = price.specialPrice
//    }
//}
//
//
//
