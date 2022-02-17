//
//  MyPersonalInformationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

struct EditPhoto {
    let image: UIImage
    let state: String
}

final class MyPersonalInformationViewModel {
    
    lazy var registrationBotVM = RegistrationBotViewModel()
    private var editPhotos: [EditPhoto] = []
    private var editPhotoCounter: Int = 0
    
    public var didConfirmEditing: (()-> Void)?
    
    
    ///Get main driver list
    func getMainDriverList(mainDriver: MainDriver, completion: @escaping (([MainDriverModel]) -> ())) {
        
        var mainDriverList: [MainDriverModel] = []
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.name, fieldValue: mainDriver.name, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.surname, fieldValue: mainDriver.surname, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.phoneNumber, fieldValue: mainDriver.phoneNumber, phoneCode: mainDriver.phoneCode, isPersonalinfo: true, isPhone: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.dateOfBirth, fieldValue: mainDriver.dateOfBirth, isPersonalinfo: true, isDate: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.streetName, fieldValue: mainDriver.street, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.houseNumber, fieldValue: mainDriver.house, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.mailbox, fieldValue: mainDriver.mailBox, isMailBox: true,  isBuilding: mainDriver.mailBox == "" ? false : true))
        //Country
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.country, fieldValue: mainDriver.countryId, isPersonalinfo: true))
        
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.zipNumber, fieldValue: mainDriver.zip, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.city, fieldValue: mainDriver.city, isPersonalinfo: true))
        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.nationalRegisterNum, fieldValue: mainDriver.nationalRegisterNumber, isPersonalinfo: true))
        
        //        //Other country register number
        //        if mainDriver.nationalRegisterNumber
        //        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.otherCountryRegisterNum, fieldValue: mainDriver.otherCountryRegisterNum, isPersonalinfo: true))
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        
       
            
//            mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.identityCard, imageURL: mainDriver.identityFront?.getURL(), imageSide: Constant.Texts.frontSideIdCard, isPhoto: true))
//
//
//                mainDriverList.append(MainDriverModel(imageURL: mainDriver.identityBack?.getURL(), imageSide: Constant.Texts.backSideIdCard, isPhoto: true))
//
//                mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDateIdCard, fieldValue: mainDriver.identityExpirationDate, isPersonalinfo: true, isDate: true))
//
//
//                    mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.drivingLicense, imageURL: mainDriver.drivingLicenseFront?.getURL(), imageSide: Constant.Texts.frontDrivingLic, isPhoto: true))
//
//
//        mainDriverList.append(MainDriverModel(imageURL: mainDriver.identityBack?.getURL(), imageSide: Constant.Texts.backDrivingLic, isPhoto: true))
//
//                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.issueDrivingLic, fieldValue: mainDriver.drivingLicenseIssueDate, isPersonalinfo: true, isDate: true))
//
//                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDrivingLic, fieldValue: mainDriver.drivingLicenseExpirationDate, isPersonalinfo: true, isDate: true))
//
//                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.drivingLicenseNumber, fieldValue: mainDriver.drivingLicenseNumber, isPersonalinfo: true, isDate: true))
//
//
//                            mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.selfieDrivingLic, imageURL: mainDriver.drivingLicenseSelfie?.getURL(), isPhoto: true))
//
//        completion(mainDriverList)
        
        
        UIImage.loadFrom(url: (mainDriver.identityFront?.getURL())!) { img in

            mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.identityCard, image:img, imageSide: Constant.Texts.frontSideIdCard, isPhoto: true))

            UIImage.loadFrom(url: (mainDriver.identityBack?.getURL())!) { img in
                mainDriverList.append(MainDriverModel(image:img, imageSide: Constant.Texts.backSideIdCard, isPhoto: true))

                mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDateIdCard, fieldValue: mainDriver.identityExpirationDate, isPersonalinfo: true, isDate: true))

                UIImage.loadFrom(url: (mainDriver.drivingLicenseFront?.getURL())!) { img in
                    mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.drivingLicense, image:img, imageSide: Constant.Texts.frontDrivingLic, isPhoto: true))

                    UIImage.loadFrom(url: (mainDriver.identityBack?.getURL())!) { img in
                        mainDriverList.append(MainDriverModel(image:img, imageSide: Constant.Texts.backDrivingLic, isPhoto: true))

                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.issueDrivingLic, fieldValue: mainDriver.drivingLicenseIssueDate, isPersonalinfo: true, isDate: true))

                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.expiryDrivingLic, fieldValue: mainDriver.drivingLicenseExpirationDate, isPersonalinfo: true, isDate: true))

                        mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.drivingLicenseNumber, fieldValue: mainDriver.drivingLicenseNumber, isPersonalinfo: true, isDate: true))

                        UIImage.loadFrom(url: (mainDriver.drivingLicenseSelfie?.getURL())!) { img in
                            mainDriverList.append(MainDriverModel(fieldName: Constant.Texts.selfieDrivingLic, image:img, isPhoto: true))
                            myGroup.leave()
                        }
                    }
                }
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            completion(mainDriverList)
        }
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
            return date?.getDateByFormat() ?? ""
        }
        return dateValue
    }
    
    
    
    ///Get current phone code
    func getCurrnetPhoneCode(code: String) -> PhoneCode? {
        
        guard let phoneCodeList = ApplicationSettings.shared.phoneCodes else {
            return nil
        }
        let phone = phoneCodeList.filter({$0.code == code}).first
        
//        for phone in phoneCodeList {
//            if phone.code ==  {
//                return phone
//            }
//        }
        return phone
    }
    
    ///Check if all filed are filled
    func areFilledFields(mainDrivers: [MainDriverModel]?) -> Bool {
        guard let mainDrivers = mainDrivers else { return true}
        for mainDriver in mainDrivers {
            if (mainDriver.fieldValue == nil || mainDriver.fieldValue?.count == 0) &&
                mainDriver.fieldName != Constant.Texts.mailbox &&
                !mainDriver.isPhoto
            {
                return false
            }
        }
        return true
    }
    
    ///Is edited personal information
    func isEditedPersonalInfo(newMainDrivers: [MainDriverModel], oldMainDrivers: [MainDriverModel]) -> Bool {
        
        for i in 0 ..< 10 {
            
            let newValue = newMainDrivers[i].fieldValue
            let oldValue = oldMainDrivers[i].fieldValue
             
           
            if newValue != oldValue {
                return true
            }
        }
        let changeCode = newMainDrivers[2].phoneCode != oldMainDrivers[2].phoneCode
        return changeCode
    }
    
    ///Is edited driving license information
    func isEditedDrivingLicenseInfo (newMainDrivers: [MainDriverModel], oldMainDrivers: [MainDriverModel]) -> Bool {
        //will add one more
        for i in 16 ..< 19  {
            let newValue = newMainDrivers[i].fieldValue
            let oldValue = oldMainDrivers[i].fieldValue
            if newValue != oldValue {
                return true
            }
        }
        return false
    }
    
    ///Is edited identity expiration information
    func isEditedIdExpiration (newMainDrivers: [MainDriverModel], oldMainDrivers: [MainDriverModel]) -> Bool {
        //will add one more
        let newValue = newMainDrivers[13].fieldValue
        let oldValue = oldMainDrivers[13].fieldValue
        if newValue != oldValue {
            return true
        }
        return false
    }
    
    ///Is edited any photo information
    func isEditedPhotos (newMainDrivers: [MainDriverModel], oldMainDrivers: [MainDriverModel]) -> Bool {
        //will add one more
        var isEdit = false
        for i in 11 ..< newMainDrivers.count  {
            let editImg = newMainDrivers[i].editImg
            if editImg != nil {
                isEdit = true
                let state = getImageUploadState(index: i)
                editPhotos.append(EditPhoto(image: editImg!, state: state.rawValue))
            }
        }
        return isEdit
    }
    
    
    ///Get state if image uploading
    func getImageUploadState(index: Int) -> ImageUploadState{
        switch index {
        case 11:
            return ImageUploadState.IF
        case 12:
            return ImageUploadState.IB
        case 14:
            return ImageUploadState.DLF
        case 15:
            return ImageUploadState.DLB
        case 19:
            return ImageUploadState.DLS
        default:
            return ImageUploadState.DLS
        }
    }
    
    ///Confirm edited information
    func confirmEditedInfo(driverId: String, newMainDrivers: [MainDriverModel], oldMainDrivers: [MainDriverModel]) {
        
        //Personal info
        if isEditedPersonalInfo(newMainDrivers: newMainDrivers,
                                oldMainDrivers: oldMainDrivers) {
            
            guard let personlaData = self.getPersonalData(driver: newMainDrivers) else { return}
            
            registrationBotVM.addPersonlaData(id: driverId,
                                              personlaData: personlaData) { result, err in
                guard let _ = result else {
                    if let _ = err {
                    }
                    return }
                // driving license
                self.editDrivingLicensesinfo(id: driverId,
                                             newMainDrivers: newMainDrivers,
                                             oldMainDrivers: oldMainDrivers)
            }
            
        } else { // driving license
            self.editDrivingLicensesinfo(id: driverId,
                                         newMainDrivers: newMainDrivers,
                                         oldMainDrivers: oldMainDrivers)
        }
        
    }
    
    ///Edeit driving license information
    func editDrivingLicensesinfo(id: String,
                                 newMainDrivers: [MainDriverModel],
                                 oldMainDrivers: [MainDriverModel]) {
        
        //Driving licence
        if isEditedDrivingLicenseInfo(newMainDrivers: newMainDrivers,
                                      oldMainDrivers: oldMainDrivers) {
            
            let driverLicense = getDriverLicenseDateData(driver: newMainDrivers)
            
            guard let driverLicense = driverLicense else {return}
            registrationBotVM.addDriverLicenseDates(id: id, driverLicenseDateData:  driverLicense) { result in
                guard let _ = result else {return}
                //Exoeration date
                self.editExperationDate(id: id,
                                        newMainDrivers: newMainDrivers,
                                        oldMainDrivers: oldMainDrivers)
                
            }
        } else {
            //Exoeration date
            self.editExperationDate(id: id,
                                    newMainDrivers: newMainDrivers,
                                    oldMainDrivers: oldMainDrivers)
        }
    }
    
    ///Edit experation information
    func editExperationDate (id: String,
                             newMainDrivers: [MainDriverModel],
                             oldMainDrivers: [MainDriverModel]) {
        //Experation date
        if self.isEditedIdExpiration(newMainDrivers: newMainDrivers,
                                     oldMainDrivers: oldMainDrivers) {
            
            let date = changeDateFormateIfNeeded(dateStr: newMainDrivers[13].fieldValue!)
            registrationBotVM.addIdentityExpiration(id: id,
                                                    experationDate: date) { result in
                guard let _  = result else {return}
                //edit Photos
                if self.isEditedPhotos(newMainDrivers: newMainDrivers,
                                       oldMainDrivers: oldMainDrivers) {
                    self.editPhotosInfo(id: id)
                } else {
                    self.didConfirmEditing?()
                }
            }
        } else if self.isEditedPhotos(newMainDrivers: newMainDrivers,
                                      oldMainDrivers: oldMainDrivers) {
            //edit Photos
            self.editPhotosInfo(id: id)
        } else {
            self.didConfirmEditing?()
        }
    }
    
    ///Edit Potos in form ation
    func editPhotosInfo(id: String) {
        
        let editPhoto = editPhotos[editPhotoCounter]
        registrationBotVM.imageUpload(image: editPhoto.image, id: id, state: editPhoto.state) { result, err in
            guard let _ = result else {return}
            self.editPhotoCounter += 1
            if self.editPhotoCounter < self.editPhotos.count {
                self.editPhotosInfo(id: id)
            } else {
                self.didConfirmEditing?()
            }
            
        }
    }
    
    
    ///Get personal data for driver draft
    func getPersonalData(driver: [MainDriverModel]) -> PersonalData? {
        let dateOfBirt = changeDateFormateIfNeeded(dateStr: driver[3].fieldValue!)
        let personalData:PersonalData? = PersonalData(name: driver[0].fieldValue,
                                                      surname: driver[1].fieldValue,
                                                      phoneCode: driver[2].phoneCode,
                                                      phoneNumber: driver[2].fieldValue,
                                                      dateOfBirth: dateOfBirt,
                                                      street: driver[4].fieldValue,
                                                      house: driver[5].fieldValue,
                                                      mailBox: driver[6].fieldValue, countryId: driver[7].fieldValue,
                                                      zip: driver[8].fieldValue,
                                                      city: driver[9].fieldValue,
                                                      nationalRegisterNumber: driver[10].fieldValue)
        return personalData
    }
    
    ///Get driver license data for driver draft
    func getDriverLicenseDateData(driver: [MainDriverModel]) -> DriverLiceseDateData? {
        
        let issueDate = changeDateFormateIfNeeded(dateStr: driver[16].fieldValue!)
        let expirationDate = changeDateFormateIfNeeded(dateStr: driver[17].fieldValue!)
        return DriverLiceseDateData(issueDate: issueDate,
                                    expirationDate: expirationDate,
                                    drivingLicenseNumber: driver[18].fieldValue)
    }
    
    ///Will change date formate if it needs
    func changeDateFormateIfNeeded(dateStr: String) -> String {
        let date = getDate(dateValue: dateStr)
        return date.convertDateFormater()
    }
    
    ///Check is phone number edited
    func isPhoneNumberEdited(newMainDrivers: [MainDriverModel],
                             oldMainDrivers: [MainDriverModel]) -> Bool {
        return (newMainDrivers[2].fieldValue !=  oldMainDrivers[2].fieldValue) ||
        (newMainDrivers[2].phoneCode !=  oldMainDrivers[2].phoneCode)
    }
}
