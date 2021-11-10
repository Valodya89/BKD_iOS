//
//  MyDriver.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-11-21.
//

import Foundation

struct MyDriver: Codable {
    
    let id: String
    let state: String
    let type: String
    let userId: String
    let name: String?
    let surname: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let street: String?
    let house: String?
    let mailBox: String?
    let countryId: String?
    let zip: String?
    let city: String?
    let nationalRegisterNumber: String?
    let identityExpirationDate: String?
    let identityFront: ImageResponse?
    let identityBack: ImageResponse?
    let drivingLicenseIssueDate: String?
    let drivingLicenseExpirationDate: String?
    let drivingLicenseFront: ImageResponse?
    let drivingLicenseBack: ImageResponse?
    let drivingLicenseSelfie: ImageResponse?
    let agreementApplied: Bool
    let agreementAppliedAt: Double

}


