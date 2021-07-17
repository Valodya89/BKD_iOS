//
//  Car.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-07-21.
//

import UIKit

struct CarsModel: Decodable {
//    let id: String
//    let name: String
//    let vendor: String
//    let volume: String
//    let type: String
//    let driverLicenseType: String
//    let price: String
//    let hasSpecialPrice: Bool
//    let specialPrice: String?
//    let airConditioning: Bool
//    let towbar: Bool
//    let active: Bool
//    let inRent: Bool
    
    
    let id: String
    let name: String
    let vendor: String
    let model: String
    let volume: Double
    let loadCapacity: Double
    let liftingCapacityTailLift: Double
    let tailLiftLength: Double
    let heightOfLoadingFloor: Double
    let driverLicenseType: String
    let price: Double
    let hasSpecialPrice: Bool
    let specialPrice: Double?
    
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
