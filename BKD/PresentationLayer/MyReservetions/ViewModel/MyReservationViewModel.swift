//
//  MyReservationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-11-21.
//

import UIKit


enum MyReservationState: String {
    case startRide
    case stopRide
    case payDistancePrice
    case maykePayment
    case payRentalPrice
    case driverWaithingApproval
}

//enum ReservationViewType: String {
//
//
//    case payDistancePrice
//    case maykePayment
//    case payRentalPrice
//    case waithingForApproval
//    case reservedPaid
//}


enum RentState: String {
    
    case DRAFT
    case COMPLETED
    case START_DEFECT_CHECK
    case START_ODOMETER_CHECK
    case STARTED
    case END_DEFECT_CHECK
    case END_ODOMETER_CHECK
    case FINISHED
}

class MyReservationViewModel: NSObject {
    
    ///Get Additional driver current list
    func getAdditionalDrives(rent: Rent) -> [DriverToRent] {
        var additionalDrivers = rent.additionalDrivers
        additionalDrivers?.insert(rent.driver, at: 0)
        additionalDrivers?.removeAll(where: { $0.id == (rent.currentDriver!.id) })
        return additionalDrivers ?? []
    }
    
    ///Get car´s reservations
    func getReservations( completion: @escaping ([Rent]?) -> Void) {

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getRents)) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<[Rent]>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
   
    ///Get car´s reservations
    func changeDriver(rentId: String,
                      driverId: String,
                      completion: @escaping (Rent?) -> Void) {

        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.changeDriver(id: rentId, driverId: driverId))) { (result) in
            
            switch result {
            case .success(let data):
                guard let result = BkdConverter<BaseResponseModel<Rent>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
                print(result.content as Any)
                completion(result.content)

            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///Get reservation view type
    func getReservationState(rent: Rent) -> MyReservationState {
        if (rent.depositPayment.payed &&
            rent.depositPayment.transactionId != nil) && (rent.rentPayment.payed && rent.rentPayment.transactionId != nil) {
            return MyReservationState.startRide
            
        } else if (rent.depositPayment.payed &&
                   rent.depositPayment.transactionId != nil) && !rent.rentPayment.payed {
            
            return MyReservationState.payRentalPrice
            
        }  else if (!rent.depositPayment.payed && !rent.rentPayment.payed) || rent.price.payLater  {
                   return MyReservationState.maykePayment
                   
               }
        return MyReservationState.maykePayment
    }
   
    
    ///Get price which user will pay
    func getPriceToPay(rent: Rent) -> Double {
        if (rent.depositPayment.payed &&
                   rent.depositPayment.transactionId != nil) && !rent.rentPayment.payed {
            
            return rent.rentPayment.amount
            
        }  else if (!rent.depositPayment.payed && !rent.rentPayment.payed) || rent.price.payLater  {
            return rent.rentPayment.amount +  rent.depositPayment.amount
                   
            }
        return rent.distancePayment.amount
    }
    
    ///Get price which user will pay
    func getPaidPrice(rent: Rent) -> Double {
        if (rent.depositPayment.payed &&
            rent.depositPayment.transactionId != nil) && (rent.rentPayment.payed && rent.rentPayment.transactionId != nil) && !rent.distancePayment.payed  {
            return rent.rentPayment.amount +  rent.depositPayment.amount
            
        } else if (rent.depositPayment.payed &&
                   rent.depositPayment.transactionId != nil) && !rent.rentPayment.payed {
            
            return rent.rentPayment.amount +  rent.depositPayment.amount + rent.distancePayment.amount
            
        }
        return 0.0
    }
}
