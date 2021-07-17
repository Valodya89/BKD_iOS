//
//  AuthAPI.swift
//  MimoBike
//
//  Created by Albert on 15.05.21.
//

import Foundation

enum AuthAPI: APIProtocol {
    
    case getAvailableTimeList
    case getCarList
    case getCarTypes
    case getRestrictedZones
    case getParking
    case getCarsByType(fieldName: String,
                       fieldValue: String,
                       searchOperation: String)
    
    

    case updateTranslation(key: String, language: String, module: String, value: String)
    case depositFromAttachedCard(ammount: Double)
    case depositFromUnAttachedCard(ammount: Double, locale: String)
    case depositWithTelcell(amount: Double, number: String)
    case orderCard(address: String, birthday: String, email: String, socialCard: String, passportImageBase64: String)
    
    
    var base: String {
        switch self {

        default:
            return BKDBaseURLs.auth.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .getAvailableTimeList:
            return "available-time/list"
        case .getCarList:
            return "car/list"
        case .getCarTypes:
            return "car-type/list"
        case .getRestrictedZones:
            return "restricted-zones/list"
        case .getParking:
            return "/parking/list"
        case .getCarsByType:
            return "car/search"
        default:
            return""
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType:
            return [
                "Content-Type": "application/json"]
        
        default:
            return [:]
        }
    }
    
    var query: [String : String] {
        switch self {
//        case .preactivate(let deviceId):
//            return [
//                "deviceId": deviceId
//            ]
//        case .getFinancialState(let deviceID):
//            return [
//                "deviceId": deviceID
//            ]
        default:
            return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAvailableTimeList:
            return nil
        case .getCarList:
            return nil
        case .getCarTypes:
            return nil
        case .getRestrictedZones:
            return nil
        case let .getCarsByType(fieldName, fieldValue, searchOperation):
        return [
            "fieldName": fieldName,
            "fieldValue": fieldValue,
            "searchOperation":searchOperation
        ]
        default:
            return nil
        }
    }
    
    var formData: MultipartFormData? {
        return nil
    }
    
    var method: RequestMethod {
        switch self {

        case .getCarsByType:
            return .post
        default:
            return .get
        }
    }
}
