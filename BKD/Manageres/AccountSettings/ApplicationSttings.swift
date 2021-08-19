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
    
    private(set) var phoneCodes: [PhoneCode]?
    private(set) var pickerList: [String]?
    private(set) var workingTimes: WorkingTimes?
    private(set) var restrictedZones: [RestrictedZones]?
    var carsList:[String : [CarsModel]?]?
    var carTypes:[CarTypes]?

    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPhoneCodes), name: Constant.Notifications.LanguageUpdate, object: nil)
        if carTypes == nil {
            getCarTypes()
        }
        fetchPhoneCodes()
        getAvalableTimeList()
        getWorkingTimes()
        getRestrictedZones()
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
    @objc private func getWorkingTimes() {
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getWorkingTimes)) { [self] (result) in
            
            switch result {
            case .success(let data):
                guard let workingTime = BkdConverter<BaseResponseModel<WorkingTimes>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                self.workingTimes = workingTime.content
               // completion(workingTimes.content)
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
    
    
    
}

extension ApplicationSettings {
    static func construct() {
        _ = ApplicationSettings.shared
    }
}
