//
//  SearchHeaderModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-05-21.
//

import UIKit

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

    
}

struct SearchDateModel {
    public var pickUpDay: String?
    public var returnDay: String?
    public var pickUpTime: String?
    public var returnTime: String?
    public var pickUpLocation: String?
    public var returnLocation: String?

}

struct CategoryCarouselModel {
    public var categoryName: String?
    public var CategoryImg: UIImage?

}


