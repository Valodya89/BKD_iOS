//
//  PaymentViewModel.swift
//  BKD
//
//  Created by Albert Mnatsakanyan on 10.08.21.
//

import Foundation

final class PaymentViewModel {
    
    private let network = SessionNetwork()
    
    
    func getAttachedCardURL(completion: @escaping (Result<String, BkdError>) -> Void) {
        
        network.request(with: URLBuilder(from: PaymentAPI.attachCard)) { (result) in
            switch result {
            case .success(let data):
                guard let attachedCardResponse = BkdConverter<BaseResponseModel<AttachedCardResponse>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                guard let attachedCardURL = attachedCardResponse.content?.checkoutUrl else {
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                completion(.success(attachedCardURL))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
                break
            }
        }
    }
    
    ///Get list og payment types
    func getPaymentTypes(completion: @escaping (PaymentTypesResponse?) -> Void) {
        
        network.request(with: URLBuilder(from: PaymentAPI.getPaymentTypes)) { (result) in
            switch result {
            case .success(let data):
                guard let paymentTypesResponse = BkdConverter<BaseResponseModel<PaymentTypesResponse>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(nil)
                    return
                }
            
                completion(paymentTypesResponse.content)
            case .failure(let error):
                print(error.description)
                completion(nil)
                break
            }
        }
    }
    
    ///Get bancontact payment type
    func  getBancontactPaymentType(paymentType: BancontactCard) -> String {
        switch paymentType {
        case .ing:
            return "IDEAL"
        case .bnp:
            return ""
        case .kbc:
            return "KBC"
        case .bancontact:
            return "BANCONTACT"
        }
    }
    
    
    ///Get payment type
    func  getOtherPaymentType(paymentType: PaymentType) -> String {
        switch paymentType {
        case .creditCard:
            return "CREDIT_CARD"
        case .applePay:
            return "APPLEPAY"
        case .payPal:
            return ""
        case .kaartlazer:
            return "KARTLIZER"//??
        case .bancontact:
            return "BANCONTACT" //??
        }
    }
    
    ///Get payment name
    private func getPaymentName(isBancontact: Bool,
                                bancontactType: BancontactCard?,
                                otherPaymentType: PaymentType?) -> String {
        if isBancontact {
            return getBancontactPaymentType(paymentType: bancontactType!)
        } else {
            return getOtherPaymentType(paymentType: otherPaymentType!)
        }
    }
    
    ///Get amount for payment
    private func getAmount(paymentOption:  PaymentOption,
                           vehicleModel: VehicleModel) -> String {
        switch paymentOption {
        case .deposit:
            let value = vehicleModel.depositPrice
            let roundedValue = round(value * 100) / 100.0
            return String(roundedValue)
        case .depositRental:
            let value1 = vehicleModel.depositPrice
            let roundedValue = round(value1 * 100) / 100.0
            let value2 = vehicleModel.totalPrice
            let roundedValue2 = round(value2 * 100) / 100.0
            return String(roundedValue + roundedValue2)
        case .payLater:
            return ""
        case .none:
            return ""
        }
    }
    
    ///Get parts array
    private func getParts(paymentOption:  PaymentOption) -> [String] {
        switch paymentOption {
        case .deposit:
            return ["DEPOSIT"]
        case .depositRental:
            return ["RENT", "DEPOSIT"]
        case .payLater:
            return [""]
        case .none:
            return [""]
        }
    }
    
    ///Get Payment url
    func getPaymentUrl(isBancontact:  Bool,
                       bancontactType: BancontactCard?,
                       otherPaymentType: PaymentType?,
                       paymentOption:  PaymentOption,
                       vehicleModel: VehicleModel,
                       completion: @escaping (Result<String, BkdError>) -> Void) {
        
        let paymentName: String = getPaymentName(isBancontact: isBancontact,
                                                 bancontactType: bancontactType,
                                                 otherPaymentType: otherPaymentType)
        let amount: String = getAmount(paymentOption: paymentOption,
                                       vehicleModel: vehicleModel)
        let parts: [String] = getParts(paymentOption: paymentOption)
        
        network.request(with: URLBuilder(from: PaymentAPI.molliePayment(amount: amount,
                                                                        paymentMethod: paymentName,
                                                                        rentId: vehicleModel.rent?.id ?? "",
                                                                        parts:parts ))) { (result) in
            switch result {
            case .success(let data):
                guard let attachedCardResponse = BkdConverter<BaseResponseModel<AttachedCardResponse>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                guard let attachedCardURL = attachedCardResponse.content?.checkoutUrl else {
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                completion(.success(attachedCardURL))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
                break
            }
        }
    }
    
  
    ///Get pay pal url
    func getPayPalUrl(paymentOption:  PaymentOption,
                      vehicleModel: VehicleModel,
                       completion: @escaping (Result<String, BkdError>) -> Void) {
        
        let amount: String = getAmount(paymentOption: paymentOption,
                                       vehicleModel: vehicleModel)
        let parts: [String] = getParts(paymentOption: paymentOption)
        
        network.request(with: URLBuilder(from: PaymentAPI.payPalPayment(amount: amount,
                                     rentId: vehicleModel.rent?.id ?? "",
                                    parts:parts ))) { (result) in
            switch result {
            case .success(let data):
                guard let attachedCardResponse = BkdConverter<BaseResponseModel<AttachedCardResponse>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                guard let attachedCardURL = attachedCardResponse.content?.checkoutUrl else {
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                completion(.success(attachedCardURL))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
                break
            }
        }
    }
    
    
    
    ///Get user wallet
    func getWallet(completion: @escaping (Result<UserWallet, BkdError>) -> Void) {
        network.request(with: URLBuilder(from: PaymentAPI.getWallet)) { (result) in
            switch result {
            case .success(let data):
                guard let userWallet = BkdConverter<BaseResponseModel<UserWallet>>.parseJson(data: data as Any) else {
                    print("error")
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                guard let userWallet = userWallet.content else {
                    completion(.failure(BkdError(error: .serverError)))
                    return
                }
                completion(.success(userWallet))
            case .failure(let error):
                print(error.description)
                completion(.failure(BkdError(error: .responseError(error.description))))
                break
            }
        }
    }
    
}
