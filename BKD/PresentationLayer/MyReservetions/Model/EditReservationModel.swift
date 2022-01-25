//
//  EditReservationModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-01-22.
//

import Foundation

struct EditReservationModel {
    public var carId: String?
    public var startDate: Double?
    public var endDate: Double?
    public var accessories: [EditAccessory]?
    public var additionalDrivers: [DriverToRent]?
    public var pickupLocation: EditLocation?
    public var returnLocation: EditLocation?
    
    
    ///Get new value of reservation
    func getNewReservetionSearchInfo(carId:String, startDate: Double, search: SearchModel, editReservation: EditReservationModel?) -> EditReservationModel {
        
        var newEditReservation: EditReservationModel? = editReservation
        if newEditReservation == nil {
            newEditReservation = EditReservationModel()
        }
        
        newEditReservation?.carId = carId
        //Search fields
        newEditReservation?.startDate = startDate
        if let date = search.returnDate,
           let time = search.returnTime {
            newEditReservation?.endDate = Date().combineDate(date: date, withTime: time)?.timeIntervalSince1970 ?? 0.0
        }
        //Pick up location
        newEditReservation?.pickupLocation = EditLocation(type: search.isPickUpCustomLocation ? Constant.Keys.custom : Constant.Keys.parking)
        
        if search.isPickUpCustomLocation {
            newEditReservation?.pickupLocation?.customLocation = EditCustomLocation(name: search.pickUpLocation ?? "", longitude: search.pickUpLocationLongitude!, latitude: search.pickUpLocationLatitude!)
            
        } else {
            newEditReservation?.pickupLocation?.parking = EditParking(id: search.pickUpLocationId ?? "",
                                                                  name: search.pickUpLocation ?? "",
                                                                  longitude: search.pickUpLocationLongitude!,
                                                                  latitude: search.pickUpLocationLatitude!)
        }
        
        //Return up location
        newEditReservation?.returnLocation = EditLocation(type:search.isRetuCustomLocation ? Constant.Keys.custom : Constant.Keys.parking)
        
        if search.isRetuCustomLocation {
            newEditReservation?.returnLocation?.customLocation = EditCustomLocation(name: search.returnLocation ?? "", longitude: search.returnLocationLongitude!, latitude: search.returnLocationLatitude!)
            
        } else {
            newEditReservation?.returnLocation?.parking = EditParking(id: search.returnLocationId ?? "", name: search.returnLocation ?? "", longitude: search.returnLocationLongitude!, latitude: search.returnLocationLatitude!)
        }
        
        return newEditReservation!
    }
    
}

struct EditLocation {
    public var type: String
    public var customLocation: EditCustomLocation?
    public var parking: EditParking?
}

struct EditCustomLocation {
    
    public var name: String
    public var longitude: Double
    public var latitude: Double
}

struct EditParking  {
    public var id: String
    public var name: String
    public var longitude: Double
    public var latitude: Double
}

struct EditAccessory{
    public var id: String
    public var count: Double
    public var accessory: AccessoriesEditModel
}




//{
//    "carId": "61815f3296b3233b4995c625",
//    "startDate": 1642756432345,
//    "endDate": 1642789764567,
//    "accessories": [
//        {
//            "id": "61506ec81464ab42a0e2f31e",
//            "count": 1
//        }
//    ],
//    "additionalDrivers": [],
//    "pickupLocation": {
//        "type": "CUSTOM",
//        "customLocation": {
//            "name": "Masivi city",
//            "longitude": 45.5,
//            "latitude": 47.8
//        }
//    },
//    "returnLocation": {
//        "type": "CUSTOM",
//        "customLocation": {
//            "name": "Masivi city",
//            "longitude": 45.5,
//            "latitude": 47.8
//        }
//    }
//}
