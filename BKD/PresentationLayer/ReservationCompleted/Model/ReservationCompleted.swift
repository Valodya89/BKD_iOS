//
//  ReservationCompleted.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-12-21.
//

import Foundation
import SwiftUI

struct ReservationCompleted: Codable {
    
    let id: String
    let payLaterCount: Double
    let state: String
    let type: String
    let userId: String
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
    let identityExpirationDate: String
    let identityFront:ImageResponse
    let identityBack: ImageResponse
    let drivingLicenseIssueDate: String
    let drivingLicenseExpirationDate: String
    let drivingLicenseNumber: String
    let drivingLicenseFront: ImageResponse
    let drivingLicenseBack: ImageResponse
    let drivingLicenseSelfie: ImageResponse
    let agreementApplied: Bool
    let agreementAppliedAt: Double
}
