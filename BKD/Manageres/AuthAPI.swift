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
    case getToken(username: String,
                  password: String)
    case forgotPassword(username: String,
                        action: String)
    case recoverPassword(username: String,
                         password: String,
                         code: String)
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
    case getChatID(name: String, type: String, identifier: String)
    case getMessages(chatID: String)
    case sendMessage(chatID: String, message: String, userIdentifier: String)
    case addIdentityExpiration(expirationDate: String)
    case addDriverLicenseDates(issueDate: String,
                               expirationDate: String)


    
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
             .recoverPassword,
             .getChatID,
             .addIdentityExpiration,
             .addDriverLicenseDates:
            return BKDBaseURLs.account.rawValue
        case .getAuthRefreshToken,
             .getToken:
            return BKDBaseURLs.auth.rawValue
        case .getMessages:
            return BKDBaseURLs.account.rawValue
        case .sendMessage:
            return BKDBaseURLs.account.rawValue
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
        case .recoverPassword:
            return "accounts/recover-password"
        case .getChatID:
            return "/chat/start"
        case .getMessages(let chatID):
            return "/chat/\(chatID)/message"
        case let .sendMessage(chatID, _, _):
            return "/chat/\(chatID)/message"
        case .addIdentityExpiration:
            return "api/driver/identity-expiration"
        case .addDriverLicenseDates:
            return "api/driver/driving-license-dates"
        }
        
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType,
             .getCarsByFilter,
             .signUp,
             .verifyAccounts,
             .resendCode,
             .forgotPassword,
             .recoverPassword,
             .getExteriorSize,
             .getCustomLocation,
             .addPersonalData,
             .getChatID,
             .sendMessage,
             .addIdentityExpiration,
             .addDriverLicenseDates:
            return ["Content-Type": "application/json"]
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

        case let .getCustomLocation(longitude, latitude):
           return [
                "longitude" : "\(longitude)",
                "latitude" : "\(latitude)"
            ]
        case .getMessages:
            return [
                "size": "10",
                "sort": "sentAt,DESC"
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
        case let .forgotPassword(username, action):
            return [
                "username": username,
                "action": action
            ]
        case let .recoverPassword(username, password, code):
            return [
                "username": username,
                "password": password,
                "code": code
            ]
        case let .addPersonalData(name, surname, phoneNumber, dateOfBirth, street, house, mailBox, countryId, zip, city, nationalRegisterNumber):
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
        case let .getChatID(name, type, identifier):
            return [
                "userViewName": name,
                "type": type,
                "userIdentifier": identifier
            ]
        case let .sendMessage(_, message, userIdentifier):
            return [
                "message": message,
                "userIdentifier": userIdentifier
            ]
        case let .addIdentityExpiration(expirationDate):
            return [
                "expirationDate": expirationDate,
            ]
        case let .addDriverLicenseDates(issueDate,
                                   expirationDate):
            return [
                "issueDate": issueDate,
                "expirationDate": expirationDate
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
             .addPersonalData,
             .getChatID,
             .sendMessage,
             .addIdentityExpiration,
             .addDriverLicenseDates:
            return .post
        case .verifyAccounts,
             .recoverPassword:
            return .put
        case .resendCode,
             .forgotPassword:
            return .patch
            
        default:
            return .get
        }
    }
}
