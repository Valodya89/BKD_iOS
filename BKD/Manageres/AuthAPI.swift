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
    case verifyAccounts(username: String,
                        code: String)
    case resendCode(username: String)
    

    
    var base: String {
        switch self {
        case .getWorkingTimes,
             .getPhoneCodes,
             .getCountries,
             .signUp,
             .verifyAccounts,
             .resendCode:
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
        case .verifyAccounts:
            return "accounts/verify"
        case .resendCode:
            return "accounts/send-code"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType,
             .signUp,
             .verifyAccounts,
             .resendCode:
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
        case let .verifyAccounts(username, code):
            return [
                "username": username,
                "password": code
            ]
        case let .resendCode(username):
            return [
                "username": username
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
        case .verifyAccounts:
            return .put
        case .resendCode:
            return .patch
        default:
            return .get
        }
    }
}
