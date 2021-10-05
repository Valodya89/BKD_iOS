//
//  Car.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-07-21.
//

import UIKit
//result.first?.reservations?.innerArray.first?.value.start
//result.first?.reservations?.innerArray.first?.value.end
struct CarsModel: Codable {
    
    
    let id: String
    let name: String
    let vendor: String
    let model: String
    let volume: Double
    let loadCapacity: Double
    let type: String
    let driverLicenseType: String
    
    
    //Prices
    let depositPrice: Double
    let priceForHour: Double
    let priceForDay: Double
    let priceForWeek: Double
    let priceForMonth: Double
    let hasSpecialPrice: Bool
    let specialPriceForHour: Double
    let specialPriceForDay: Double
    let specialPriceForWeek: Double
    let specialPriceForMonth: Double
    let priceForKm: Double
    let priceForFuelIncluded: Double
    
    //Detail
    let seats: Double
    let fuel: String? //from base come null
    let transmission: String? ////from base come null
    let motor: Double
    let euroNorm: Double
    let withBetweenWheels: Double
    let airConditioning: Bool
    let sideDoor: Bool
    let GPSNavigator:Bool
    let exterior: CarExterior?
    
    //Tail lift
    let tailgate: Bool
    let liftingCapacityTailLift: Double
    let tailLiftLength: Double
    let heightOfLoadingFloor: Double
    
    let towbar: Bool
    let active: Bool
    let inRent: Bool
    let image: CarImageResponse
    let images: [CarImageResponse]?
    let logo: Logo?
    let reservations: Reservation?
    let supportedAccessories: [String]?
    
    
    
    
   
    
}

struct CarImageResponse: Codable {
    let id: String
    let node: String
    
    func getURL() -> URL? {
        //guard let id = id, let node = node else { return nil }
        let avatar = "https://\(node).bkdrental.com/files?id=\(id)"
        
        return URL(string: avatar)
    }
}

struct Logo: Codable{
    let id: String
    let node: String
    
    func getURL() -> URL? {
        let avatar = "https://\(node).bkdrental.com/files?id=\(id)"
        return URL(string: avatar)
    }
}

struct CarExterior: Codable {
    let length: Double
    let width: Double
    let height: Double
    
    func getExterior() -> String {
        return "\(length)x\(width)x\(height)\(Constant.Texts.m)"
    }
}


struct Reservation: Codable {
        public var innerArray: [String: Inner]
        
        public struct Inner: Codable {
            public let start: Double
            public let end: Double
        }
        
        private struct CustomCodingKeys: CodingKey {
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            var intValue: Int?
            init?(intValue: Int) {
                return nil
            }
        }
    
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CustomCodingKeys.self)
            
            self.innerArray = [String: Inner]()
            for key in container.allKeys {
                let value = try container.decode(Inner.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
                self.innerArray[key.stringValue] = value
            }
        }
    
    func  getStart() -> Date {
           
            let start = (innerArray.first?.value.start)!
            let epocTime = TimeInterval(start / 1000)
            let date = NSDate(timeIntervalSince1970: epocTime)
            print("Converted Time \(date)")
            return date as Date
        }
    
    func  getEnd() -> Date {
        let end = innerArray.first?.value.end
        let epocTime = TimeInterval(end! / 1000)
        let date = NSDate(timeIntervalSince1970: epocTime)
        print("Converted Time \(date)")
        return date as Date
    }
}


