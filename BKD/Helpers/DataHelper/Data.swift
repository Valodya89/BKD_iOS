//
//  DropDownData.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit

//MARK: DropDownData
//MARK: --------------------
struct DropDownData {
    static let dropDownModel: [DropDownModel] = [
        DropDownModel(locationName: "BKD Office", seeMap: "See Map"),
        DropDownModel(locationName: "Parkin 1", seeMap: "See Map"),
        DropDownModel(locationName: "Parking 2", seeMap: "See Map")
    ]
    
    
    static let menuModel: [MenuModel] = [
        MenuModel(title: "About Us", imageName: "aboutUs"),
        MenuModel(title: "My Reservetions", imageName:"reservetions" ),
        MenuModel(title: "Costumer Service", imageName: "customer_service"),
        MenuModel(title: "Settings", imageName: "settings"),
        MenuModel(title: "Log Out", imageName: "logout")
    ]
}

//MARK: MenuData
//MARK: --------------------
struct MenuData {
    
    static let menuModel: [MenuModel] = [
        MenuModel(title: "About Us", imageName: "aboutUs"),
        MenuModel(title: "Language", imageName:"dutch" ),
        MenuModel(title: "Notifications", imageName:"notifications_menu" ),
        MenuModel(title: "FAQ", imageName:"faq" ),
        MenuModel(title: "Contact us", imageName: "customer_service"),
        MenuModel(title: "Log Out", imageName: "logout")
    ]
}

//MARK: EquipmentData
//MARK: --------------------
struct EquipmentData {
   static let equipmentModel: [EquipmentModel] = [ EquipmentModel(equipmentImg: UIImage(named: "selected_tow_bar")!, equipmentName: "Tow Bar", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "tail_lift")!, equipmentName: "Tail Lift", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "gps_navigator")!, equipmentName: "GPS navigation", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "air_conditioning")!, equipmentName: "Air conditioning", didSelect: false)]
}



//MARK: CarsData
//MARK: --------------------
struct CarsData {
    static let carModel:[CarModel] = [CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "vans")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_ducato")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),]
}


//MARK: CategoryCarouselData
//MARK: --------------------
struct CategoryCarouselData  {
    static let categoryCarouselModel: [CategoryCarouselModel] = [ CategoryCarouselModel(categoryName: "Trucks", CategoryImg: UIImage(named: "trucks_category")),
                                                                  CategoryCarouselModel(categoryName: "Frigo Vans", CategoryImg: UIImage(named: "frigo_vans_category")),
                                                                  CategoryCarouselModel(categoryName: "Vans", CategoryImg: UIImage(named: "vans_category")),
                                                                  CategoryCarouselModel(categoryName: "Double Cabs", CategoryImg: UIImage(named: "double_cabs_category")),
                                                                  CategoryCarouselModel(categoryName: "Box Trucks", CategoryImg: UIImage(named: "box_trucks_category"))]
    
}




//MARK: TariffSlideData
//MARK: --------------------
//struct TariffSlideData {
//    static var tariffSlideModel: [TariffSlideModel] = [TariffSlideModel (title: "Hourly",
//                                                                         bckgColor: color_hourly!,
//                                                                         titleColor: color_main!,
//                                                                         options:[TariffSlideModel(title: "Hourly", option: "2 Hours",
//                                                                                                   bckgColor: color_hourly!,
//                                                                                                   titleColor: color_main!, value: "€ 25,5"),
//                                                                                  TariffSlideModel(title: "Hourly", option: "3 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 35,5"),
//                                                                                  TariffSlideModel(title: "Hourly", option: "4 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 45,5"),
//                                                                                  TariffSlideModel(title: "Hourly", option: "5 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 55,5"),
//                                                                                  TariffSlideModel(title: "Hourly", option: "6 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 65,5"),
//                                                                                  TariffSlideModel(title: "Hourly", option: "10 Hours", bckgColor: color_hourly!, titleColor: color_main!, value: "€ 75,5")]),
//                                                       TariffSlideModel (title: "Daily",
//                                                                         bckgColor: color_days!,titleColor: .white,
//                                                                         options:[TariffSlideModel(title: "Daily", option: "2 Days", bckgColor: color_days!,titleColor: .white, value: "€ 25,5"),
//                                                                                                                       TariffSlideModel(title: "Daily", option: "3 Days", bckgColor: color_days!,titleColor: .white, value: "€ 35,5"),
//                                                                                                                       TariffSlideModel(title: "Daily", option: "4 Days", bckgColor: color_days!,titleColor: .white, value: "€ 45,5"),
//                                                                                                                       TariffSlideModel(title: "Daily", option: "5 Days", bckgColor: color_days!,titleColor: .white, value: "€ 55,5"),
//                                                                                                                       TariffSlideModel(title: "Daily", option: "6 Days", bckgColor: color_days!,titleColor: .white, value: "€ 65,5")]),
//                                                                               TariffSlideModel (title: "Weekly",
//                                                                         bckgColor: color_weeks!,titleColor: color_main!,
//                                                                         options:[TariffSlideModel(title: "Weekly", option: "1 Week", bckgColor: color_weeks!,titleColor: color_main!, value: "€ 25,5"),
//                                                                                   TariffSlideModel(title: "Weekly", option: "2 Weeks",
//                                                                                                    bckgColor: color_weeks!,titleColor: color_main!, value: "€ 35,5"),
//                                                                                   TariffSlideModel(title: "Weekly", option: "3 Weeks", bckgColor: color_weeks!,titleColor: color_main!, value: "€ 45,5")]),
//                                                                               TariffSlideModel (title: "Monthly",
//                                                                                                 bckgColor:color_monthly!, titleColor: .white,
//                                                                                                 options:[TariffSlideModel(title: "Monthly", option: "1 Month", bckgColor: color_monthly!,titleColor: .white, value: "€ 25,5")]),
//                                                                               TariffSlideModel (title: "Flexible",
//                                                                                                 bckgColor:color_flexible!, titleColor: color_main! )
//                ]
//}


//MARK: RentalConditionsData
//MARK: --------------------
struct RentalConditionsData {
    static let rentalConditionsModel: [RentalConditionsModel] = [
        RentalConditionsModel(img: #imageLiteral(resourceName: "deposit"), title: "Deposit amount from", value: "350"),
        RentalConditionsModel(img: #imageLiteral(resourceName: "2"), title: "Fuel consumption is included in the rental price"),
        RentalConditionsModel(img: #imageLiteral(resourceName: "min_age"), title: "Minimum driver age ", value: "23 years"),
        RentalConditionsModel(img: #imageLiteral(resourceName: "max_age"), title: "Maximum driver age", value: "70 years"),
        RentalConditionsModel(img: #imageLiteral(resourceName: "card"), title: "Minimum Belgian driving license active period:", value: "2 years")]
}

//MARK: BkdAdvantagesData
//MARK: --------------------
struct BkdAdvantagesData {
    static let bkdAdvantagesModel: [BkdAdvantagesModel] = [BkdAdvantagesModel(title1: "Available 24/7",
                                                                              title2: "Personalized approach",
                                                                              title3: "Your case our challenge",
                                                                              title4: "Fast & safe" ) ]
}


struct ReserveData {
    static let reserveModel: [ReserveModel] = [ReserveModel(headerTitle: "Additional driver",
                                                            fullName: "Name Surname"),
                                               ReserveModel(headerTitle: "Accessories",
                                                            accessorieTitle: "Tape dispenser for sale",
                                                            accessorieImg: #imageLiteral(resourceName: "tape_dispenser")),
                                               ReserveModel( accessorieTitle: "tension straps for rent",
                                                             accessorieCount: "x2",
                                                             accessorieImg: #imageLiteral(resourceName: "straps"))
    ]
}


//struct AccessoriesData {
//    static let accessoriesModel: [AccessoriesModel] = [
//        AccessoriesModel(accessoryImg: #imageLiteral(resourceName: "straps"), accessoryName: "Tension straps for rent", accessoryPrice: 6.25, accessoryCount: 1),
//        AccessoriesModel(accessoryImg: #imageLiteral(resourceName: "tape_dispenser"), accessoryName: "Tape dispenser for sale", accessoryPrice: 5.25, accessoryCount: 1)
//    ]
//}

struct MyDriversData {
    static let myDriversModel : [MyDriversModel] = [ MyDriversModel(fullname: "Jon Smit",
                  licenciNumber: "Driving license number 5345",
                          price: 30.5),
        MyDriversModel(fullname: "Anjel Cavieres",
                  licenciNumber: "Driving license number 5346",
                          price: 25.75),
        MyDriversModel(fullname: "Marcel Aliaga",
                  licenciNumber: "Driving license number 5335",
                       price: 50.25),
    ]
}


struct MyBkdData {
    static let myBkdModel: [MyBkdModel] = [
        MyBkdModel(img: #imageLiteral(resourceName: "personal_info"), title: "My personal information"),
        MyBkdModel(img: #imageLiteral(resourceName: "my_drivers"), title: "My Drivers"),
        MyBkdModel(img: #imageLiteral(resourceName: "account"), title: "My account")
    ]
}


  
//struct PhoneCodeData {
//    static let phoneCodeModel: [PhoneCodeModel] = [PhoneCodeModel(country: "Dutch", code: "+31", flag: #imageLiteral(resourceName: "dutch"), phoneFormat: "##-###-####", validFormPattern: 9),
//        PhoneCodeModel(country: "Franch", code: "+33", flag: #imageLiteral(resourceName: "french"), phoneFormat: "##-##-##-##-##", validFormPattern: 10),
//        PhoneCodeModel(country: "English", code: "+44", flag: #imageLiteral(resourceName: "english"), phoneFormat: "####-####-##", validFormPattern: 10)]
//}



struct  RegistrationBotData {
    static let registrationBotModel: [RegistrationBotModel] = [
       /* RegistrationBotModel(viewDescription: "national register"),*/
        
        RegistrationBotModel(msgToFill: "Hello. I’m the BKD robot. I help new users register fast and fun."),
        RegistrationBotModel(msgToFill: "Please, have with you your ID and Driving license. You must be at least 23 years old, have a valid Driving license for at least 2 years."),
        RegistrationBotModel(viewDescription: Constant.Texts.button, userRegisterInfo: UserRegisterInfo(string: Constant.Texts.start)),
         RegistrationBotModel(msgToFill: "Let’s start with some personal details. Firstly, your First name.", msgToFillBold: "First name."),
        RegistrationBotModel(msgToFill: "P.S. You should use your real names on BKD."),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.name)),
        RegistrationBotModel(msgToFill: "Now, mention your Last name.", msgToFillBold: "Last name"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.surname)),
        RegistrationBotModel(msgToFill: "Insert your Phone number, please.", msgToFillBold: "Phone number"),
        RegistrationBotModel(viewDescription: Constant.Texts.phone),
        RegistrationBotModel(msgToFill: "Date of birth, maybe there are some promotions on your specific day.", msgToFillBold:"Date of birth"),
        RegistrationBotModel(viewDescription: Constant.Texts.calendar, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.dateOfBirth)),
        RegistrationBotModel(msgToFill: "Now let’s add your Residential address details by mentioning:"),
        RegistrationBotModel(msgToFill: "Step 1 - Street name.", msgToFillBold: "Street name"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.streetName)),
        RegistrationBotModel(msgToFill: "Step 2 - House number.", msgToFillBold: "House number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.houseNumber)),
        RegistrationBotModel(msgToFill: "Step 3 - Mailbox number, if you’re living in an apartment building.", msgToFillBold: "Mailbox number"),
        RegistrationBotModel( viewDescription: Constant.Texts.mailbox, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.mailboxNumber)),
        RegistrationBotModel(msgToFill: "Step 4 - Country.", msgToFillBold: "Country"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.country)),
        RegistrationBotModel(msgToFill: "Step 5 - Zip number.", msgToFillBold: "Zip number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.zipNumber)),
        RegistrationBotModel(msgToFill: "Step 6 - City.", msgToFillBold: "City"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.city)),
        RegistrationBotModel(msgToFill: "Your Address is registered successfully."),
        RegistrationBotModel(msgToFill: "Please, insert your National Register Number.", msgToFillBold: "National Register Number"),
        RegistrationBotModel(viewDescription: Constant.Texts.nationalRegister),
        RegistrationBotModel(msgToFill: "Last Registration Step is to attach Documents."),
        RegistrationBotModel(msgToFill: "Documents should be captured fully, as well as the information on them must be easily readable."),
        RegistrationBotModel(msgToFill: "First, take the front side photo of your Identity card (Photo holder side).", msgToFillBold: Constant.Texts.IF_text),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your Identity card.", msgToFillBold: Constant.Texts.IB_text),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, let’s add the Expiry date.", msgToFillBold: "Expiry date"),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDate),
        RegistrationBotModel(msgToFill: "Now, let’s add the Driving license number.", msgToFillBold: "Driving license number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.drivingLicenseNumber)),
        RegistrationBotModel(msgToFill: "Please, take the front side photo of your valid Driving license (Photo holder side).", msgToFillBold:Constant.Texts.DLF_text),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your valid Driving license.", msgToFillBold: Constant.Texts.DLB_text),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now let’s add the Issue date of the Driving license.", msgToFillBold: Constant.Texts.license_issue_text),
        RegistrationBotModel(viewDescription: Constant.Texts.issueDateDrivingLicense, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.issueDateDrivingLicense)),
        RegistrationBotModel(msgToFill: "Now let’s add the Expiry date of the Driving license.", msgToFillBold: "Expiry date of the Driving license"),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDateDrivingLicense),
        RegistrationBotModel(msgToFill: "Last one left. Please, take a selfie photo with your valid Driving license, like this one.", msgToFillBold: "selfie photo with your valid Driving license"),
        RegistrationBotModel(examplePhoto: #imageLiteral(resourceName: "selfie")),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Please, examine carefully the online version of the licensed BKD Agreement. By clicking “Agree”, you agree to our Terms & Conditions.", msgToFillBold: "BKD Agreement"),
        RegistrationBotModel(viewDescription: "openDoc"),
        RegistrationBotModel(msgToFill: "By clicking “Confirm”, you confirm that the information provided above is true and correct.")
          
    ]
    
    
    static let registrationDriverModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: "Hello. I’m the BKD robot. I help new users register fast and fun."),
        RegistrationBotModel(msgToFill: "To register new drivers for your account, please, have them with you, along with their ID and Driving license. Additional drivers must be at least 23 years old, have a valid Driving license for at least 2 years"),
        RegistrationBotModel(viewDescription: Constant.Texts.button, userRegisterInfo: UserRegisterInfo(string: "Start")),
         RegistrationBotModel(msgToFill: "Let’s start with some personal details. Firstly, your additional driver’s First name.", msgToFillBold: "First name"),
        RegistrationBotModel(msgToFill: "P.S. You should use real names on BKD."),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.name)),
        RegistrationBotModel(msgToFill: "Now, mention your additional driver’s Last name.", msgToFillBold: "Last name"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.surname)),
        RegistrationBotModel(msgToFill: "Insert your additional driver’s Phone number, please.", msgToFillBold: "Phone number"),
        RegistrationBotModel(viewDescription:  Constant.Texts.phone),
        RegistrationBotModel(msgToFill: "Date of birth, maybe there are some promotions on your additional driver’s specific day.", msgToFillBold:"Date of birth"),
        RegistrationBotModel(viewDescription: Constant.Texts.calendar, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.dateOfBirth)),
        RegistrationBotModel(msgToFill: "Now let’s add your additional driver’s address details by mentioning:"),
        RegistrationBotModel(msgToFill: "Step 1 - Street name.", msgToFillBold: Constant.Texts.streetName),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder: Constant.Texts.streetName)),
        RegistrationBotModel(msgToFill: "Step 2 - House number.", msgToFillBold: "House number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.houseNumber)),
        RegistrationBotModel(msgToFill: "Step 3 - Mailbox number, if you’re living in an apartment building.", msgToFillBold: "Mailbox number"),
        RegistrationBotModel( viewDescription:Constant.Texts.mailbox, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.mailboxNumber)),
        RegistrationBotModel(msgToFill: "Step 4 - Country.", msgToFillBold: "Country"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.country)),
        RegistrationBotModel(msgToFill: "Step 5 - Zip number.", msgToFillBold: "Zip number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.zipNumber)),
        RegistrationBotModel(msgToFill: "Step 6 - City.", msgToFillBold: "City"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo( placeholder:Constant.Texts.city)),
        RegistrationBotModel(msgToFill: "Your additional driver’s Address is registered successfully."),
        RegistrationBotModel(msgToFill: "Please, insert your additional driver’s National Register number.", msgToFillBold: "National Register Number"),
        RegistrationBotModel(viewDescription: Constant.Texts.nationalRegister),
        RegistrationBotModel(msgToFill: "Last Registration Step is to attach Documents."),
        RegistrationBotModel(msgToFill: "Documents should be captured fully, as well as the information on them must be easily readable."),
        RegistrationBotModel(msgToFill: "First, take the front side photo of your additional driver’s Identity card (Photo holder side).", msgToFillBold: "front side photo of your additional driver’s Identity card"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your additional driver’s Identity card.", msgToFillBold: "back side photo of your additional driver’s Identity card"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, let’s add the Expiry date.", msgToFillBold: "Expiry date"),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDate),
        RegistrationBotModel(msgToFill: "Now, let’s add the Driving license number.", msgToFillBold: "Driving license number"),
        RegistrationBotModel(viewDescription: Constant.Texts.txtFl, userRegisterInfo: UserRegisterInfo(placeholder: Constant.Texts.drivingLicenseNumber)),
        RegistrationBotModel(msgToFill: "Please, take the front side photo of your additional driver’s valid Driving license (Photo holder side).", msgToFillBold: "front side photo of your additional driver’s valid Driving license"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your additional driver’s valid Driving license.", msgToFillBold: "back side photo of your additional driver’s valid Driving license"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now let’s add the Issue date of the Driving license.", msgToFillBold: "Issue date of the Driving license"),
        RegistrationBotModel(viewDescription: Constant.Texts.issueDateDrivingLicense),
        RegistrationBotModel(msgToFill: "Now let’s add the Expiry date of the Driving license.", msgToFillBold: "Expiry date of the Driving license"),
        RegistrationBotModel(viewDescription: Constant.Texts.expiryDateDrivingLicense),
        RegistrationBotModel(msgToFill: "Last one left. Please, ask your additional driver take a selfie photo with the valid Driving license, like this one.", msgToFillBold: "selfie photo with the valid Driving license"),
        RegistrationBotModel(examplePhoto: #imageLiteral(resourceName: "selfie")),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Please, examine carefully the online version of the licensed BKD Agreement. By clicking “Agree”, you agree to our Terms & Conditions.", msgToFillBold: "BKD Agreement"),
        RegistrationBotModel(viewDescription: "openDoc"),
        RegistrationBotModel(msgToFill: "By clicking “Confirm”, you confirm that the information provided above is true and correct.")
    ]
    
    static let completedAccountModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: "Your BKD account is completed successfully. Within 24 hours You will receive an email confirming the Verification of the account, and will be able to make reservations."),
        RegistrationBotModel(msgToFill: "Enjoy the best rental experience with us")]
    
    static let completedDriverAccountModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: "Your BKD account for Additional driver is completed successfully. Within 24 hours You will receive an email confirming the Verification of the account, and will be able to add the driver to your reservations."),
        RegistrationBotModel(msgToFill: "Enjoy the best rental experience with us")]
}
                                                   


//MARK: - Payment
struct PaymentTypeData {
  static  let paymentTypeModel: [PaymentTypes] = [ PaymentTypes(title: nil, image: UIImage(named: "credit_card")),
        PaymentTypes(title: nil, image: UIImage(named: "bancontact")),
        PaymentTypes(title: nil, image: UIImage(named: "apple_pay")),
        PaymentTypes(title: nil, image: UIImage(named: "paypal")),
        PaymentTypes(title: "Kaartlazer", image: nil)
       
    ]
}

//MARK: - ReservationWithReservedPaidModel

struct ReservationWithReservedPaidData {
    static let reservationWithReservedPaidModel:[ReservationWithReservedPaidModel] = [ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.startRide),
        ReservationWithReservedPaidModel(isActiveStartRide: true, isRegisterNumber: true, myReservationState: MyReservationState.startRide),
       ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.payDistancePrice),
        ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.maykePayment),
        ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.payRentalPrice),
         ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.stopRide),
       ReservationWithReservedPaidModel(isActiveStartRide: false, isRegisterNumber: false, myReservationState: MyReservationState.driverWaithingApproval)
    ]
}

//MARK: PaymentStatusModel
struct PaymentStatusData {
    static let paymentStatusModel:[PaymentStatusModel] = [PaymentStatusModel(status: "Reserved & Paid", paymentType: "via Office Terminal - Confirmed"),
            PaymentStatusModel(status: "Rental price paid", paymentType: "via Apple pay"),
                                                          PaymentStatusModel(status: "Pay later", isActivePaymentBtn: true, price: 57.79, paymentButtonType: "Make payment"),
                                                          PaymentStatusModel(status: "Deposit paid", paymentType: "via Credit Card", isActivePaymentBtn: true, price: 77.42, paymentButtonType: "Pay rental price")]
}


//MARK: --StartRideData
struct StartRideData {
    static let startRideModel:[StartRideModel] = [
        StartRideModel (damageImg: UIImage(named: "camera") ?? UIImage(), damageName: "Damage Name"),
        StartRideModel (damageImg: nil, damageName: nil)]
    
}


//MARK: -- PriceModel
struct PriceData {
    static let priceModel:[PriceModel] = [PriceModel(priceTitle: "Price", price: 5.00),
          PriceModel(priceTitle: "Accsessories", price: 0.00),
           PriceModel(priceTitle: "Additional driver", price: 0.00)]
}
