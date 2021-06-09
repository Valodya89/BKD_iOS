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


struct InactiveLocationRangeData {
    static let inactiveLocationRangeModel: [InactiveLocationRangeModel] = [InactiveLocationRangeModel(latitude: 40.177200, longitude: 44.503490, radius: 2000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.226096280004306, longitude: 44.4105064496398, radius: 700 ),
                                                                           InactiveLocationRangeModel(latitude: 40.22622734367619, longitude: 44.48037263005972, radius: 1000 ),
                                                                           InactiveLocationRangeModel(latitude: 40.098976432681816, longitude: 44.52054139226675, radius: 3000 ), InactiveLocationRangeModel(latitude:40.27347513165386, longitude: 44.50302891433239, radius: 1500 )]
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
