//
//  RegistrationBotViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-07-21.
//

import UIKit

enum RegistrationState: String {
    case PERSONAL_DATA
    case IDENTITY_FRONT
    case IDENTITY_BACK
    case IDENTITY_EXPIRATION
    case DRIVING_LICENSE_FRONT
    case DRIVING_LICENSE_BACK
    case DRIVING_LICENSE_DATES
    case DRIVING_LICENSE_SELFIE
    case AGREEMENT_ACCEPTED
}

//enum DocumentState: String {
//    case DLF = "0"
//    case DLB = "1"
//    case DLS = "2"
//    case IF = "3"
//    case IB = "4"
//}



class RegistrationBotViewModel: NSObject {
    
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
                if mainDriver.state == "PERSONAL_DATA" {
                    completion(tableData)
                    return
                }
            }
            else if tableData[i].viewDescription ==  Constant.Texts.take_photo &&
                tableData[i - 1].msgToFillBold == Constant.Texts.IF_text {
                if mainDriver.identityFront != nil {
                    tableData[i].userRegisterInfo = UserRegisterInfo(imageURL: mainDriver.identityFront!.getURL()!, isFilled: true)
                }
                if mainDriver.state == "IDENTITY_FRONT" {
                    completion(tableData)
                    return
                }
            }
            
        }
        
        completion(tableData)
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
                         completion: @escaping (MainDriver?) -> Void) {
        

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addPersonalData(id: id, name: personlaData.name!, surname: personlaData.surname!, phoneNumber: personlaData.phoneNumber!, dateOfBirth: personlaData.dateOfBirth!, street: personlaData.street!, house: personlaData.house!, mailBox: personlaData.mailBox ?? "", countryId: personlaData.countryId!, zip: personlaData.zip!, city: personlaData.city!, nationalRegisterNumber: personlaData.nationalRegisterNumber!))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.message as Any)
                completion(result.content!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    
    ///add identity experation date
    //Optional("ACCOUNTS_wrong_feeling_state_identity_back_empty")

    func addIdentityExpiration(experationDate: String,
                               completion: @escaping (String?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addIdentityExpiration(expirationDate: experationDate))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.message as Any)
                completion(result.message as String)
               // completion(result.content!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///add the date of the driver's license
    func addDriverLicenseDates(driverLicenseDateData: DriverLiceseDateData,
                               completion: @escaping (String?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addDriverLicenseDates(issueDate: driverLicenseDateData.issueDate ?? "", expirationDate: driverLicenseDateData.expirationDate ?? ""))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<EmptyModel>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.message as Any)
                completion(result.message as String)
               // completion(result.content!)

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
                     completion: @escaping (MainDriver?) -> Void)  {
            
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.upload(image: image, id: id, state: state))) { result in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<MainDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.message as Any)
               // completion(result.message as String)
                completion(result.content!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
            
        }
    }
    
    
}







 


