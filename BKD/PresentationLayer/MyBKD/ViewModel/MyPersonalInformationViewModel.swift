//
//  MyPersonalInformationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

enum PersonalInfoState: String {
    case name
    case surname
    case phoneNum
    case birthday
    case street
    case housNum
    case mailBox
    case country
    case zipNum
    case city
    case nationalRegNum
    case frontIdCard
    case backIdCard
    case expiryIdCard
    case frontDrivLic
    case backDrivLic
    case issueDrivLic
    case expiryDrivLic
    case selfie
    
    
}

final class MyPersonalInformationViewModel {
    
    ///Get main driver list
    func getMainDriverList(mainDriver: MainDriver) -> [MainDriverModel] {
        
        var mainDriverList: [MainDriverModel] = []
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.name, fieldValue: mainDriver.name, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.surname, fieldValue: mainDriver.surname, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.phoneNumber, fieldValue: mainDriver.phoneNumber, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.dateOfBirth, fieldValue: mainDriver.dateOfBirth, isPersonalinfo: true, isDate: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.streetName, fieldValue: mainDriver.street, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.houseNumber, fieldValue: mainDriver.house, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.mailbox, fieldValue: mainDriver.mailBox, isMailBox: true,  isBuilding: mainDriver.mailBox == "" ? false : true))
        //Country
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.country, fieldValue: mainDriver.countryId, isPersonalinfo: true))
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.zipNumber, fieldValue: mainDriver.zip, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.city, fieldValue: mainDriver.city, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.nationalRegisterNum, fieldValue: mainDriver.nationalRegisterNumber, isPersonalinfo: true))
      //  if mainDriver.
//        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.otherCountryRegisterNum, fieldValue: mainDriver.city))
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.identityCard, imageURL:mainDriver.identityFront?.getURL(), imageSide: Constant.Texts.frontSideIdCard, isPhoto: true))
        mainDriverList.append(MainDriverModel(imageURL:mainDriver.identityBack?.getURL(), imageSide: Constant.Texts.backSideIdCard, isPhoto: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDateIdCard, fieldValue: mainDriver.identityExpirationDate, isPersonalinfo: true, isDate: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.drivingLicense, imageURL:mainDriver.drivingLicenseFront?.getURL(), imageSide: Constant.Texts.frontDrivingLic, isPhoto: true))
        mainDriverList.append(MainDriverModel(imageURL:mainDriver.identityBack?.getURL(), imageSide: Constant.Texts.backDrivingLic, isPhoto: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.issueDrivingLic, fieldValue: mainDriver.drivingLicenseIssueDate, isPersonalinfo: true, isDate: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDrivingLic, fieldValue: mainDriver.drivingLicenseExpirationDate, isPersonalinfo: true, isDate: true))
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.selfieDrivingLic, imageURL:mainDriver.drivingLicenseSelfie?.getURL(), isPhoto: true))
        
        return mainDriverList
    }
    
    ///Get country name by id
    func getCountryName(id: String) -> String? {
        
        let country = ApplicationSettings.shared.countryList?.filter {
            $0.id == id
        }
        print(country ?? "")
       return country?.first?.country
    }
    
    ///Get date string
    func getDate(dateValue: String) -> String {
        let dateString = dateValue.components(separatedBy: "T")
        if dateString.count > 1 {
            let date = dateString[0].stringToDateWithoutTime()
            return date!.getDay() + " " + date!.getMonth(lng: "en") + " " + date!.getYear()
        }
        return dateValue
    }
}
