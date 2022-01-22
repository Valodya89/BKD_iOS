//
//  EditReservationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-01-22.
//

import Foundation

final class EditReservationViewModel {
    
    ///Get search model
    func getSearch(rent: Rent) -> SearchModel {
        let startDate = Date().doubleToDate(doubleDate: rent.startDate)
        let endDate = Date().doubleToDate(doubleDate: rent.endDate)
        var search = SearchModel()
        search.pickUpDate = startDate
        search.returnDate = endDate
        search.pickUpTime = startDate
        search.returnTime = endDate
        
        //Pickup location
        if rent.pickupLocation.type == Constant.Keys.custom,
           let pickupLocation = rent.pickupLocation.customLocation {
            search.pickUpLocation = pickupLocation.name
            search.pickUpLocationLatitude = pickupLocation.latitude
            search.pickUpLocationLongitude = pickupLocation.longitude
            search.isPickUpCustomLocation = true
        } else if let pickupParking = rent.pickupLocation.parking {
            search.pickUpLocation = pickupParking.name
            search.pickUpLocationId = pickupParking.id
            search.pickUpLocationLongitude = pickupParking.longitude
            search.pickUpLocationLatitude
            = pickupParking.latitude
        }
        
        //Return location
        if rent.returnLocation.type == Constant.Keys.custom,
           let returnLocation = rent.returnLocation.customLocation {
            search.returnLocation = returnLocation.name
            search.returnLocationLatitude = returnLocation.latitude
            search.returnLocationLongitude = returnLocation.longitude
            search.isRetuCustomLocation = true
        } else if let returnParkin = rent.returnLocation.parking {
            search.returnLocation = returnParkin.name
            search.returnLocationId = returnParkin.id
            search.returnLocationLongitude = returnParkin.longitude
            search.returnLocationLatitude
            = returnParkin.latitude
        }
        return search
    }
    
    
    ///Is edit date later than before
    func isEditeDateLater(editSearch: SearchModel, oldSearch: SearchModel) -> Bool {
        if let editDate = editSearch.returnDate,
           let editTime = editSearch.returnTime {
        let editReturnDate = (Date().combineDate(date: editDate, withTime: editTime)
            )!.timeIntervalSince1970
            let oldReturnDate = (Date().combineDate(date: oldSearch.returnDate ?? Date(), withTime: oldSearch.returnTime ?? Date())
                )!.timeIntervalSince1970
            return editReturnDate >= oldReturnDate
        }
       
        return true
    }
    
    ///Get new value of reservation
    func getNewReservetion(carId:String,
                           startDate: Double,
                           search: SearchModel) -> EditReservationModel {
        let editReservation = EditReservationModel()
       return editReservation.getNewReservetionSearchInfo(carId: carId,
                                          startDate: startDate,
                                          search: search)
    }
    
}

//"pickupLocation": {
//              "type": "PARKING",
//              "customLocation": null,
//              "parking": {
//                  "id": "60606bcaa4bc313937b3f45f",
//                  "name": "BKD OFFICE 2",
//                  "longitude": 50.816328,
//                  "latitude": 4.409351
//              }
//          },
//          "returnLocation": {
//              "type": "CUSTOM",
//              "customLocation": {
//                  "name": "4 Orbeli Brothers St, Yerevan 0033, Armenia",
//                  "longitude": 44.495214968919754,
//                  "latitude": 40.19437500097584
//              },
//              "parking": null
//          },


/*
 
 
 {
     "carId": "61815f3296b3233b4995c625",
     "startDate": 1636395213876,
     "endDate": 1636395213876,
     "accessories": [
         {
             "id": "61506ec81464ab42a0e2f31e",
             "count": 1
         }
     ],
     "additionalDrivers": [],
     "pickupLocation": {
         "type": "CUSTOM",
         "customLocation": {
             "name": "Masivi city",
             "longitude": 45.5,
             "latitude": 47.8
         }
     },
     "returnLocation": {
         "type": "CUSTOM",
         "customLocation": {
             "name": "Masivi city",
             "longitude": 45.5,
             "latitude": 47.8
         }
     }
 }
 */
