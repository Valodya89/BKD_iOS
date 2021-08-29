//
//  ImageUploadAPI.swift
//  MimoBike
//
//  Created by Dose on 5/21/21.
//

import UIKit

enum ImageUploadAPI: ImageUplaoder {
    
    case upload(image: UIImage, state: String = "")
    
    var image: UIImage?  {
        switch self {
        case .upload(image: let image, _):
            return image
        }
    }
    
    var base: String {
        return BKDBaseURLs.account.rawValue
    }
    
    var path: String {
        ///dls needs to be dinamic
        switch self {
        case .upload(_, state: let state):
            return "/api/driver/document/\(state)"
                }
        
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
