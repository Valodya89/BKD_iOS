//
//  AccessoriesModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-06-21.
//

import UIKit


struct Accessories: Codable {
    let id: String
    let name: String
    let price: Double
    let maxCount: Double
    let active: Bool
    let image: AccesoreImageResponse
}

struct AccesoreImageResponse: Codable {
    let id: String
    let node: String
    
    func getURL() -> URL? {
        let img = "https://\(node).bkdrental.com/files?id=\(id)"
        
        return URL(string: img)
    }
}


struct AccessoriesEditModel {
    public var accessoryCount: Int?
    public var isAdded: Bool = false
    public var totalPrice: Double?

}

struct AccessoriesModel {
    public var accessoryImg: UIImage?
    public var accessoryName: String?
    public var accessoryPrice: Double?
    public var accessoryCount: Int?
    public var isAdded: Bool = false
    public var totalPrice: Double?

}
