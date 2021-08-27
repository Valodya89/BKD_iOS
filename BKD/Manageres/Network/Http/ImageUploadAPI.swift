//
//  ImageUploadAPI.swift
//  MimoBike
//
//  Created by Dose on 5/21/21.
//

import UIKit

enum ImageUploadAPI: ImageUplaoder {
    
    case upload(image: UIImage)
    
    var image: UIImage?  {
        switch self {
        case .upload(image: let image):
            return image
        }
    }
    
    var base: String {
        return BKDBaseURLs.account.rawValue
    }
    
    var path: String {
        ///dls needs to be dinamic
        return "api/driver/document/DLS"
    }
    
    var header: [String : String] { [:] }
    
    var query: [String : String] {
        return [:]
    }
    
    var body: [String : Any]? { nil }
    
    var method: RequestMethod  {
        return .post
    }
    
    var formData: MultipartFormData? {
        return nil
    }
}
