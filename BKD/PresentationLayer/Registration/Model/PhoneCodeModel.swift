//
//  PhoneCodeModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-07-21.
//

import UIKit

struct PhoneCodeModel {
    public var country: String?
    public var code : String?
    public var flag: UIImage?
    public var phoneFormat: String?
    public var validFormPattern: Int?


}


struct PhoneCode: Decodable {
    let id: String
    let code : String
    let flag: String?
    let country: String?
    let mask: String?
    
    var imageFlag: UIImage? {
        
        guard let flag = flag, let data = Data(base64Encoded: flag) else { return nil }
        return UIImage(data: data)
    }
}


