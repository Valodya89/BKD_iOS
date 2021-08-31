//
//  PersonalData.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-07-21.
//

import UIKit

struct PersonalData {

    public var name: String?
    public var surname: String?
    public var phoneNumber: String?
    public var dateOfBirth: String?
    public var street: String?
    public var house: String?
    public var mailBox: String?
    public var countryId: String?
    public var zip: String?
    public var city: String?
    public var nationalRegisterNumber: String?
    
}

struct DriverLiceseDateData {
    public var issueDate: String?
    public var expirationDate: String?
}



/*
 "timestamp": "2021-08-26T17:15:03.486+00:00",
     "statusCode": 200,
     "status": "OK",
     "message": "SUCCESS",
     "content": {
         "username": "karapetyankarine87@gmail.com",
         "status": "ACTIVE",
         "driver": {
             "state": "PERSONAL_DATA",
             "name": "Valodya",
             "surname": "Galstyan",
             "phoneNumber": "+37441099906",
             "dateOfBirth": "15-01-2021",
             "street": "some street",
             "house": "11",
             "mailBox": "374",
             "countryId": "60e30c6e89bf4b6b024559a1",
             "zip": "4sdf42ds4f",
             "city": "Yerevan",
             "nationalRegisterNumber": "1245454534",
             "identityExpirationDate": null,
             "identityFront": null,
             "identityBack": null,
             "drivingLicenseIssueDate": null,
             "drivingLicenseExpirationDate": null,
             "drivingLicenseFront": null,
             "drivingLicenseBack": null,
             "drivingLicenseSelfie": null,
             "agreementApplied": false,
             "agreementAppliedAt": 0
         }
     }
 }
 */
