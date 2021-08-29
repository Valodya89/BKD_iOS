//
//  RegistrationBotViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-07-21.
//

import UIKit

class RegistrationBotViewModel: NSObject {
    
   
    

//    /// get phone codes
//    func getPhoneCodeList(completion: @escaping ([PhoneCode]) -> Void) {
//        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getPhoneCodes)) { (result) in
//            
//            switch result {
//            case .success(let data):
//                guard let phoneCodeList = BkdConverter<BaseResponseModel<[PhoneCode]>>.parseJson(data: data as Any) else {
//                    print("error")
//                    return
//                }
//                print(phoneCodeList.content as Any)
//                completion(phoneCodeList.content!)
//            case .failure(let error):
//                print(error.description)
//                break
//            }
//        }
//    }
    
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
    
    /// add Personla Data
    func addPersonlaData(personlaData: PersonalData,  completion: @escaping (PersonalDriver?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.addPersonalData(name: personlaData.name!, surname: personlaData.surname!, phoneNumber: personlaData.phoneNumber!, dateOfBirth: personlaData.dateOfBirth!, street: personlaData.street!, house: personlaData.house!, mailBox: personlaData.mailBox ?? "", countryId: personlaData.countryId!, zip: personlaData.zip!, city: personlaData.city!, nationalRegisterNumber: personlaData.nationalRegisterNumber!))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<PersonalDriver>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.message as Any)
                completion(result.content!)
                //completion(RegistrationState(rawValue: result.message)!)

            case .failure(let error):
                print(error.description)
                completion(nil)
                //completion(State.Error)

                break
            }
        }
    }
    
    func imageUpload(image: UIImage, state: String, completion: @escaping (String) -> Void)  {
            
        SessionNetwork.init().request(with: URLBuilder(from: ImageUploadAPI.upload(image: image, state: state))) { result in
            print(result)
                completion("")
            }
            
        }
    
    
}







 


