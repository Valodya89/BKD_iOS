//
//  SearchHeaderModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-05-21.
//

import UIKit
import CoreLocation


struct SearchModel {
    public var pickUpDate: Date?
    public var returnDate: Date?
    public var pickUpTime: Date?
    public var returnTime: Date?
    public var pickUpLocation: String?
    public var returnLocation: String?
    public var pickUpLocationId: String?
    public var returnLocationId: String?
    
    public var pickUpLocationLongitude: Double?
    public var pickUpLocationLatitude: Double?
    public var returnLocationLongitude: Double?
    public var returnLocationLatitude: Double?

    public var isPickUpCustomLocation: Bool = false
    public var isRetuCustomLocation: Bool = false
    public var category: Int?
    
    
    mutating func resetPickupCustomLocation(oldSearch: SearchModel) {
        self.pickUpLocation = oldSearch.pickUpLocation
        self.isPickUpCustomLocation =  oldSearch.isPickUpCustomLocation
        self.pickUpLocationId = oldSearch.pickUpLocationId
        self.pickUpLocationLatitude = oldSearch.pickUpLocationLatitude
        self.pickUpLocationLongitude = oldSearch.pickUpLocationLongitude
    }

    mutating func resetReturnCustomLocation(oldSearch: SearchModel) {
        self.returnLocation = oldSearch.returnLocation
        self.isRetuCustomLocation =  oldSearch.isRetuCustomLocation
        self.returnLocationId = oldSearch.returnLocationId
        self.returnLocationLatitude = oldSearch.returnLocationLatitude
        self.returnLocationLongitude = oldSearch.returnLocationLongitude
    }

    ///Update location
    mutating func updateLocation(tag: Int, parking: Parking) {
        if tag == 4 { //pick up location
            self.pickUpLocation = parking.name
            self.pickUpLocationId = parking.id
            self.isPickUpCustomLocation = false
            PriceManager.shared.pickUpCustomLocationPrice = nil
        } else {// return location
            self.returnLocation = parking.name
            self.returnLocationId = parking.id
            self.isRetuCustomLocation = false
            PriceManager.shared.returnCustomLocationPrice = nil
        }
    }
    
    ///Deselect custom location
    mutating func deselectCustomLocation(tag: Int) {
        if tag == 6 { //pick up custom location
            self.isPickUpCustomLocation = false
            self.pickUpLocation = nil
            self.pickUpLocationId = nil
            PriceManager.shared.pickUpCustomLocationPrice = nil

        } else {//return custom location
            self.isRetuCustomLocation = false
            self.returnLocation = nil
            self.returnLocationId = nil
            PriceManager.shared.returnCustomLocationPrice = nil
        }
    }
    
    
    ///Set custom location
    mutating func setCustomLocation(isPickUpLocation: Bool,
                        locationPlace: String,
                        coordinate: CLLocationCoordinate2D,
                        price: Double?) {
        if isPickUpLocation {
            self.isPickUpCustomLocation = true
            self.pickUpLocation = locationPlace
            self.pickUpLocationLongitude = coordinate.longitude
            self.pickUpLocationLatitude = coordinate.latitude
            PriceManager.shared.pickUpCustomLocationPrice = price
        } else {
            self.isRetuCustomLocation = true
            self.returnLocation = locationPlace
            self.returnLocationLongitude = coordinate.longitude
            self.returnLocationLatitude = coordinate.latitude
            PriceManager.shared.returnCustomLocationPrice = price
        }
    }
    
}

struct SearchDateModel {
    public var pickUpDay: String?
    public var returnDay: String?
    public var pickUpTime: String?
    public var returnTime: String?
    public var pickUpLocation: String?
    public var returnLocation: String?

}




