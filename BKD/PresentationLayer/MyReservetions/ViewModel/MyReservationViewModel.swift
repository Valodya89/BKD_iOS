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
    case waithingApproval
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
    case ADMIN_FINISHED
    case CLOSED
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
    
    ///Get reservation´s history list
    func filterReservations(rents: [Rent]) ->(rent: [Rent], historys: [Rent])  {
        
        var rentsHistory: [Rent] = []
        var rentedCars: [Rent] = []
        for item in rents {
            if item.state == Constant.Keys.closed && item.distancePayment.payed {
                rentsHistory.append(item)
            } else {
                rentedCars.append(item)
            }
        }
        return (rentedCars, rentsHistory)
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
    
    ///Check is active start ride(Is less then 15 minute before start)
     func isActiveStartRide(start: Double) -> Bool {
        let duration = Date().getDistanceByComponent(.minute, toDate: Date(timeIntervalSince1970: start)).minute
        return duration ?? 0 <= 15
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
   
    ///Get payment option
    func getPaymentOption(reservationState: MyReservationState) -> PaymentOption {
        switch reservationState {
        case .startRide:
            return .none
        case .stopRide:
            return .none
        case .payDistancePrice:
            return .distance
        case .maykePayment:
            return .depositRental
        case .payRentalPrice:
            return .rental
        case .waithingApproval:
            return .none
        }
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
    
    
    ///Get stop ride time
    func getStopRideTime(endDate: Double ) -> (day: Int?, hour: Int, minute: Int) {
        
        let stopTime = endDate - Date().timeIntervalSince1970
        if stopTime > 0 {
           let m = stopTime  / 60
            let h = m / 60
            var hours = Int(h)
            var day = 0
            if h > 24 {
                day = Int(h / 24)
                hours -= day * 24
                let minute = m - Double(((day * 24) + hours) * 60)
                return (Int(day), Int(hours) + 3, Int(minute))
            }
            return (0, Int(h) + 3, Int(m))
        } else {
            return (nil, 0, 0)
        }
    }

   
}
