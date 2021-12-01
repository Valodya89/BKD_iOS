//
//  PaymentAPI.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 10.08.21.
//

import Foundation

enum PaymentAPI: APIProtocol {
    
    case getWallet
    case attachCard
    case payWithAttachedCard
    case deleteCard
    case getPaymentTypes
    case molliePayment(amount: String,
                       paymentMethod: String)
    
    var base: String {
        return BKDBaseURLs.payment.rawValue
    }
    
    var path: String {
        switch self {
        case .getWallet:
            return "api/wallet"
        case .attachCard:
            return "api/cards/attach/hy"
        case .payWithAttachedCard:
            return "api/cards/attached/deposit"
        case .deleteCard:
            return "api/cards/"
        case .getPaymentTypes:
            return "api/mollie/payment-type"
        case .molliePayment:
            return "api/mollie/payment"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getWallet,
             .attachCard,
             .payWithAttachedCard,
             .deleteCard,
             .getPaymentTypes,
             .molliePayment:
            return ["Content-Type": "application/json"]
        }
    }
    
    var query: [String : String] {
        switch self {
        case .getWallet:
            return [:]
        case .attachCard:
            return [:]
        case .payWithAttachedCard:
            return [:]
        case .deleteCard:
            return [:]
        case .getPaymentTypes:
            return [:]
        case .molliePayment:
            return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getWallet:
            return nil
        case .attachCard:
            return nil
        case .payWithAttachedCard:
            return nil
        case .deleteCard:
            return nil
        case .getPaymentTypes:
            return nil
        case let .molliePayment(amount, paymentMethod):
            return [
                "amount" : amount,
                "paymentMethod" : paymentMethod
            ]
        }
    }
    
    var formData: MultipartFormData? {
        switch self {
        case .getWallet:
            return nil
        case .attachCard:
            return nil
        case .payWithAttachedCard:
            return nil
        case .deleteCard:
            return nil
        case .getPaymentTypes:
            return nil
        case .molliePayment:
            return nil
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getWallet,
             .getPaymentTypes:
            return .get
        case .attachCard,
             .molliePayment:
            return .post
        case .payWithAttachedCard:
            return .post
        case .deleteCard:
            return .delete
        }
    }
}
