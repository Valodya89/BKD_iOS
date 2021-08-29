//
//  PersonalDriver.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-08-21.
//

import Foundation

struct PersonalDriver: Codable {
    
    let username: String
    let status: String
    let driver: Driver
    
}

struct Driver: Codable {
    
    let state: String
    let name: String
    let surname: String
    let phoneNumber: String
    let dateOfBirth: String
    let street: String
    let house: String
    let mailBox: String
    let countryId: String
    let zip: String
    let city: String
    let nationalRegisterNumber: String
    let identityExpirationDate: String?
    let identityFront: String?
    let identityBack: String?
    let drivingLicenseIssueDate: String?
    let drivingLicenseExpirationDate: String?
    let drivingLicenseFront: String?
    let drivingLicenseBack: String?
    let drivingLicenseSelfie: String?
    let agreementApplied: Bool
    let agreementAppliedAt: Int
}
