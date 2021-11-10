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
    public var id: String?
    public var imageUrl: URL?
    public var name: String?
    public var count: Int?
    public var maxCount: Double?
    public var isAdded: Bool = false
    public var price: Double?    
    public var totalPrice: Double?

}

