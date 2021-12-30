//
//  MyPersonalInformationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

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
}
