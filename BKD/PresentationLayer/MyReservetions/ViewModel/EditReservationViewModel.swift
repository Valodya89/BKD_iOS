//
//  EditReservationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-01-22.
//

import Foundation

final class EditReservationViewModel {
    lazy var detailsVM = DetailsViewModel()

    
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
                           search: SearchModel,
                           editReservationModel: EditReservationModel?) -> EditReservationModel {
        
        let editReservation = EditReservationModel()
       return editReservation.getNewReservetionSearchInfo(carId: carId,
                                          startDate: startDate,
                                                          search: search, editReservation: editReservationModel)
    }
    
    ///Checke if location fields are filled
    func ifLocationsAreFilled(oldSearch: SearchModel,
                              newSearch: SearchModel) -> Bool {
        if (!newSearch.isPickUpCustomLocation && (newSearch.pickUpLocation == nil)) ||
            (!newSearch.isRetuCustomLocation &&  newSearch.returnLocation == nil) {
            return false
        }
        return true
    }
    
    ///check if reservation has been edited
    func ifReservetionEdited(oldSearch: SearchModel,
                        newSearch: SearchModel,
                        oldDrivers: [DriverToRent],
                        oldAccessories: [EditAccessory],
                        editReservationModel: EditReservationModel?) -> Bool {
        
        if ifDateOfRentEdited(oldSearch: oldSearch,
                              newSearch: newSearch){
            return true
            
        } else if ifEditedAdditionalDriver(editReservationModel: editReservationModel,
                                           oldDrivers: oldDrivers) {
            return true
        } else if ifEditedAccessories(editReservationModel: editReservationModel,
                                      oldAccessories: oldAccessories) {
            return true
        }
        
        return ifLocationEdited(oldSearch: oldSearch,
                                newSearch: newSearch)
    }
    
    
    //Check if the date of the rent has been edited
    func ifDateOfRentEdited(oldSearch: SearchModel,
                            newSearch: SearchModel) -> Bool {
        
        if !ifLocationsAreFilled(oldSearch: oldSearch,
                                newSearch: newSearch) {
            return false
        }
        
        if (oldSearch.returnDate != newSearch.returnDate) ||
            (oldSearch.returnTime != newSearch.returnTime) {
            return true
        }
        return false
    }
    
    ///check if the location has been edited
    func ifLocationEdited(oldSearch: SearchModel,
                          newSearch: SearchModel) -> Bool {
        
        if !ifLocationsAreFilled(oldSearch: oldSearch,
                                newSearch: newSearch) {
            return false
        }
        
        //Pick up location
        if oldSearch.isPickUpCustomLocation && (oldSearch.isPickUpCustomLocation == newSearch.isPickUpCustomLocation) {
            if (oldSearch.pickUpLocationLatitude != newSearch.pickUpLocationLatitude) ||
                (oldSearch.pickUpLocationLongitude != newSearch.pickUpLocationLongitude) {
                return true
            }
        } else if !oldSearch.isPickUpCustomLocation && (oldSearch.isPickUpCustomLocation == newSearch.isPickUpCustomLocation) {
            if oldSearch.pickUpLocationId != newSearch.pickUpLocationId {
                return true
            }
        }
        else if oldSearch.isPickUpCustomLocation != newSearch.isPickUpCustomLocation {
            return true
        }
        
        //Return location
        if oldSearch.isRetuCustomLocation && (oldSearch.isRetuCustomLocation == newSearch.isRetuCustomLocation) {
            if (oldSearch.returnLocationLatitude != newSearch.returnLocationLatitude) ||
                (oldSearch.returnLocationLongitude != newSearch.returnLocationLongitude) {
                return true
            }
        } else if !oldSearch.isRetuCustomLocation && (oldSearch.isRetuCustomLocation == newSearch.isRetuCustomLocation) {
            if oldSearch.returnLocationId != newSearch.returnLocationId {
                return true
            }
        }
        else if oldSearch.isRetuCustomLocation != newSearch.isRetuCustomLocation {
            return true
        }
        return false
    }
    
    
    ///Check if the additional drivers has been edited
    func ifEditedAdditionalDriver(editReservationModel: EditReservationModel?,
                                  oldDrivers: [DriverToRent]) -> Bool {
        if  MyDriversViewModel().isEdietedDriverList(oldDrivers: oldDrivers, editedDrivers: editReservationModel?.additionalDrivers ?? []) {
            return true
        }
        return false
    }
    
    
    ///Check if the accessories has been edited
    func ifEditedAccessories(editReservationModel: EditReservationModel?,
                                  oldAccessories: [EditAccessory]) -> Bool {
        if AccessoriesViewModel().isEditedAccessoryList(oldAccessories: oldAccessories, editedAccessories: editReservationModel?.accessories ?? []) {
            return true
        }
        return false
    }
    
    
    ///If custom loaction deselected
    func ifCustomLoactionDeselected(tag: Int,
                                    oldSearch: SearchModel,
                                    newSearch: SearchModel) -> Bool {
        
        if tag == 4 && oldSearch.isPickUpCustomLocation && !newSearch.isPickUpCustomLocation {
            return true
        }
        if tag == 5 && oldSearch.isRetuCustomLocation &&
            !newSearch.isRetuCustomLocation {
            return true
        }
        return false
    }
    
    ///If custom loaction edited
    func ifCustomLoactionEdited(tag: Int,
                                oldSearch: SearchModel,
                                newSearch: SearchModel) -> Bool {
        
        if tag == 6 && oldSearch.isPickUpCustomLocation {
            return true
        }
        if tag == 7 && oldSearch.isRetuCustomLocation {
            return true
        }
        return false
    }
    
    
    ///Get vehicle model
    func getVehicleModel(currRent: Rent?) -> VehicleModel? {
        let allCars = ApplicationSettings.shared.allCars
        guard let currCar = allCars?.filter({ $0.id == currRent?.carDetails.id}).first else {
            return nil
        }
        let vehicleModel = CategoryViewModel().getVehicleModel(car: currCar, carType: currRent?.carDetails.type ?? "")
        return vehicleModel
    }
    
    
    ///Set value to edit price manager
    func setEditRentPrice(currRent: Rent?,
                          searchModel: SearchModel) {
        
        detailsVM.getTariff { [self] result in
            guard let _ = result else {return}
        
            guard let vehicleModel = getVehicleModel(currRent: currRent) else {return}
            var tariffSlideList = self.detailsVM.changeTariffListForUse(tariffs: result!, vehicleModel: vehicleModel)
            var currentTariff: TariffState = .hourly

            self.detailsVM.getCurrentTariff(search: searchModel,
                                            vehicleModel: vehicleModel,
                                            tariffSlideList: tariffSlideList,
                                            completion: { slideList, tariffState in
                tariffSlideList = slideList
                currentTariff = tariffState
                let currTariffIndex = TariffSlideViewModel().getTariffStateIndex(tariffState: currentTariff)
                let currTariffModel = tariffSlideList?[currTariffIndex]

                let optionIndex = currTariffModel?.segmentIndex
                if optionIndex != nil {
                    let currTariff = currTariffModel?.options?[optionIndex!]
                    let price = currTariff?.value
                    let specialOffert = currTariff?.specialValue
                    let discountPercent = currTariff?.discountPercent
                    EditedPriceManager.shared.carPrice = Double(price ?? "0.0")
                    EditedPriceManager.shared.carOffertPrice = Double(specialOffert ?? "0.0")
                    EditedPriceManager.shared.carDiscountPrecent = discountPercent ?? 0.0
                }
            })
        }
    }
    
    
    ///Set value to edit price manager
    func setEditPriceManager(currRent: Rent?,
                             searchModel: SearchModel,
                             oldSearchModel: SearchModel,
                             oldDrivers: [DriverToRent],
                             oldAccessories: [EditAccessory],
                             editReservationModel: EditReservationModel?) {
        
        if ifDateOfRentEdited(oldSearch: oldSearchModel,
                              newSearch: searchModel) {
            setEditRentPrice(currRent: currRent,
                             searchModel: searchModel)
        }
        
        if ifEditedAdditionalDriver(editReservationModel: editReservationModel,
                                    oldDrivers: oldDrivers) {
            
            
        }
        if ifEditedAccessories(editReservationModel: editReservationModel,
                               oldAccessories: oldAccessories) {
            
        }
       
//        if ifLocationEdited(oldSearch: oldSearchModel,
//                            newSearch: searchModel) {
//
//        }
    }
    
    //WARNING: -- need to cahnge
    ///Set value of edited location
    func setEditedLocationPrice(oldPrice: Double,
                             newPrice: Double) {
        EditedPriceManager.shared.pickUpCustomLocationPrice = 0.0
        EditedPriceManager.shared.returnCustomLocationPrice = 0.0
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
