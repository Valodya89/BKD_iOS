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
    let drivingLicenseIssueDate: String?
    let drivingLicenseExpirationDate: String?
    let drivingLicenseFront: ImageResponse?
    let drivingLicenseBack: ImageResponse?
    let drivingLicenseSelfie: ImageResponse?
    let agreementApplied: Bool
    let agreementAppliedAt: Double

}


struct ImageResponse: Codable {
    let id: String
    let node: String
    
    func getURL() -> URL? {
        let avatar = "https://dev-\(node).bkdrental.com/files?id=\(id)"
        //https://dev-node1.bkdrental.com/files?id=14122AFE1F760709174A3F2B166B05ABEEADF9F6AEB7BEA32AA71B10DFB46C8724F3D8E1386F8D9FAD38CF6BEE465173
        return URL(string: avatar)
    }
}
