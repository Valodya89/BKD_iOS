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
    public var isPickUpCustomLocation: Bool = false
    public var isRetuCustomLocation: Bool = false
    public var category: Int?

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


