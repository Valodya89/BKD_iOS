//
//  CategoryModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-05-21.
//

import UIKit

struct CategoryModel {
    public var categoryName: String
    public var data: [CategoryCollectionData]
}


struct CategoryCollectionData {
    public var carName: String
    public var carImg: UIImage
    public var isCarExist: Bool
}
