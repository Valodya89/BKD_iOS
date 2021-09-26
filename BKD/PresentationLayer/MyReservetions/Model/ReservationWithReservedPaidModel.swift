//
//  ReservationWithReservedPaidModel.swift
//  ReservationWithReservedPaidModel
//
//  Created by Karine Karapetyan on 13-09-21.
//

import Foundation

enum MyReservationState {
    case startRide
    case stopRide
    case payDistancePrice
    case maykePayment
    case payRentalPrice
    case driverWaithingApproval
}

struct ReservationWithReservedPaidModel {
    public var isActiveStartRide: Bool = false
    public var isRegisterNumber: Bool = false
    public var myReservationState: MyReservationState
}

