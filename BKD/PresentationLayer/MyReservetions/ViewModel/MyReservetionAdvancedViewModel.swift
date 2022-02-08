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
    
    
///Get rents price list
    func getPriceList(rent: Rent?) -> (price: [PriceModel], totalPrice: Double) {
        
       var prices:[PriceModel] = []
       var total = 0.0
       
       let price = rent?.price.rentDurationPrice ?? 0.0
       prices.append(PriceModel(priceTitle: Constant.Texts.price, price: price))
        total = price
        
       if (rent?.price.specialOfferPercentage ?? 0) > 0
       {
           let offertPercentage = rent?.price.specialOfferPercentage ?? 0.0
           let carOffertPrice = price.discountPercentage(offertPercentage)
           prices.append(PriceModel(priceTitle: Constant.Texts.specialOffer, price: carOffertPrice, discountPrecent: offertPercentage))
           total = carOffertPrice
       }
       
       let totalLocation = rent?.price.locationPrice ?? 0.0
       if totalLocation > 0.0 {
           prices.append(PriceModel(priceTitle: Constant.Texts.customLocation, price: totalLocation))
           total += totalLocation
       }
       
       let totalNoWorkingTotal = rent?.price.nonWorkingHourPrice ?? 0.0
       if totalNoWorkingTotal > 0.0 {
           prices.append(PriceModel(priceTitle: Constant.Texts.additionalService, price: totalNoWorkingTotal))
           total += totalNoWorkingTotal
       }
    
       let totalAccessoriesPrice = rent?.price.accessoriesPrice ?? 0.0
       if totalAccessoriesPrice > 0.0 {
           prices.append(PriceModel(priceTitle: Constant.Texts.accessories, price: totalAccessoriesPrice))
           total += totalAccessoriesPrice
       }
       
        let totalAdditionalDriversPrice = rent?.price.additionalDriverPrice ?? 0.0
       if totalAdditionalDriversPrice > 0.0 {
           prices.append(PriceModel(priceTitle: Constant.Texts.additionalDriver, price: totalAdditionalDriversPrice))
           total += totalAdditionalDriversPrice
       }
       
//        let depositPrice = rent?.price.depositPrice ?? 0.0
//       if depositPrice > 0 {
//           prices.append(PriceModel(priceTitle: Constant.Texts.deposit, price: depositPrice))
//           total += depositPrice
//       }
       
       return (prices, total)
       
    }
}


//"specialOfferPercentage": 2.0,
//               "depositPrice": 150.0,
//               "nonWorkingHourPrice": 30.0,
//               "rentDurationPrice": 200.0,
//               "additionalDriverPrice": 12.0,
//               "accessoriesPrice": 5.0,
//               "locationPrice": 110.0,
//               "distancePrice": 0.0,
//               "payLater": false
