//
//  RegistrationBotViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-07-21.
//

import UIKit

//enum RegistrationState: String {
//    case PERSONAL_DATA
//    case IDENTITY_FRONT
//    case IDENTITY_BACK
//    case IDENTITY_EXPIRATION
//    case DRIVING_LICENSE_FRONT
//    case DRIVING_LICENSE_BACK
//    case DRIVING_LICENSE_DATES
//    case DRIVING_LICENSE_SELFIE
//    case AGREEMENT_ACCEPTED
//}

enum ImageUploadState: String {
    case IF = "IF"
    case IB = "IB"
    case DLF = "DLF"
    case DLB = "DLB"
    case DLS = "DLS"
}



class RegistrationBotViewModel: NSObject {
    
    private var keychainManager = KeychainManager()
    
    ///Set registration bot information
    func setRegisterBotInfo(mainDriver: MainDriver, countryList: [Country]?, completion: @escaping ([RegistrationBotModel]) -> Void) {
        
        var tableData: [RegistrationBotModel] = []
        for i in 0 ..< RegistrationBotData.registrationBotModel.count {
            tableData.append(RegistrationBotData.registrationBotModel[i])
            if tableData[i].userRegisterInfo?.string == Constant.Texts.start {
                tableData[i].userRegisterInfo?.isFilled = true
            }
             else if tableData[i].userRegisterInfo?.placeholder == Constant.Texts.name {
                 tableData[i].userRegisterInfo?.string = mainDriver.name
                 tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder == Constant.Texts.surname {
                tableData[i].userRegisterInfo?.string = mainDriver.surname
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].viewDescription == Constant.Texts.phone {
                tableData[i].userRegisterInfo = UserRegisterInfo( string: mainDriver.phoneNumber, isFilled: true)
            }
            else if tableData[i].userRegisterInfo?.placeholder == Constant.Texts.dateOfBirth {
                let components = mainDriver.dateOfBirth!.components(separatedBy: "T")

                tableData[i].userRegisterInfo?.date = components[0].stringToDateWithoutTime()
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.streetName {
                tableData[i].userRegisterInfo?.string = mainDriver.street
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.houseNumber {
                tableData[i].userRegisterInfo?.string = mainDriver.house
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.mailboxNumber {
                tableData[i].userRegisterInfo?.string = mainDriver.mailBox
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.country {
                let country = countryList?.filter { $0.id == mainDriver.countryId }
                tableData[i].userRegisterInfo?.string =  country?.first?.country
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.zipNumber {
                tableData[i].userRegisterInfo?.string = mainDriver.zip
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.city {
                tableData[i].userRegisterInfo?.string = mainDriver.city
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].viewDescription ==  Constant.Texts.nationalRegister {
                tableData[i].userRegisterInfo = UserRegisterInfo( string: mainDriver.nationalRegisterNumber, isOtherNational: false,  isFilled: true)
                if mainDriver.state == Constant.Texts.state_pers_data {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Keys.take_photo &&
                tableData[i - 1].msgToFillBold == Constant.Texts.IF_text {
                if mainDriver.identityFront != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.identityFront!.getURL()!, isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_IF {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Keys.take_photo &&
                tableData[i - 1].msgToFillBold == Constant.Texts.IB_text {
                if mainDriver.identityBack != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.identityBack!.getURL()!, isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_IB {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Texts.expiryDate {
                let components = mainDriver.identityExpirationDate!.components(separatedBy: "T")
                tableData[i].userRegisterInfo = UserRegisterInfo(date:components[0].stringToDateWithoutTime(), isFilled: true)
                if mainDriver.state == Constant.Texts.state_IEX {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].userRegisterInfo?.placeholder ==  Constant.Texts.drivingLicenseNumber {
                tableData[i].userRegisterInfo?.string = mainDriver.drivingLicenseNumber
                tableData[i].userRegisterInfo?.isFilled = true
            }
            else if tableData[i].viewDescription ==  Constant.Keys.take_photo &&
                tableData[i - 1].msgToFillBold == Constant.Texts.DLF_text {
                if mainDriver.drivingLicenseFront != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.drivingLicenseFront!.getURL()!, isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_DLF {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Keys.take_photo &&
                tableData[i - 1].msgToFillBold == Constant.Texts.DLB_text {
                if mainDriver.drivingLicenseBack != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.drivingLicenseBack!.getURL()!, isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_DLB {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Texts.issueDateDrivingLicense {
                let components = mainDriver.drivingLicenseIssueDate!.components(separatedBy: "T")
                tableData[i].userRegisterInfo = UserRegisterInfo(date:components[0].stringToDateWithoutTime(), isFilled: true)
            }
            else if tableData[i].viewDescription ==  Constant.Texts.expiryDateDrivingLicense {
                if mainDriver.drivingLicenseExpirationDate != nil {
                    let components = mainDriver.drivingLicenseExpirationDate!.components(separatedBy: "T")
                    tableData[i].userRegisterInfo = UserRegisterInfo(date:components[0].stringToDateWithoutTime(), isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_DL_date {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Keys.take_photo &&
                tableData[i - 1].examplePhoto != nil {
                if mainDriver.drivingLicenseSelfie != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.drivingLicenseSelfie!.getURL()!, isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_DLS {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Keys.open_doc {
                if mainDriver.agreementApplied {
                    tableData[i].userRegisterInfo = UserRegisterInfo(isFilled: true)
                }
                if mainDriver.state == Constant.Texts.state_agree {
                    completion(tableData)
                    return
                }
            }
                
        
        }
        
        completion(tableData)
    }
    
    ///Get personal data for driver draft
    func getPersonalData(driver: MainDriver?) -> PersonalData? {
        
        let personalData:PersonalData? = PersonalData(name: driver?.name,
                                                      surname: driver?.surname,
                                                      phoneNumber: driver?.phoneNumber,
                                                      dateOfBirth: driver?.dateOfBirth,
                                                      street: driver?.street,
                                                      house: driver?.house,
                                                      mailBox: driver?.mailBox, countryId: driver?.countryId,
                                                      zip: driver?.zip,
                                                      city: driver?.city,
                                                      nationalRegisterNumber: driver?.nationalRegisterNumber)
        return personalData
    }
    
    ///Get driver license data for driver draft
    func getDriverLicenseDateData(driver: MainDriver?) -> DriverLiceseDateData? {
        
        return DriverLiceseDateData(issueDate: driver?.drivingLicenseIssueDate, expirationDate: driver?.identityExpirationDate, drivingLicenseNumber: driver?.drivingLicenseNumber)
    }
    
   
    ///Get state if image uploading
    func getImageUploadState(index: Int) -> ImageUploadState{
        switch index {
        case 31:
            return ImageUploadState.IF
        case 33:
            return ImageUploadState.IB
        case 39:
            return ImageUploadState.DLF
        case 41:
            return ImageUploadState.DLB
        case 48:
            return ImageUploadState.DLS
        default:
            return ImageUploadState.DLS
        }
    }

    
    
    
    /// get country list
    func getCountryList(completion: @escaping ([Country]) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCountries)) { (result) in
            
            switch result {
            case .success(let data):
                guard let countryList = BkdConverter<BaseResponseModel<[Country]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(countryList.content as Any)
                completion(countryList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    
    ///Creat user or driver
    func creatDriver(type: String, completion: @escaping (MainDriver?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.createDriver(driverType: type))) { (result) in
            
            switch result {
            case .success(let data):
                guard let mainDriver = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                completion(mainDriver.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    /// add Personla Data
    func addPersonlaData(id: String,  personlaData: PersonalData,
                         completion: @escaping (MainDriver?, String?) -> Void) {
        

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addPersonalData(id: id, name: personlaData.name!, surname: personlaData.surname!, phoneNumber: personlaData.phoneNumber!, dateOfBirth: personlaData.dateOfBirth!, street: personlaData.street!, house: personlaData.house!, mailBox: personlaData.mailBox ?? "", countryId: personlaData.countryId!, zip: personlaData.zip!, city: personlaData.city!, nationalRegisterNumber: personlaData.nationalRegisterNumber!))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content!, nil)

            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
        }
    }
    
    
    ///add identity experation date
    //Optional("ACCOUNTS_wrong_feeling_state_identity_back_empty")

    func addIdentityExpiration(id:String, experationDate: String,
                               completion: @escaping (MainDriver?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addIdentityExpiration(id: id, expirationDate: experationDate))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///add the date of the driver's license
    func addDriverLicenseDates(id:String,
                               driverLicenseDateData: DriverLiceseDateData,
                               completion: @escaping (MainDriver?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addDriverLicenseDates(id:id,
                                          issueDate: driverLicenseDateData.issueDate ?? "",
                                          expirationDate: driverLicenseDateData.expirationDate ?? "",
                                          drivingLicenseNumber: driverLicenseDateData.drivingLicenseNumber ?? ""))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///Upload image
    func imageUpload(image: UIImage,
                     id: String,
                     state: String,
                     completion: @escaping (MainDriver?, String?) -> Void)  {
            
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.upload(image: image, id: id, state: state))) { result in
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content, nil)
            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
            
        }
    }
    
    //Accept agreement
    func acceptAgreement(id: String, completion: @escaping (MainDriver?, String?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder(from: AuthAPI.acceptAgreement(id: id))) { result in
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil, nil)
                    return
                }
                print(result.message as Any)
                completion(result.content!, nil)

            case .failure(let error):
                print(error.description)
                completion(nil, error.description)
                break
            }
        }
    }
   
    ///Save user phone number to keychain
    func saveUserPhoneNumber(phoneCodeId: String?, number: String?) {
        if let phoneCodeId = phoneCodeId {
            keychainManager.savePhoneCodeId(id: phoneCodeId)
        }
        if let number = number {
            keychainManager.savePhoneNumber(number: number)
        }
    }
    
}







 


