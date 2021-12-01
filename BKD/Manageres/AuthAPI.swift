//
//  AuthAPI.swift
//  MimoBike
//
//  Created by Albert on 15.05.21.
//


//https://dev-rents.bkdrental.com/tariff/list
import Foundation

enum AuthAPI: APIProtocol {
    
    case getAvailableTimeList
    case getCarList
    case getCarTypes
    case getRestrictedZones
    case getParking
    case getExteriorSize
    case getCustomLocation(longitude:Double,
                           latitude: Double)
    case getCarsByType(criteria: [String : Any])
    case getCarsByFilter(criteria: [[String : Any]])
    case getSettings
    case getFlexibleTimes
    case getPhoneCodes
    case getCountries
    case getTariff
    case getAccessories(carID: String)
    case getMainDriver
    case getAdditionalDrivers
    case signUp(username: String,
                password: String)
    case verifyAccounts(username: String,
                        code: String)
    case resendCode(username: String)
    case sendCodeSms(phoneCode: String,
                     phoneNumber: String)
    case verifyPhoneCode(phoneCode: String,
                         phoneNumber: String,
                         code: String)
    case getAuthRefreshToken(refreshToken: String)
    case getToken(username: String,
                  password: String)
    case forgotPassword(username: String,
                        action: String)
    case recoverPassword(username: String,
                         password: String,
                         code: String)
    case createDriver(driverType: String)
    case addPersonalData(id: String,
                         name: String,
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
    case addIdentityExpiration(id: String,
                               expirationDate: String)
    case addDriverLicenseDates(id: String,
                               issueDate: String,
                               expirationDate: String,
                               drivingLicenseNumber: String)
    case acceptAgreement(id: String)
    case addRent(carId: String,
                 startDate: Double,
                 endDate: Double,
                 accessories: [[String : Any]?] ,
                 additionalDrivers: [String?],
                 pickupLocation: [String : Any],
                 returnLocation: [String : Any])
    case payLater
    case getRents
    case getChatID(name: String,
                   type: String,
                   identifier: String)
    case getMessages(chatID: String)
    case sendMessage(chatID: String,
                     message: String,
                     userIdentifier: String)
    
    
    


    var base: String {
        switch self {
        case .getSettings,
             .getPhoneCodes,
             .getCountries,
             .getMainDriver,
             .getAdditionalDrivers,
             .signUp,
             .verifyAccounts,
             .resendCode,
             .sendCodeSms,
             .verifyPhoneCode,
             .addPersonalData,
             .forgotPassword,
             .recoverPassword,
             .getChatID,
             .createDriver,
             .addIdentityExpiration,
             .addDriverLicenseDates,
             .acceptAgreement,
             .getMessages,
             .sendMessage,
             .payLater:
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
        case .getSettings:
            return "settings/default"
        case .getFlexibleTimes:
            return "flexible-times/list"
        case .getPhoneCodes:
            return "phone-code/list"
        case .getCountries:
            return "country/list"
        case .getTariff:
            return "tariff/list"
        case .getAccessories(let carID):
            return "car/\(carID)/accessories"
        case .getMainDriver:
            return "api/driver"
        case .getAdditionalDrivers:
            return "api/driver/additional"
        case .signUp:
            return "accounts/create"
        case .verifyAccounts:
            return "accounts/verify"
        case .resendCode:
            return "accounts/send-code"
        case .sendCodeSms:
            return "api/user/phone/send-code"
        case .verifyPhoneCode:
            return "api/user/phone/verify"
        case .getAuthRefreshToken:
            fallthrough
        case .getToken:
            return "oauth/token"
        case .forgotPassword:
            return "accounts/send-code"
        case .createDriver(let driverType):
            return "api/driver/\(driverType)"
        case let .addPersonalData(id, _,_,_,_,_,_,
                                  _,_,_,_,_):
            return "api/driver/\(id)/personal"
        case .recoverPassword:
            return "accounts/recover-password"
        case .getRents:
            return "api/rents"
        case .getChatID:
            return "/chat/start"
        case .getMessages(let chatID):
            return "/chat/\(chatID)/message"
        case let .sendMessage(chatID, _, _):
            return "/chat/\(chatID)/message"
        case let.addIdentityExpiration(id, _):
            return "api/driver/\(id)/identity-expiration"
        case let.addDriverLicenseDates(id, _, _, _):
            return "api/driver/\(id)/driving-license-dates"
        case let .acceptAgreement(id):
            return "api/driver/\(id)/agreement/accept"
        case .addRent:
            return "api/rents"
        case .payLater:
            return "api/driver/pay-later"
            
        
        }
        
    }
    
    var header: [String : String] {
        switch self {
        case .getCarsByType,
             .getCarsByFilter,
             .getMainDriver,
             .getAdditionalDrivers,
             .signUp,
             .verifyAccounts,
             .resendCode,
             .sendCodeSms,
             .verifyPhoneCode,
             .forgotPassword,
             .recoverPassword,
             .getExteriorSize,
             .getCustomLocation,
             .addPersonalData,
             .getChatID,
             .getTariff,
             .getAccessories,
             .sendMessage,
             .createDriver,
             .addIdentityExpiration,
             .addDriverLicenseDates,
             .acceptAgreement,
             .addRent,
             .getRents,
             .payLater:
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
        case let .sendCodeSms(phoneCode, phoneNumber):
            return [
                "phoneCode": phoneCode,
                "phoneNumber": phoneNumber
            ]
        case let .verifyPhoneCode(phoneCode,
                                  phoneNumber,
                                  code):
            return [
                "phoneCode": phoneCode,
                "phoneNumber": phoneNumber,
                "code": code
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
        case let .addPersonalData( _, name, surname, phoneNumber, dateOfBirth, street, house, mailBox, countryId, zip, city, nationalRegisterNumber):
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
        case let .addIdentityExpiration(_, expirationDate):
            return [
                "expirationDate": expirationDate,
            ]
        case let .addDriverLicenseDates(_, issueDate,
                                   expirationDate,
                                   drivingLicenseNumber):
            return [
                "issueDate": issueDate,
                "expirationDate": expirationDate,
                "drivingLicenseNumber": drivingLicenseNumber
            ]
        case let .addRent(carId,
                          startDate,
                          endDate,
                          accessories,
                          additionalDrivers,
                          pickupLocation,
                          returnLocation):
            return [
                "carId": carId,
                "startDate": startDate,
                "endDate": endDate,
                "accessories": accessories,
                "additionalDrivers": additionalDrivers,
                "pickupLocation": pickupLocation,
                "returnLocation": returnLocation
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
             .sendCodeSms,
             .createDriver,
             .addIdentityExpiration,
             .addDriverLicenseDates,
             .acceptAgreement,
             .addRent,
             .payLater:
            return .post
        case .verifyAccounts,
             .recoverPassword:
            return .put
        case .resendCode,
             .verifyPhoneCode,
             .forgotPassword:
            return .patch
            
        default:
            return .get
        }
    }
}

