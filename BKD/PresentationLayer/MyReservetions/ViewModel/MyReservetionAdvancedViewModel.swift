//
//  MyReservation.swift
//  BKD
//
//  Created by Karine Karapetyan on 27-12-21.
//

import Foundation

final class MyReservetionAdvancedViewModel {
    
    /// Get rent accessories
    func getRentAccessories(accessoriesToRent: [AccessoriesToRent]?) -> [AccessoriesEditModel]? {
        
        var rentAccesores: [AccessoriesEditModel]? = []
        let accessories = ApplicationSettings.shared.accessories
        accessories?.forEach({ accessore in
            accessoriesToRent?.forEach({ accessorieToRent in
                if accessorieToRent.id == accessore.id {
                    let newElement = AccessoriesEditModel(id: accessore.id, imageUrl: accessore.image.getURL(), name: accessore.name, count: Int(accessorieToRent.count), maxCount: accessore.maxCount, isAdded: true, price: accessore.price, totalPrice: nil)
                    rentAccesores?.append(newElement)
                }
            })
        })
        return rentAccesores
    }
}
