//
//  DropDownData.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit



//MARK: -- MenuData
struct MenuData {
    
    static let menuModel: [MenuModel] = [
        MenuModel(title: Constant.Texts.aboutUs, imageName: "aboutUs"),
       /* MenuModel(title: Constant.Texts.language, imageName:"dutch" ),*/
        MenuModel(title: Constant.Texts.notifications, imageName:"notifications_menu" ),
        MenuModel(title: Constant.Texts.faq, imageName:"faq" ),
        MenuModel(title: Constant.Texts.contactUs, imageName: "customer_service"),
        MenuModel(title: Constant.Texts.logout, imageName: "logout")
    ]
}

//MARK: -- EquipmentData

//EquipmentModel(equipmentImg: UIImage(named: "double_cabin")!, equipmentName: "Double cabin", didSelect: false),
struct EquipmentData {
    static let equipmentModel: [EquipmentModel] = [ EquipmentModel(equipmentImg: UIImage(named: "selected_tow_bar")!, equipmentName: Constant.Texts.towBar, didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "tail_lift")!, equipmentName: Constant.Texts.tailLift, didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "gps_navigator")!, equipmentName: Constant.Texts.gpsNavi, didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "air_conditioning")!, equipmentName: Constant.Texts.airCond, didSelect: false)]
}



//MARK: -- CarsData
struct CarsData {
    static let carModel:[CarModel] = [CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "vans")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_ducato")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),]
}



//MARK: -- RentalConditionsData
struct RentalConditionsData {
    static let rentalConditionsModel: [RentalConditionsModel] = [
        RentalConditionsModel(img: #imageLiteral(resourceName: "deposit"), title: Constant.Texts.depositAmount, value: "0.0"),
        RentalConditionsModel(img: #imageLiteral(resourceName: "2"), title: Constant.Texts.moreFuelConsumption),
        RentalConditionsModel(img: #imageLiteral(resourceName: "min_age"), title: Constant.Texts.minAges, value: Constant.Texts.years23),
        RentalConditionsModel(img: #imageLiteral(resourceName: "max_age"), title: Constant.Texts.maxAges, value: Constant.Texts.years70),
        RentalConditionsModel(img: #imageLiteral(resourceName: "card"), title: Constant.Texts.minBelgianPeriod, value: Constant.Texts.years2)]
    
}

//MARK: -- BkdAdvantagesData
struct BkdAdvantagesData {
    static let bkdAdvantagesModel: [BkdAdvantagesModel] = [BkdAdvantagesModel(title1: Constant.Texts.available,
                                                                              title2: Constant.Texts.personalizedApproach,
                                                                              title3: Constant.Texts.ourChallange,
                                                                              title4: Constant.Texts.fastSafe ) ]
    
}





struct MyBkdData {
    static let myBkdModel: [MyBkdModel] = [
        MyBkdModel(img: #imageLiteral(resourceName: "personal_info"), title: Constant.Texts.myPersonalInfo),
        MyBkdModel(img: #imageLiteral(resourceName: "my_drivers"), title: Constant.Texts.myDrivers),
        MyBkdModel(img: #imageLiteral(resourceName: "account"), title: Constant.Texts.myAccount)
    ]
}

struct  RegistrationBotData {
    static let registrationBotModel: [RegistrationBotModel] = [
       /* RegistrationBotModel(viewDescription: "national register"),*/
        
        RegistrationBotModel(msgToFill: Constant.Texts.bkd_robot_hello),
        RegistrationBotModel(msgToFill: Constant.Texts.driving_lic_obligation
                            ),
        RegistrationBotModel(viewDescription: Constant.Texts.button, userRegisterInfo: UserRegisterInfo(string: Constant.Texts.start)),
        RegistrationBotModel(msgToFill: Constant.Texts.first_name_message, msgToFillBold: Constant.Texts.firstName),
        RegistrationBotModel(msgToFill: Constant.Texts.name_instructions),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.name)),
        RegistrationBotModel(msgToFill: Constant.Texts.last_name_message, msgToFillBold: Constant.Texts.lastName),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.surname)),
        RegistrationBotModel(msgToFill: Constant.Texts.phone_num_message, msgToFillBold: Constant.Texts.phoneNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.phone),
        RegistrationBotModel(msgToFill: Constant.Texts.date_birth_message, msgToFillBold: Constant.Texts.dateOfBirth),
        RegistrationBotModel(viewDescription: Constant.Texts.calendar, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.dateOfBirth)),
        RegistrationBotModel(msgToFill: Constant.Texts.address_message),
        RegistrationBotModel(msgToFill: Constant.Texts.street_name, msgToFillBold: Constant.Texts.streetName),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.streetName)),
        RegistrationBotModel(msgToFill: Constant.Texts.house_num, msgToFillBold: Constant.Texts.houseNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.houseNumber)),
        RegistrationBotModel(msgToFill: Constant.Texts.mailbox_num, msgToFillBold: Constant.Texts.mailboxNumber),
        RegistrationBotModel( viewDescription: Constant.Texts.mailbox, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.mailboxNumber)),
        RegistrationBotModel(msgToFill: Constant.Texts.country_message, msgToFillBold: Constant.Texts.country),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.country)),
        RegistrationBotModel(msgToFill: Constant.Texts.zip_num, msgToFillBold: Constant.Texts.zipNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.zipNumber)),
        RegistrationBotModel(msgToFill: Constant.Texts.city_message, msgToFillBold: Constant.Texts.city),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.city)),
        RegistrationBotModel(msgToFill: Constant.Texts.add_register_success),
        RegistrationBotModel(msgToFill: Constant.Texts.national_register_message, msgToFillBold: Constant.Texts.nationalRegisterNum),
        RegistrationBotModel(viewDescription: Constant.Texts.nationalRegister),
        RegistrationBotModel(msgToFill: Constant.Texts.attach_doc_message),
        RegistrationBotModel(msgToFill: Constant.Texts.attach_doc_obligation),
        RegistrationBotModel(msgToFill: Constant.Texts.id_front_message, msgToFillBold: Constant.Texts.IF_text),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
        RegistrationBotModel(msgToFill: Constant.Texts.id_back_message, msgToFillBold: Constant.Texts.IB_text),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
        RegistrationBotModel(msgToFill: Constant.Texts.exp_date_message, msgToFillBold: Constant.Texts.expiryDate),
        RegistrationBotModel(viewDescription: Constant.Texts.expiry_date),
        RegistrationBotModel(msgToFill: Constant.Texts.driving_lic_num_message, msgToFillBold: Constant.Texts.licenseNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.drivingLicenseNumber)),
        RegistrationBotModel(msgToFill: Constant.Texts.lic_front_message, msgToFillBold:Constant.Texts.DLF_text),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
        RegistrationBotModel(msgToFill: Constant.Texts.lic_back_message, msgToFillBold: Constant.Texts.DLB_text),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
        RegistrationBotModel(msgToFill: Constant.Texts.lic_issue_date_message, msgToFillBold: Constant.Texts.license_issue_text),
        RegistrationBotModel(viewDescription: Constant.Texts.issueDateDrivingLicense, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.issueDateDrivingLicense)),
        RegistrationBotModel(msgToFill: Constant.Texts.lic_exp_date_message, msgToFillBold: Constant.Texts.expiryDrivingLic),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDateDrivingLicense),
        RegistrationBotModel(msgToFill: Constant.Texts.selfie_message, msgToFillBold: Constant.Texts.selfi_driving_lic),
        RegistrationBotModel(examplePhoto: #imageLiteral(resourceName: "selfie")),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
        RegistrationBotModel(msgToFill: Constant.Texts.agree_message, msgToFillBold: Constant.Texts.bkdAgree),
        RegistrationBotModel(viewDescription: Constant.Keys.open_doc),
        RegistrationBotModel(msgToFill: Constant.Texts.confirm_message)
          
    ]
    
    
    static let registrationDriverModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: Constant.Texts.bkd_robot_hello),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.register_driver_message),
                                                                  RegistrationBotModel(viewDescription: Constant.Texts.button, userRegisterInfo: UserRegisterInfo(string: Constant.Texts.start)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_first_name, msgToFillBold: Constant.Texts.firstName),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_name_obligation),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.name)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_last_name, msgToFillBold: Constant.Texts.lastName),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.surname)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_phone_number, msgToFillBold: Constant.Texts.phoneNumber),
        RegistrationBotModel(viewDescription:  Constant.Texts.phone),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_birth, msgToFillBold:Constant.Texts.dateOfBirth),
        RegistrationBotModel(viewDescription: Constant.Texts.calendar, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.dateOfBirth)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_address),
        RegistrationBotModel(msgToFill: Constant.Texts.street_name, msgToFillBold: Constant.Texts.streetName),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.streetName)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.house_num, msgToFillBold: Constant.Texts.houseNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.houseNumber)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.mailbox_num, msgToFillBold: Constant.Texts.mailboxNumber),
        RegistrationBotModel( viewDescription:Constant.Texts.mailbox, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.mailboxNumber)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.country_message, msgToFillBold: Constant.Texts.country),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.country)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.zip_num, msgToFillBold: Constant.Texts.zipNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.zipNumber)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.city_message, msgToFillBold: Constant.Texts.city),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.city)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_address_success),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_national_register_num, msgToFillBold: Constant.Texts.nationalRegisterNum),
        RegistrationBotModel(viewDescription: Constant.Texts.nationalRegister),
        RegistrationBotModel(msgToFill: Constant.Texts.attach_doc_message),
        RegistrationBotModel(msgToFill: Constant.Texts.attach_doc_obligation),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.front_addDrivers_id, msgToFillBold: Constant.Texts.fron_addDriving_id_bold),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.back_addDrivers_Id, msgToFillBold: Constant.Texts.back_addDriving_Id_bold),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.exp_date_message, msgToFillBold: Constant.Texts.expiryDate),
        RegistrationBotModel(viewDescription: Constant.Texts.expiry_date),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driving_lic_num_message, msgToFillBold: Constant.Texts.licenseNumber),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.drivingLicenseNumber)),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.fron_addDrivers_lic, msgToFillBold: Constant.Texts.fron_addDriving_lic_bold),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.back_addDrivers_lic, msgToFillBold: Constant.Texts.back_addDriving_lic_bold),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.lic_issue_date_message, msgToFillBold:Constant.Texts.license_issue_text),
        RegistrationBotModel(viewDescription: Constant.Texts.issueDateDrivingLicense),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.lic_exp_date_message, msgToFillBold: Constant.Texts.expiryDrivingLic),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDateDrivingLicense),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.driver_selfie_message, msgToFillBold: Constant.Texts.selfi_driving_lic),
        RegistrationBotModel(examplePhoto: #imageLiteral(resourceName: "selfie")),
        RegistrationBotModel(viewDescription: Constant.Keys.take_photo),
                                                                  RegistrationBotModel(msgToFill: Constant.Texts.agree_message, msgToFillBold: Constant.Texts.bkdAgree),
                                                                  RegistrationBotModel(viewDescription: Constant.Keys.open_doc),
        RegistrationBotModel(msgToFill: Constant.Texts.confirm_message)
    ]
    
    static let completedAccountModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: Constant.Texts.account_success_message),
                                                                RegistrationBotModel(msgToFill: Constant.Texts.enjoy_message)]
    
    static let completedDriverAccountModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: Constant.Texts.driver_success_message),
        RegistrationBotModel(msgToFill: Constant.Texts.enjoy_message)]
}
                                                   


//MARK: - Payment
struct PaymentTypeData {
  static  let paymentTypeModel: [PaymentTypes] = [ PaymentTypes(title: nil, image: UIImage(named: "credit_card")),
        PaymentTypes(title: nil, image: UIImage(named: "bancontact")),
        PaymentTypes(title: nil, image: UIImage(named: "apple_pay")),
        PaymentTypes(title: nil, image: UIImage(named: "paypal"))
//        PaymentTypes(title: "Kartlizer", image: nil)
       
    ]
}

//MARK: -- ReservationWithReservedPaidModel

struct ReservationWithReservedPaidData {
    static let reservationWithReservedPaidModel:[ReservationWithReservedPaidModel] = [ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.startRide),
        ReservationWithReservedPaidModel(isActiveStartRide: true, isRegisterNumber: true, myReservationState: MyReservationState.startRide),
       ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.payDistancePrice),
        ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.maykePayment),
        ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.payRentalPrice),
         ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.stopRide),
       ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.waithingApproval)
    ]
}




//MARK: -- Notification
struct NotificationData {
    static let notificationModel: [NotificationModel] = [NotificationModel(text: "Notification can be of various types.", date: "20/03/21", time: "10:00"), NotificationModel(text: "Notifications can be of various types but for the user it is only the message text. ", date: "14/02/21", time: "15:00"), NotificationModel(text: "Notifications can be of various types but for the user it is only the message text that is different in meaning and it expresses the Notification type itself.", date: "17/05/21", time: "13:00"), NotificationModel(text: "Notifications can be of various types but for the user it is only the message text. ", date: "14/02/21", time: "15:00"),]
}
