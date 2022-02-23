//
//  ApplicationSttings.swift
//  MimoBike
//
//  Created by Dose on 6/8/21.
//

import UIKit

final class ApplicationSettings {
    
    private(set) static var shared: ApplicationSettings = .init()
    private var storageManager: StorageManager = .init()
    private var network: SessionNetwork = .init()
    private let keychainManager = KeychainManager()
    
    private(set) var phoneCodes: [PhoneCode]?
    private(set) var pickerList: [String]?
    private(set) var settings:  Settings?
    private(set) var flexibleTimes: [FlexibleTimes]?
    private(set) var countryList: [Country]?

    private(set) var restrictedZones: [RestrictedZones]?
    var carsList: [String : [CarsModel]?]?
    var carTypes: [CarTypes]?
    var allCars: [CarsModel]?
    var account: Account?
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPhoneCodes),
                                               name: Constant.Notifications.LanguageUpdate,
                                               object: nil)
        if self.carTypes == nil {
            self.getCarTypes()
        }
        self.fetchPhoneCodes()
        self.getAvalableTimeList()
        self.getSettings()
        self.getRestrictedZones()
        self.getFlexibleTimes()
        self.getCountryList()
        self.getAllCars()
    }
}

extension ApplicationSettings {
    
//    @objc private func fetchCountryCodes() {
//
//        let language: String = storageManager.fetch(key: .language, type: String.self) ?? Locale.current.languageCode ?? "hy"
//
//        network.request(with: URLBuilder(from: AuthAPI.getCountryCode(language))) {[weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data):
//                guard let countryCodeResponce = try? JSONDecoder().decode(BaseResponseModel<[CountryCodeResponse]>.self, from: data) else {
//                    return
//                }
//                if let content = countryCodeResponce.content, countryCodeResponce.statusCode == 200 {
//                    print("countryCodeResponce === \(countryCodeResponce)")
//                    self.countryCodes = content
//                }
//            case .failure(let error):
//                break
//            }
//        }
//    }
    
    func getCarTypes()  {
        MainViewModel().getCarTypes { [self] (result) in
            carTypes = result
        }
    }
    
    /// get avalable time list
    func getAllCars() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarList)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                self.allCars =  result.content!
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    
    
    /// get phone codes
    @objc private func fetchPhoneCodes() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getPhoneCodes)) { (result) in
            
            switch result {
            case .success(let data):
                guard let phoneCodeList = BkdConverter<BaseResponseModel<[PhoneCode]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                
                if let content = phoneCodeList.content, phoneCodeList.statusCode == 200 {
                    print("countryCodeResponce === \(phoneCodeList)")
                    print(content as Any)
                    self.phoneCodes = content
                }
     
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    ///get account
    func getAccount(completion: @escaping (Account?) -> Void) {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAccount)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let account = BkdConverter<BaseResponseModel<Account>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                self.account =  account.content
                completion(self.account)
            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }    }
    
    
    /// get avalable time list
    func getAvalableTimeList() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getAvailableTimeList)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let timesList = BkdConverter<BaseResponseModel<[TimeModel]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                self.pickerList = self.getTimeList(model: timesList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    private func getTimeList(model: [TimeModel]) -> [String]? {

        var timeList:[String]? = []
        for item in model {
            timeList?.append(item.time)
        }
        return timeList
    }
    
    
    /// get working time list
    @objc private func getSettings() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getSettings)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let settings = BkdConverter<BaseResponseModel<Settings>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                self.settings = settings.content
               // completion(settings.content)
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    
    /// get flexible time list
    @objc private func getFlexibleTimes() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getFlexibleTimes)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let flexibleTimes = BkdConverter<BaseResponseModel<[FlexibleTimes]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                self.flexibleTimes = flexibleTimes.content
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    
    /// Get lst of restricted zones
    func getRestrictedZones(){
        CustomLocationViewModel().getRestrictedZones {[weak self] (result) in
            self?.restrictedZones = result
        }
    }

    ///Get country list
    func getCountryList() {
        RegistrationBotViewModel().getCountryList { [weak self] (response) in
            guard let self = self else { return }
            self.countryList = response
        }
    }
    
    
}

extension ApplicationSettings {
    static func construct() {
        _ = ApplicationSettings.shared
    }
}
