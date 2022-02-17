//
//  PaymentStausModel.swift
//  PaymentStausModel
//
//  Created by Karine Karapetyan on 14-09-21.
//

import Foundation

struct   PaymentStatusModel {
    public var status: String
    public var paymentType: String?
    public var isActivePaymentBtn: Bool = false
    public var price: Double?
    public var paid: String?
    public var paymentButtonType: String?
    public var waitingStatus: String?
    public var waitingForDistanc: Bool = false


}


