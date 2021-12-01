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
    
    ///Get payment type
    func  getPaymentType(paymentType: BancontactCard) -> String {
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
    
    ///Get Payment url
    func getPaymentUrl(paymentType: BancontactCard, amount: String,
                       completion: @escaping (Result<String, BkdError>) -> Void) {
        
        let paymentName = getPaymentType(paymentType: paymentType)
        
        network.request(with: URLBuilder(from: PaymentAPI.molliePayment(amount: amount, paymentMethod: paymentName))) { (result) in
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
    
}
