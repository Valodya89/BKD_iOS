//
//  Car.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-07-21.
//

import UIKit

struct CarsModel: Decodable {
    
    
    let id: String
    let name: String
    let vendor: String
    let model: String
    let volume: Double
    let loadCapacity: Double
    
    let driverLicenseType: String
    let price: Double
    let hasSpecialPrice: Bool
    let specialPrice: Double?
    
    //Detail
    let seats: Double
    let fuel: String? //from base come null
    let transmission: String? ////from base come null
    let motor: Double
    let euroNorm: Double
    let withBetweenWheels: Double
    let airConditioning: Bool
    let sideDoor: Bool
    let gpsnavigator:Bool
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
    
    
}

struct CarImageResponse: Decodable {
    let id: String
    let node: String
    
    func getURL() -> URL? {
        //guard let id = id, let node = node else { return nil }
        let avatar = "https://\(node).bkdrental.com/files?id=\(id)"
        
        return URL(string: avatar)
    }
}

struct CarExterior: Decodable {
    let length: Double
    let width: Double
    let height: Double
    
    func getExterior() -> String {
        return "\(length)x\(width)x\(height)\(Constant.Texts.m)"
    }
}


