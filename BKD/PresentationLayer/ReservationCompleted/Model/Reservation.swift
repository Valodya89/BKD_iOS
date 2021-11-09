//
//  Reservation.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-11-21.
//

import UIKit

struct Rent: Codable {
    
     let id: String
     let userId: String
     let startDate: Date
     let endDate: Date
     let accessories: [AccessoriesToRent]?
     let pickupLocation: LocationToRent
     let returnLocation: LocationToRent
     let carDetails: CarDetailsToRent
     let driver: DriverToRent
     let additionalDrivers: [AdditionalDriversToRent]?

}


struct AccessoriesToRent: Codable {
    let id: String
    let count: Double
}

struct LocationToRent: Codable {
    let type: String
    let customLocation: CustomLocationToRent?
    let parking: String?
}

struct CustomLocationToRent: Codable {
    
     let name: String
     let longitude: Double
     let latitude: Double
}

struct CarDetailsToRent: Codable {
    let id: String
    let registrationNumber: String?
    let logo: Logo
    let model: String
    let type: String?
}

struct DriverToRent: Codable {
    let id: String
    let name: String
    let surname: String
    let drivingLicenseNumber: String?
}

struct AdditionalDriversToRent: Codable {
    
}
