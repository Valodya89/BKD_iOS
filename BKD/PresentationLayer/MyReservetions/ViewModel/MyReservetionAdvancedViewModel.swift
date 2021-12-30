//
//  MyReservation.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-12-21.
//

import Foundation

final class MyReservetionAdvancedViewModel {
    
    /// Get rent accessories
    func getRentAccessories(rent: Rent, complition: @escaping ([AccessoriesEditModel]?)-> ()) {
        
        let  accessoriesViewModel =  AccessoriesViewModel()
        var rentAccesores: [AccessoriesEditModel]? = []
        
        accessoriesViewModel.getAccessories(carID: rent.carDetails.id) { result, err in
            guard let accessories = result else {return}
            
            for accessore in accessories {
                
                for currRentAccessore in rent.accessories! {
                    
                    if currRentAccessore.id == accessore.id {
                        let newElement = AccessoriesEditModel(id: accessore.id, imageUrl: accessore.image.getURL(), name: accessore.name, count: Int(currRentAccessore.count), maxCount: accessore.maxCount, isAdded: true, price: accessore.price, totalPrice: nil)
                        rentAccesores?.append(newElement)
                    }
                }
            }
            complition(rentAccesores)
        }
    }
    
    
//    ///Get  all additional driver current list
//    func getAllAdditionalDrives(rent: Rent) -> [DriverToRent] {
//        var additionalDrivers = rent.additionalDrivers
//        additionalDrivers?.insert(rent.driver, at: 0)
//        //additionalDrivers?.removeAll(where: { $0.id == (rent.currentDriver!.id) })
//        return additionalDrivers ?? []
//    }
}
