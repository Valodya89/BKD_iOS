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
    case getWorkingTimes
    case getPhoneCodes
    case getCountries
    case signUp(username: String,
                password: String)
    

    
    var base: String {
        switch self {
        case .getWorkingTimes, .getPhoneCodes, .getCountries, .signUp:
            return BKDBaseURLs.account.rawValue
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
        case .getWorkingTimes:
            return "settings/default"
        case .getPhoneCodes:
            return "phone-code/list"
        case .getCountries:
            return "country/list"
        case .signUp:
            return "accounts/create"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType, .signUp:
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
        
        case let .getCarsByType(fieldName, fieldValue, searchOperation):
            return [
                "fieldName": fieldName,
                "fieldValue": fieldValue,
                "searchOperation":searchOperation
            ]
        case let .signUp(username, password):
            return [
                "username": username,
                "password": password
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

        case .getCarsByType, .signUp:
            return .post
        default:
            return .get
        }
    }
}
