//
//  ImageUploadAPI.swift
//  MimoBike
//
//  Created by Dose on 5/21/21.
//

import UIKit

enum ImageUploadAPI: ImageUplaoder {
    
    
    
    case upload(image: UIImage,
                id: String,
                state: String = "")
    case addDefect(image: UIImage,
                   id: String,
                   state: String = "",
                   description: String)
    case addOdometer(image: UIImage,
                   id: String,
                   value: String)
    case addDefectToFinish(image: UIImage,
                   id: String,
                   description: String)
    case addOdometerToFinish(image: UIImage,
                             id: String,
                             value: String)
    case addAccidentDamge(image: UIImage,
                          id: String,
                          side: String)
    case addAccidentForm(image: UIImage,
                         id: String)
    
    
    

    var image: UIImage?  {
        switch self {
        case .upload(image: let image, _, _):
            return image
        case let .addDefect(image, _, _, _):
            return image
        case let .addOdometer(image, _, _):
            return image
        case let .addDefectToFinish(image, _, _):
            return image
        case let .addOdometerToFinish(image, _, _):
            return image
        case let .addAccidentDamge(image, _, _):
            return image
        case let .addAccidentForm(image, _):
            return image
        
        }
    }
    
    var filePathKey: String? {
        switch self {
        case .upload:
            return "document"
        case .addDefect,
             .addOdometer,
             .addDefectToFinish,
             .addOdometerToFinish,
             .addAccidentDamge,
             .addAccidentForm:
            return "image"
        }
    }
    
    var base: String {
        switch self {
        case .upload:
            return BKDBaseURLs.account.rawValue
        case .addDefect,
             .addOdometer,
             .addDefectToFinish,
             .addOdometerToFinish,
             .addAccidentDamge,
             .addAccidentForm:
            return BKDBaseURLs.rent.rawValue
        }
    }
    
    var path: String {
        switch self {
        case let .upload(_, id, state):
            return "/api/driver/\(id)/document/\(state)"
        case let .addDefect(_, id, state, _):
            return "api/rents/\(id)/start/\(state)"
        case let .addOdometer(_, id, _):
            return "api/rents/\(id)/start/odometer"
        case let .addDefectToFinish(_, id, _):
            return "api/rents/\(id)/finish/defects"
        case let .addOdometerToFinish(_, id, _):
            return "api/rents/\(id)/finish/odometer"
        case let .addAccidentDamge(_, id, _):
            return "api/accident/\(id)/damage"
        case let .addAccidentForm(_, id):
            return "api/accident/\(id)/form"
                }
        
    }
    
    var header: [String : String] {
        return ["Content-Type": "multipart/form-data"]
        
    }
    
    var query: [String : String] {
        return [:]
    }
    
    var body: [String : Any]? {
        switch self {
        case .upload,
             .addAccidentForm:
            return nil
        case let .addDefect(_, _, _, description):
            return [
                "description": description
            ]
        case let .addOdometer(_, _, value):
            return [
                "value": value
            ]
        case let .addDefectToFinish(_, _, description):
            return [
                "description": description
            ]
        case let .addOdometerToFinish(_, _, value):
            return [
                "value": value
            ]
        case let .addAccidentDamge(_, _, side):
            return [
                "side": side
            ]
        }
    }
    
    var method: RequestMethod  {
        switch self {
        case .upload:
            return .post
        case .addDefect,
             .addOdometer,
             .addDefectToFinish,
             .addOdometerToFinish,
             .addAccidentDamge,
             .addAccidentForm:
            return .put
        }
    }
    
    var formData: MultipartFormData? {
        return nil
    }
}
