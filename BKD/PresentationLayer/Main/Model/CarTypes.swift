//
//  CareTypes.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-07-21.
//

import UIKit

struct CarTypes: Decodable {
    let id: String
    let name: String
    let image: CarTypeImageResponse
    let active: Bool

}

struct CarTypeImageResponse: Decodable {
    let id: String?
    let node: String?
    
    func getURL() -> URL? {
        guard let id = id, let node = node else { return nil }
        let avatar = "https://\(node).bkdrental.com/files?id=\(id)"
        
        return URL(string: avatar)
    }
}
