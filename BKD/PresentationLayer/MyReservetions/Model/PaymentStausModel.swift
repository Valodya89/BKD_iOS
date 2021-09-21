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
    public var paymentButtonType: String?

}


