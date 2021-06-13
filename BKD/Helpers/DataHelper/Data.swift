//
//  DropDownData.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit

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

struct EquipmentData {
    static let equipmentModel: [EquipmentModel] = [ EquipmentModel(equipmentImg: UIImage(named: "selected_tow_bar")!, equipmentName: "Tow Bar", didSelect: true),
                                                    EquipmentModel(equipmentImg: UIImage(named: "double_cabin")!, equipmentName: "Double cabin", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "tail_lift")!, equipmentName: "Tail Lift", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "gps_navigator")!, equipmentName: "GPS navigation", didSelect: false),
                                                    EquipmentModel(equipmentImg: UIImage(named: "air_conditioning")!, equipmentName: "Air conditioning", didSelect: false)]
}

struct ExteriorData {
    static let exteriorModel: [ExteriorModel] = [ ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m"),
                                                  ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m"),
                                                  ExteriorModel(exterior: "5.91 x 2.42 x 2.82 m")]
}

struct DetailsData {
    static let detailsModel: [DetailsModel] = [ DetailsModel (image: #imageLiteral(resourceName: "1"), title: "3"),
                                                DetailsModel (image: #imageLiteral(resourceName: "2"), title: "Diesel"),
                                                DetailsModel (image: #imageLiteral(resourceName: "3"), title: "Manual"),
                                                DetailsModel (image: #imageLiteral(resourceName: "4"), title: "95 Kw / 130 Pk"),
                                                DetailsModel (image: #imageLiteral(resourceName: "5"), title: "7"),
                                                DetailsModel (image: #imageLiteral(resourceName: "6"), title: "5.91 x 2.42 x 2.82 m"),
                                                DetailsModel (image: #imageLiteral(resourceName: "7"), title: "1.20 m"),
                                                DetailsModel (image: #imageLiteral(resourceName: "air_conditioning"), title: "Conditioning"),
                                                DetailsModel (image: #imageLiteral(resourceName: "gps_navigator"), title: "GPS"),
                                                DetailsModel (image: #imageLiteral(resourceName: "10"), title: "Tow Bar"),
                                                DetailsModel (image: #imageLiteral(resourceName: "11"), title: "Slide door")
    ]
}

struct TailLiftData {
    static let tailLiftModel: [TailLiftModel] = [ TailLiftModel(value: "300 kg", title: "Tail lift lifting capacity"),
                                                  TailLiftModel(value: "190 cm", title: "Tail lift length"),
                                                  TailLiftModel(value: "68 cm", title: "Loading floor height")]
    
    
    
}


//struct TariffSlideData {
//    static var tariffSlideModel: [TariffSlideModel] = [TariffSlideModel (title: "Hourly",
//                                                                         bckgColor: UIColor(rgb: 0x7E88BA),
//                                                                         details:[TariffSlideDetailsModel(title: "2 days", value: "€ 25,5", bckgColor: .yellow),
//    TariffSlideDetailsModel(title: "3 days", value: "€ 35,5", bckgColor: .yellow),
//    TariffSlideDetailsModel(title: "4 days", value: "€ 45,5", bckgColor: .yellow),
//    TariffSlideDetailsModel(title: "5 days", value: "€ 55,5", bckgColor: .yellow),
//    TariffSlideDetailsModel(title: "6 days", value: "€ 65,5", bckgColor: .yellow),
//    TariffSlideDetailsModel(title: "7 days", value: "€ 75,5", bckgColor: .yellow)]),
//                                                       TariffSlideModel (title: "Daily",
//                                                                         bckgColor: UIColor(rgb: 0xE9C96B),
//                                                                                                              details:[TariffSlideDetailsModel(title: "2 days", value: "€ 25,5", bckgColor: .gray),
//                TariffSlideDetailsModel(title: "3 days", value: "€ 35,5", bckgColor: .gray),
//                TariffSlideDetailsModel(title: "4 days", value: "€ 45,5", bckgColor: .gray),
//                TariffSlideDetailsModel(title: "5 days", value: "€ 55,5", bckgColor: .gray),
//                TariffSlideDetailsModel(title: "6 days", value: "€ 65,5", bckgColor: .gray),
//                TariffSlideDetailsModel(title: "7 days", value: "€ 75,5", bckgColor: .gray)]),
//                                                                               TariffSlideModel (title: "Weekly",
//                                                                         bckgColor: UIColor(rgb: 0x8998AA),
//                                                                          details:[TariffSlideDetailsModel(title: "2 days", value: "€ 25,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "3 days", value: "€ 35,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "4 days", value: "€ 45,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "5 days", value: "€ 55,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "6 days", value: "€ 65,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "7 days", value: "€ 75,5", bckgColor: .red)]),
//                                                                               TariffSlideModel (title: "Monthly",
//                                                                         bckgColor: UIColor(rgb: 0x80CBC4),
//                                                                          details:[TariffSlideDetailsModel(title: "2 days", value: "€ 25,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "3 days", value: "€ 35,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "4 days", value: "€ 45,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "5 days", value: "€ 55,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "6 days", value: "€ 65,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "7 days", value: "€ 75,5", bckgColor: .red)] ),
//                                                                               TariffSlideModel (title: "Flexible",
//                                                                         bckgColor: UIColor(rgb: 0x4A5CC7),
//                                                                           details:[TariffSlideDetailsModel(title: "2 days", value: "€ 25,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "3 days", value: "€ 35,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "4 days", value: "€ 45,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "5 days", value: "€ 55,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "6 days", value: "€ 65,5", bckgColor: .red),
//                TariffSlideDetailsModel(title: "7 days", value: "€ 75,5", bckgColor: .red)] ),               
//                ]
//}

struct InactiveLocationRangeData {
    static let inactiveLocationRangeModel: [InactiveLocationRangeModel] = [InactiveLocationRangeModel(latitude: 40.177200, longitude: 44.503490, radius: 2000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.226096280004306, longitude: 44.4105064496398, radius: 700 ),
                                                                           InactiveLocationRangeModel(latitude: 40.22622734367619, longitude: 44.48037263005972, radius: 1000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.098976432681816, longitude: 44.52054139226675, radius: 3000 ), InactiveLocationRangeModel(latitude:40.27347513165386, longitude: 44.50302891433239, radius: 1500 )]
}

struct CarsData {
    static let carModel:[CarModel] = [CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "vans")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_ducato")),
                                      CarModel(carImage: #imageLiteral(resourceName: "fiat_telento")),]
}

struct CategoryCarouselData  {
    static let categoryCarouselModel: [CategoryCarouselModel] = [ CategoryCarouselModel(categoryName: "Trucks", CategoryImg: UIImage(named: "trucks_category")),
                                                                  CategoryCarouselModel(categoryName: "Frigo Vans", CategoryImg: UIImage(named: "frigo_vans_category")),
                                                                  CategoryCarouselModel(categoryName: "Vans", CategoryImg: UIImage(named: "vans_category")),
                                                                  CategoryCarouselModel(categoryName: "Double Cabs", CategoryImg: UIImage(named: "double_cabs_category")),
                                                                  CategoryCarouselModel(categoryName: "Box Trucks", CategoryImg: UIImage(named: "box_trucks_category"))]
    
}


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



struct TariffSlideData {
    static var tariffSlideModel: [TariffSlideModel] = [TariffSlideModel (title: "Hourly",
                                                                         bckgColor: UIColor(rgb: 0x7E88BA),
                                                                         details:[TariffSlideModel(title: "2 days", bckgColor: .yellow, value: "€ 25,5"),
                                                                                  TariffSlideModel(title: "3 days", bckgColor: .yellow, value: "€ 35,5"),
                                                                                  TariffSlideModel(title: "4 days", bckgColor: .yellow, value: "€ 45,5"),
                                                                                  TariffSlideModel(title: "5 days", bckgColor: .yellow, value: "€ 55,5"),
                                                                                  TariffSlideModel(title: "6 days", bckgColor: .yellow, value: "€ 65,5"),
                                                                                  TariffSlideModel(title: "7 days", bckgColor: .yellow, value: "€ 75,5")]),
                                                       TariffSlideModel (title: "Daily",
                                                                         bckgColor: UIColor(rgb: 0xE9C96B),
                                                                         details:[TariffSlideModel(title: "2 days", bckgColor: .gray, value: "€ 25,5"),
                                                                                                                       TariffSlideModel(title: "3 days", bckgColor: .gray, value: "€ 35,5"),
                                                                                                                       TariffSlideModel(title: "4 days", bckgColor: .gray, value: "€ 45,5"),
                                                                                                                       TariffSlideModel(title: "5 days", bckgColor: .gray, value: "€ 55,5"),
                                                                                                                       TariffSlideModel(title: "6 days", bckgColor: .gray, value: "€ 65,5"),
                                                                                                                       TariffSlideModel(title: "7 days", bckgColor: .gray, value: "€ 75,5")]),
                                                                               TariffSlideModel (title: "Weekly",
                                                                         bckgColor: UIColor(rgb: 0x8998AA),
                                                                         details:[TariffSlideModel(title: "2 days", bckgColor: .red, value: "€ 25,5"),
                                                                                   TariffSlideModel(title: "3 days", bckgColor: .red, value: "€ 35,5"),
                                                                                   TariffSlideModel(title: "4 days", bckgColor: .red, value: "€ 45,5"),
                                                                                   TariffSlideModel(title: "5 days", bckgColor: .red, value: "€ 55,5"),
                                                                                   TariffSlideModel(title: "6 days", bckgColor: .red, value: "€ 65,5"),
                                                                                   TariffSlideModel(title: "7 days", bckgColor: .red, value: "€ 75,5")]),
                                                                               TariffSlideModel (title: "Monthly",
                                                                         bckgColor: UIColor(rgb: 0x80CBC4),
                                                                         details:[TariffSlideModel(title: "2 days", bckgColor: .red, value: "€ 25,5"),
                                                                                   TariffSlideModel(title: "3 days", bckgColor: .red, value: "€ 35,5"),
                                                                                   TariffSlideModel(title: "4 days", bckgColor: .red, value: "€ 45,5"),
                                                                                   TariffSlideModel(title: "5 days", bckgColor: .red, value: "€ 55,5"),
                                                                                   TariffSlideModel(title: "6 days", bckgColor: .red, value: "€ 65,5"),
                                                                                   TariffSlideModel(title: "7 days", bckgColor: .red, value: "€ 75,5")] ),
                                                                               TariffSlideModel (title: "Flexible",
                                                                         bckgColor: UIColor(rgb: 0x4A5CC7),
                                                                         details:[TariffSlideModel(title: "2 days", bckgColor: .red, value: "€ 25,5"),
                                                                                    TariffSlideModel(title: "3 days", bckgColor: .red, value: "€ 35,5"),
                                                                                    TariffSlideModel(title: "4 days", bckgColor: .red, value: "€ 45,5"),
                                                                                    TariffSlideModel(title: "5 days", bckgColor: .red, value: "€ 55,5"),
                                                                                    TariffSlideModel(title: "6 days", bckgColor: .red, value: "€ 65,5"),
                                                                                    TariffSlideModel(title: "7 days", bckgColor: .red, value: "€ 75,5")] ),
                ]
}
