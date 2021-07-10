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
    static let equipmentModel: [EquipmentModel] = [ EquipmentModel(equipmentImg: UIImage(named: "selected_tow_bar")!, equipmentName: "Tow Bar", didSelect: true),
                                                    EquipmentModel(equipmentImg: UIImage(named: "double_cabin")!, equipmentName: "Double cabin", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "tail_lift")!, equipmentName: "Tail Lift", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "gps_navigator")!, equipmentName: "GPS navigation", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "air_conditioning")!, equipmentName: "Air conditioning", didSelect: false)]
}


//MARK: ExteriorData
//MARK: --------------------
struct ExteriorData {
    static let exteriorModel: [ExteriorModel] = [ ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m"),
                                                  ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m"),
                                                  ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m")]
}

//MARK: DetailsData
//MARK: --------------------
struct DetailsData {
    static let detailsModel: [DetailsModel] = [ DetailsModel (image: #imageLiteral(resourceName: "1"), title: "3"),
                                                DetailsModel (image: #imageLiteral(resourceName: "2"), title: "Diesel"),
                                                DetailsModel (image: #imageLiteral(resourceName: "3"), title: "Manual"),
                                                DetailsModel (image: #imageLiteral(resourceName: "4"), title: "95 Kw / 130 Pk"),
                                                DetailsModel (image: #imageLiteral(resourceName: "5"), title: "7"),
                                                DetailsModel (image: #imageLiteral(resourceName: "6"), title: "5.91 x 2.42 x 2.82 m"),
                                                DetailsModel (image: #imageLiteral(resourceName: "7"), title: "1.20 m"),
                                                DetailsModel (image: #imageLiteral(resourceName: "8"), title: "Conditioning"),
                                                DetailsModel (image: #imageLiteral(resourceName: "9"), title: "GPS"),
                                                DetailsModel (image: #imageLiteral(resourceName: "10"), title: "Tow Bar"),
                                                DetailsModel (image: #imageLiteral(resourceName: "11"), title: "Slide door")
    ]
}


//MARK: TailLiftData
//MARK: --------------------
struct TailLiftData {
    static let tailLiftModel: [TailLiftModel] = [ TailLiftModel(value: "300 kg", title: "Tail lift lifting capacity"),
                                                  TailLiftModel(value: "190 cm", title: "Tail lift length"),
                                                  TailLiftModel(value: "68 cm", title: "Loading floor height")]
    
    
    
}

//MARK: InactiveLocationRangeData
//MARK: --------------------
struct InactiveLocationRangeData {
    static let inactiveLocationRangeModel: [InactiveLocationRangeModel] = [InactiveLocationRangeModel(latitude: 40.177200, longitude: 44.503490, radius: 2000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.226096280004306, longitude: 44.4105064496398, radius: 700 ),
                                                                           InactiveLocationRangeModel(latitude: 40.22622734367619, longitude: 44.48037263005972, radius: 1000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.098976432681816, longitude: 44.52054139226675, radius: 3000 ), InactiveLocationRangeModel(latitude:40.27347513165386, longitude: 44.50302891433239, radius: 1500 )]
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

//MARK: CategoryData
//MARK: --------------------
struct CategoryData {
    
    static let categoryModel: [CategoryModel] = [ CategoryModel(categoryName: "Vans",
                                                                data: [ CategoryCollectionData(carName: "Fiat Doblo L1H1", carImg: UIImage(named: "vans")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Doblo L1H1", carImg: UIImage(named: "vans")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Doblo L1H1", carImg: UIImage(named: "vans")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Doblo L1H1", carImg: UIImage(named: "vans")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Doblo L1H1", carImg: UIImage(named: "vans")!, isCarExist: true)]),
                                                  CategoryModel(categoryName: "Double Cabs",
                                                                data: [ CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: true)]),
                                                  CategoryModel(categoryName: "Box Trucks",
                                                                data: [ CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true)]),
                                                  CategoryModel(categoryName: "Trucks",
                                                                data: [ CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true)])
                                                  
                                                  
    ]
   
    
    static let avalableCategoryModel: [CategoryModel] = [CategoryModel(categoryName: "Double Cabs",
                                                                       data: [ CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Talento L1H1", carImg: UIImage(named: "fiat_telento")!, isCarExist: true)]),
                                                         CategoryModel(categoryName: "Box Trucks",
                                                                       data: [ CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true)]),
                                                         CategoryModel(categoryName: "Trucks",
                                                                       data: [ CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: false), CategoryCollectionData(carName: "Fiat Ducato met Laadklep", carImg: UIImage(named: "fiat_ducato")!, isCarExist: true)])
                                                         
                                                         
    ]
}


//MARK: TariffSlideData
//MARK: --------------------
struct TariffSlideData {
    static var tariffSlideModel: [TariffSlideModel] = [TariffSlideModel (title: "Hourly",
                                                                         bckgColor: color_hourly!,
                                                                         titleColor: color_main!,
                                                                         options:[TariffSlideModel(title: "Hourly", option: "2 Hours",
                                                                                                   bckgColor: color_hourly!,
                                                                                                   titleColor: color_main!, value: "€ 25,5"),
                                                                                  TariffSlideModel(title: "Hourly", option: "3 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 35,5"),
                                                                                  TariffSlideModel(title: "Hourly", option: "4 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 45,5"),
                                                                                  TariffSlideModel(title: "Hourly", option: "5 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 55,5"),
                                                                                  TariffSlideModel(title: "Hourly", option: "6 Hours", bckgColor: color_hourly!,titleColor: color_main!, value: "€ 65,5"),
                                                                                  TariffSlideModel(title: "Hourly", option: "10 Hours", bckgColor: color_hourly!, titleColor: color_main!, value: "€ 75,5")]),
                                                       TariffSlideModel (title: "Daily",
                                                                         bckgColor: color_days!,titleColor: .white,
                                                                         options:[TariffSlideModel(title: "Daily", option: "2 Days", bckgColor: color_days!,titleColor: .white, value: "€ 25,5"),
                                                                                                                       TariffSlideModel(title: "Daily", option: "3 Days", bckgColor: color_days!,titleColor: .white, value: "€ 35,5"),
                                                                                                                       TariffSlideModel(title: "Daily", option: "4 Days", bckgColor: color_days!,titleColor: .white, value: "€ 45,5"),
                                                                                                                       TariffSlideModel(title: "Daily", option: "5 Days", bckgColor: color_days!,titleColor: .white, value: "€ 55,5"),
                                                                                                                       TariffSlideModel(title: "Daily", option: "6 Days", bckgColor: color_days!,titleColor: .white, value: "€ 65,5")]),
                                                                               TariffSlideModel (title: "Weekly",
                                                                         bckgColor: color_weeks!,titleColor: color_main!,
                                                                         options:[TariffSlideModel(title: "Weekly", option: "1 Week", bckgColor: color_weeks!,titleColor: color_main!, value: "€ 25,5"),
                                                                                   TariffSlideModel(title: "Weekly", option: "2 Weeks",
                                                                                                    bckgColor: color_weeks!,titleColor: color_main!, value: "€ 35,5"),
                                                                                   TariffSlideModel(title: "Weekly", option: "3 Weeks", bckgColor: color_weeks!,titleColor: color_main!, value: "€ 45,5")]),
                                                                               TariffSlideModel (title: "Monthly",
                                                                                                 bckgColor:color_monthly!, titleColor: .white,
                                                                                                 options:[TariffSlideModel(title: "Monthly", option: "1 Month", bckgColor: color_monthly!,titleColor: .white, value: "€ 25,5")]),
                                                                               TariffSlideModel (title: "Flexible",
                                                                                                 bckgColor:color_flexible!, titleColor: color_main! )
                ]
}


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


struct AccessoriesData {
    static let accessoriesModel: [AccessoriesModel] = [
        AccessoriesModel(accessoryImg: #imageLiteral(resourceName: "straps"), accessoryName: "Tension straps for rent", accessoryPrice: 6.25, accessoryCount: 1),
        AccessoriesModel(accessoryImg: #imageLiteral(resourceName: "tape_dispenser"), accessoryName: "Tape dispenser for sale", accessoryPrice: 5.25, accessoryCount: 1)
    ]
}

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
        MyBkdModel(img: #imageLiteral(resourceName: "profile"), title: "My Account"),
        MyBkdModel(img: #imageLiteral(resourceName: "setting"), title: "Settings"),
        MyBkdModel(img: #imageLiteral(resourceName: "logOut"), title: "Log out")
    ]
}


     
struct  RegistrationBotData {
    static let registrationBotModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: "Hello. I’m the BKD robot. I help new users register fast and fun."),
        RegistrationBotModel(msgToFill: "Please, have with you your ID and Driving license. You must be at least 23 years old, have a valid Driving license for at least 2 years."),
        RegistrationBotModel(viewDescription: "button", userRegisterInfo: UserRegisterInfo(string: "Start")),
         RegistrationBotModel(msgToFill: "Let’s start with some personal details. Firstly, your First name.", msgToFillBold: "First name."),
        RegistrationBotModel(msgToFill: "P.S. You should use your real names on BKD."),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo(placeholder: "First Name")),
        RegistrationBotModel(msgToFill: "Now, mention your Last name.", msgToFillBold: "Last name"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo(placeholder: "Last Name")),
        RegistrationBotModel(msgToFill: "Insert your Phone number, please.", msgToFillBold: "Phone number"),
        RegistrationBotModel(viewDescription: "phone"),
        RegistrationBotModel(msgToFill: "Date of birth, maybe there are some promotions on your specific day.", msgToFillBold:"Date of birth"),
        RegistrationBotModel(viewDescription: "calendar"),
        RegistrationBotModel(msgToFill: "Now let’s add your Residential address details by mentioning:"),
        RegistrationBotModel(msgToFill: "Step 1 - Street name.", msgToFillBold: "Street name"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo( placeholder: "Street Name")),
        RegistrationBotModel(msgToFill: "Step 2 - House number.", msgToFillBold: "House number"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo(placeholder: "House number")),
        RegistrationBotModel(msgToFill: "Step 3 - Mailbox number, if you’re living in an apartment building.", msgToFillBold: "Mailbox number"),
        RegistrationBotModel( viewDescription: "mailbox", userRegisterInfo: UserRegisterInfo( placeholder:"Mailbox number")),
        RegistrationBotModel(msgToFill: "Step 4 - Country.", msgToFillBold: "Country"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo( placeholder:"Country")),
        RegistrationBotModel(msgToFill: "Step 5 - Zip number.", msgToFillBold: "Zip number"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo(placeholder: "Zip number")),
        RegistrationBotModel(msgToFill: "Step 6 - City.", msgToFillBold: "City"),
        RegistrationBotModel(viewDescription: "txtFl", userRegisterInfo: UserRegisterInfo( placeholder:"City")),
        RegistrationBotModel(msgToFill: "Your Address is registered successfully."),
        RegistrationBotModel(msgToFill: "Please, insert your National Register Number.", msgToFillBold: "National Register Number"),
        RegistrationBotModel(viewDescription: "national register"),
        RegistrationBotModel(msgToFill: "Last Registration Step is to attach Documents."),
        RegistrationBotModel(msgToFill: "Documents should be captured fully, as well as the information on them must be easily readable."),
        RegistrationBotModel(msgToFill: "First, take the front side photo of your Identity card (Photo holder side).", msgToFillBold: "front side photo of your Identity card"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your Identity card.", msgToFillBold: "back side photo of your Identity card"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, let’s add the Expiry date.", msgToFillBold: "Expiry date"),
        RegistrationBotModel(viewDescription: "calendar"),
        RegistrationBotModel(msgToFill: "Please, take the front side photo of your valid Driving license (Photo holder side).", msgToFillBold: "front side photo of your valid Driving license"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now, take the back side photo of your valid Driving license.", msgToFillBold: "back side photo of your valid Driving license"),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Now let’s add the Issue date of the Driving license.", msgToFillBold: "Issue date of the Driving license"),
        RegistrationBotModel(viewDescription: "calendar"),
        RegistrationBotModel(msgToFill: "Now let’s add the Expiry date of the Driving license.", msgToFillBold: "Expiry date of the Driving license"),
        RegistrationBotModel(viewDescription: "calendar"),
        RegistrationBotModel(msgToFill: "Last one left. Please, take a selfie photo with your valid Driving license, like this one.", msgToFillBold: "selfie photo with your valid Driving license"),
        RegistrationBotModel(examplePhoto: #imageLiteral(resourceName: "selfie")),
        RegistrationBotModel(viewDescription: "takePhoto"),
        RegistrationBotModel(msgToFill: "Please, examine carefully the online version of the licensed BKD Agreement. By clicking “Agree”, you agree to our Terms & Conditions.", msgToFillBold: "BKD Agreement"),
        RegistrationBotModel(viewDescription: "openDoc"),
        RegistrationBotModel(msgToFill: "By clicking “Confirm”, you confirm that the information provided above is true and correct.")
          
    ]
    
    
    
    static let completedAccountModel: [RegistrationBotModel] = [RegistrationBotModel(msgToFill: "Your BKD account is completed successfully. Within 24 hours You will receive an email confirming the Verification of the account, and will be able to make reservations."),
        RegistrationBotModel(msgToFill: "Enjoy the best rental experience with us")]
    
}
                                                   
