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
    case getExteriorSize
    case getCustomLocation(longitude:Double, latitude: Double)
    case getCarsByType(criteria: [String : Any])
    case getCarsByFilter(criteria: [[String : Any]])
    case getWorkingTimes
    case getPhoneCodes
    case getCountries
    case signUp(username: String,
                password: String)
    case verifyAccounts(username: String,
                        code: String)
    case resendCode(username: String)
    case getAuthRefreshToken(refreshToken: String)
    case getToken(username: String, password: String)
    case forgotPassword(username: String)
    case changePassword(username: String, password: String)
    case addPersonalData(name: String,
                         surname: String,
                         phoneNumber: String,
                         dateOfBirth: String,
                         street: String,
                         house: String,
                         mailBox: String,
                         countryId: String,
                         zip: String,
                         city: String,
                         nationalRegisterNumber: String)
    
    

    
    var base: String {
        switch self {
        case .getWorkingTimes,
             .getPhoneCodes,
             .getCountries,
             .signUp,
             .verifyAccounts,
             .resendCode,
             .addPersonalData,
             .forgotPassword,
             .changePassword:
            return BKDBaseURLs.account.rawValue
            
        case .getAuthRefreshToken,
             .getToken:
            return BKDBaseURLs.auth.rawValue
            
        default:
            return BKDBaseURLs.rent.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .getAvailableTimeList:
            return "available-time/list"
        case .getCarList:
            return "car/list"
        case .getCarTypes:
            return "/car-type/list"
        case .getRestrictedZones:
            return "restricted-zones/list"
        case .getParking:
            return "/parking/list"
        case .getExteriorSize:
            return "car/sizes"
        case .getCustomLocation:
            return "parking/custom-location"
        case .getCarsByType, .getCarsByFilter:
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
        case .getAuthRefreshToken:
            fallthrough
        case .getToken:
            return "oauth/token"
        case .forgotPassword:
            return "accounts/send-code"
        case .addPersonalData:
            return "api/driver/personal"
        case .changePassword:
            return "accounts/change-password"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType,
             .getCarsByFilter,
             .signUp,
             .verifyAccounts,
             .resendCode,
             .addPersonalData,
             .forgotPassword,
             .getExteriorSize,
             .getCustomLocation,
             .addPersonalData:
            return [
                "Content-Type": "application/json"]
        case .getAuthRefreshToken:
            fallthrough
        case .getToken:
            let username = "gmail"
            let password = "gmail_secret"
            
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            return [
                "Authorization": "Basic \(base64LoginString)"]
        
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
        case let .getCustomLocation(longitude, latitude):
           return [
                "longitude" : "\(longitude)",
                "latitude" : "\(latitude)"
            ]
        default:
            return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        
        case let .getCarsByType(criteria):
            return [
                "criteria" : [criteria]
            ]
        case let .getCarsByFilter(criteria):
            return [
                "criteria" : criteria
            ]
        case let .signUp(username, password):
            return [
                "username": username,
                "password": password
            ]
        case let .verifyAccounts(username, code):
            return [
                "username": username,
                "code": code
            ]
        case let .resendCode(username):
            return [
                "username": username
            ]
        case .getAuthRefreshToken(let refreshToken):
            return [
                "refresh_token": refreshToken,
                "grant_type": "refresh_token"
            ]
        case .forgotPassword(let username):
            return [
                "username": username
            ]
        case .changePassword(let username, let password):
            return [
                "username": username,
                "password": password,
                "newPassword": password
            ]
        case .addPersonalData(let name, let surname, let phoneNumber, let dateOfBirth, let street, let house, let mailBox, let countryId, let zip, let city, let nationalRegisterNumber):
            return [
                "name": name,
                "surname": surname,
                "phoneNumber": phoneNumber,
                "dateOfBirth": dateOfBirth,
                "street": street,
                "house": house,
                "mailBox": mailBox,
                "countryId": countryId,
                "zip": zip,
                "city": city,
                "nationalRegisterNumber": nationalRegisterNumber
            ]
       
        default:
            return nil
        }
    }
    
    var formData: MultipartFormData? {
        switch self {
        case .getToken(let username, let password):
            let params = [
                "username": username,
                "password": password,
                "grant_type": "password"
            ]
            return MultipartFormData(parameters: params, blob: nil)
        default:
            return nil
        }
        
    }
    
    var method: RequestMethod {
        switch self {

        case .getCarsByType,
             .getCarsByFilter,
             .signUp,
             .getToken,
             .addPersonalData:
            return .post
        case .verifyAccounts,
             .changePassword:
            return .put
        case .resendCode,
             .forgotPassword:
            return .patch
            
        default:
            return .get
        }
    }
}
