//
//  MainDriver.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-10-21.
//

import UIKit

struct MainDriver: Codable {
    
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
    let drivingLicenseNumber: String?
    let drivingLicenseIssueDate: String?
    let drivingLicenseExpirationDate: String?
    let drivingLicenseFront: ImageResponse?
    let drivingLicenseBack: ImageResponse?
    let drivingLicenseSelfie: ImageResponse?
    let agreementApplied: Bool
    let agreementAppliedAt: Double

    ///get drier full name
    func getFullname() -> String {
        return (name ?? "") + " " + (surname ?? "")
    }
}


struct ImageResponse: Codable {
    let id: String
    let node: String
    
    func getURL() -> URL? {
        let avatar = "https://\(node).bkdrental.com/files?id=\(id)"
        return URL(string: avatar)
    }
}
