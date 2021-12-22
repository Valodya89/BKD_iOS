//
//  Reservation.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-11-21.
//

import UIKit
import SwiftUI

struct Rent: Codable {
    
     let id: String
     let state: String?
     let deposit: String?
     let rent: String?
     let distance: String?
     let userId: String
     let startDate: Double
     let endDate: Double
     let accessories: [AccessoriesToRent]?
     let pickupLocation: LocationToRent
     let returnLocation: LocationToRent
     let carDetails: CarDetailsToRent
     let driver: DriverToRent
     let currentDriver: DriverToRent?
     let additionalDrivers: [AdditionalDriversToRent]?
     let startDefects: [Defect?]
     let endDefects: [Defect?]
     let startOdometer: Odometer?
     let endOdometer: Odometer?
     let hasAccident: Bool
             

//        "totalCount": 3,
//        "totalPages": 1,
//        "pageNumber": 0,
//        "pageSize": 10
//    }

}


struct AccessoriesToRent: Codable {
    let id: String
    let count: Double
}

struct LocationToRent: Codable {
    let type: String
    let customLocation: CustomLocationToRent?
    let parking: Parking?
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
    let name: String?
    let surname: String?
    let drivingLicenseNumber: String?
}

struct CurrentDriver: Codable {
    let id: String
    let name: String
    let surname: String
    let drivingLicenseNumber: String
}

struct AdditionalDriversToRent: Codable {
    
}

struct Defect: Codable {
     let comment: String?
     let image: Logo?
    }

struct Odometer: Codable{
    let value: String
    let image: Logo
}
/*
{
            "id": "61896cd5a217574ee1f6811c",
            "state": "FINISHED",
            "deposit": null,
            "rent": null,
            "distance": null,
            "userId": "60febc56266f574fec954af2",
            "startDate": 1636395213876,
            "endDate": 1636395213876,
            "accessories": [
                {
                    "id": "61506ec81464ab42a0e2f31e",
                    "count": 1
                }
            ],
            "pickupLocation": {
                "type": "CUSTOM",
                "customLocation": {
                    "name": "Masivi city",
                    "longitude": 45.5,
                    "latitude": 47.8
                },
                "parking": null
            },
            "returnLocation": {
                "type": "CUSTOM",
                "customLocation": {
                    "name": "Masivi city",
                    "longitude": 45.5,
                    "latitude": 47.8
                },
                "parking": null
            },
            "carDetails": {
                "id": "61815f3296b3233b4995c625",
                "registrationNumber": null,
                "logo": {
                    "id": "14122AFE1F760709174A3F2B166B05AB51B1D7286ECAC4678C5B2F485A99F02605F320DD234F89BAAFC16476569668ED",
                    "node": "dev-node1"
                },
                "model": "M3",
                "type": null
            },
            "driver": {
                "id": "60febc56266f574fec954af2",
                "name": "Valodya",
                "surname": "Galstyan",
                "drivingLicenseNumber": "sd5fsd56f1sd561"
            },
            "currentDriver": {
                "id": "60febc56266f574fec954af2",
                "name": "Valodya",
                "surname": "Galstyan",
                "drivingLicenseNumber": "sd5fsd56f1sd561"
            },
            "additionalDrivers": [],
            "startDefects": [
                {
                    "comment": "some defect",
                    "image": {
                        "id": "14122AFE1F760709174A3F2B166B05AB6BAED340C79B6B7A34FD3C48B2CA18EDBC16A1F9EE07FF0047E52052E50A69D0",
                        "node": "dev-node1"
                    }
                },
                {
                    "comment": "some defect",
                    "image": {
                        "id": "14122AFE1F760709174A3F2B166B05AB6BAED340C79B6B7A34FD3C48B2CA18EDEB5F4D1FD38CE970E94BA0CD3E679248",
                        "node": "dev-node1"
                    }
                }
            ],
            "endDefects": [
                {
                    "comment": "some defect",
                    "image": {
                        "id": "14122AFE1F760709174A3F2B166B05AB6BAED340C79B6B7A34FD3C48B2CA18EDF731217DBE24CF8AE9262E6833EFCE83",
                        "node": "dev-node1"
                    }
                },
                {
                    "comment": "some defect",
                    "image": {
                        "id": "14122AFE1F760709174A3F2B166B05AB6BAED340C79B6B7A34FD3C48B2CA18ED933DB76735F1608BF73BDF29257C3A16",
                        "node": "dev-node1"
                    }
                }
            ],
            "startOdometer": {
                "value": "1360000",
                "image": {
                    "id": "14122AFE1F760709174A3F2B166B05AB6BAED340C79B6B7A34FD3C48B2CA18EDD8B47DED1C41271811D3CDA261E34C12",
                    "node": "dev-node1"
                }
            },
            "endOdometer": null,
            "hasAccident": true
        },

*/
