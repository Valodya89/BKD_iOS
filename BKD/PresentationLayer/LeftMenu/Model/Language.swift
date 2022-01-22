//
//  Language.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-01-22.
//

import UIKit

struct Language: Codable {
    let id: String
    let name: String?
    let flag: String?
    
    var imageFlag: UIImage? {
        
        guard let flag = flag, let data = Data(base64Encoded: flag) else { return nil }
        return UIImage(data: data)
    }
}
