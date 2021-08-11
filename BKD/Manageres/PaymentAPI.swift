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
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getWallet,
             .attachCard,
             .payWithAttachedCard,
             .deleteCard:
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
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getWallet:
            return .get
        case .attachCard:
            return .post
        case .payWithAttachedCard:
            return .post
        case .deleteCard:
            return .delete
        }
    }
}
